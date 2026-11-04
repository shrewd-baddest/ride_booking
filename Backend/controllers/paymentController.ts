import type { Request, Response } from "express";
import db from "../Database/database.js";
import type { AuthenticatedRequest } from "../middlewares/auth.js";
import { error, success } from "../utils/response.js";

interface DarajaTokenResponse {
    access_token?: string;
}

interface DarajaStkResponse {
    CheckoutRequestID?: string;
    ResponseCode?: string;
    ResponseDescription?: string;
    CustomerMessage?: string;
    errorMessage?: string;
}

const getMpesaBaseUrl = (): string =>
    process.env.MPESA_ENVIRONMENT === "production"
        ? "https://api.safaricom.co.ke"
        : "https://sandbox.safaricom.co.ke";

const formatPhoneNumber = (phoneNumber: unknown): string | null => {
    if (typeof phoneNumber !== "string") return null;

    let phone = phoneNumber.trim().replace(/[\s-]/g, "");
    if (phone.startsWith("+")) phone = phone.substring(1);

    if (/^(07|01)\d{8}$/.test(phone)) {
        return `254${phone.substring(1)}`;
    }
    if (/^254[17]\d{8}$/.test(phone)) {
        return phone;
    }
    return null;
};

const getTimestamp = (): string => {
    const now = new Date();
    const pad = (value: number): string => String(value).padStart(2, "0");

    return (
        `${now.getFullYear()}` +
        `${pad(now.getMonth() + 1)}` +
        `${pad(now.getDate())}` +
        `${pad(now.getHours())}` +
        `${pad(now.getMinutes())}` +
        `${pad(now.getSeconds())}`
    );
};

const getRequiredMpesaConfig = (): {
    consumerKey: string;
    consumerSecret: string;
    passkey: string;
    shortcode: string;
    callbackUrl: string;
} | null => {
    const consumerKey = process.env.MPESA_CONSUMER_KEY;
    const consumerSecret = process.env.MPESA_CONSUMER_SECRET;
    const passkey = process.env.MPESA_PASSKEY;
    const shortcode = process.env.MPESA_SHORTCODE;
    const callbackUrl = process.env.MPESA_CALLBACK_URL;

    if (!consumerKey || !consumerSecret || !passkey || !shortcode || !callbackUrl) {
        return null;
    }

    return { consumerKey, consumerSecret, passkey, shortcode, callbackUrl };
};

export const initiateMpesaPayment = async (
    req: AuthenticatedRequest,
    res: Response
): Promise<void> => {
    if (!req.userId) {
        error(res, "Authentication required", 401);
        return;
    }

    const { phone_number, amount } = req.body as {
        phone_number?: unknown;
        amount?: unknown;
    };
    const phone = formatPhoneNumber(phone_number);
    const parsedAmount =
        typeof amount === "number"
            ? amount
            : typeof amount === "string"
              ? Number(amount)
              : NaN;

    if (!phone) {
        error(res, "A valid Kenyan phone number is required", 400);
        return;
    }
    if (!Number.isFinite(parsedAmount) || parsedAmount <= 0) {
        error(res, "A valid payment amount is required", 400);
        return;
    }

    const config = getRequiredMpesaConfig();
    if (!config) {
        error(
            res,
            "M-Pesa configuration is incomplete",
            503,
            [{
                missing: [
                    "MPESA_CONSUMER_KEY",
                    "MPESA_CONSUMER_SECRET",
                    "MPESA_PASSKEY",
                    "MPESA_SHORTCODE",
                    "MPESA_CALLBACK_URL",
                ],
            }],
        );
        return;
    }

    try {
        const baseUrl = getMpesaBaseUrl();
        const credentials = Buffer.from(
            `${config.consumerKey}:${config.consumerSecret}`,
        ).toString("base64");

        const tokenResponse = await fetch(
            `${baseUrl}/oauth/v1/generate?grant_type=client_credentials`,
            {
                headers: { Authorization: `Basic ${credentials}` },
            },
        );
        const tokenData = (await tokenResponse.json()) as DarajaTokenResponse & {
            errorMessage?: string;
        };

        if (!tokenResponse.ok || !tokenData.access_token) {
            error(
                res,
                tokenData.errorMessage || "Could not authenticate with M-Pesa",
                502,
            );
            return;
        }

        const timestamp = getTimestamp();
        const password = Buffer.from(
            `${config.shortcode}${config.passkey}${timestamp}`,
        ).toString("base64");
        const stkAmount = Math.ceil(parsedAmount);

        const pendingPayment = await db.query(
            `SELECT p.id
             FROM payments p
             JOIN rides r ON r.id = p.ride_id
             WHERE r.user_id = $1
               AND p.payment_status = 'pending'
             ORDER BY r.created_at DESC
             LIMIT 1`,
            [req.userId],
        );

        if (pendingPayment.rows.length === 0) {
            error(res, "No pending ride payment was found", 404);
            return;
        }

        const stkResponse = await fetch(
            `${baseUrl}/mpesa/stkpush/v1/processrequest`,
            {
                method: "POST",
                headers: {
                    Authorization: `Bearer ${tokenData.access_token}`,
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    BusinessShortCode: config.shortcode,
                    Password: password,
                    Timestamp: timestamp,
                    TransactionType: "CustomerPayBillOnline",
                    Amount: stkAmount,
                    PartyA: phone,
                    PartyB: config.shortcode,
                    PhoneNumber: phone,
                    CallBackURL: config.callbackUrl,
                    AccountReference: `RIDE-${pendingPayment.rows[0].id}`,
                    TransactionDesc: "Ride payment",
                }),
            },
        );
        const stkData = (await stkResponse.json()) as DarajaStkResponse;

        if (!stkResponse.ok || stkData.ResponseCode !== "0") {
            error(
                res,
                stkData.errorMessage ||
                    stkData.ResponseDescription ||
                    "M-Pesa payment request failed",
                502,
            );
            return;
        }

        await db.query(
            `UPDATE payments
             SET payment_status = 'processing'
             WHERE id = $1`,
            [pendingPayment.rows[0].id],
        );

        success(
            res,
            {
                checkoutRequestId: stkData.CheckoutRequestID,
                customerMessage: stkData.CustomerMessage,
            },
            "M-Pesa payment request sent",
        );
    } catch (cause) {
        console.error("Failed to initiate M-Pesa payment", cause);
        error(res, "M-Pesa payment request could not be completed", 502);
    }
};

export const mpesaCallback = async (
    req: Request,
    res: Response
): Promise<void> => {
    const callback = req.body?.Body?.stkCallback;
    const paymentStatus =
        callback?.ResultCode === 0 ? "completed" : "failed";

    try {
        await db.query(
            `UPDATE payments
             SET payment_status = $1
             WHERE id = (
                 SELECT id
                 FROM payments
                 WHERE payment_status = 'processing'
                 ORDER BY id DESC
                 LIMIT 1
             )`,
            [paymentStatus],
        );
    } catch (cause) {
        console.error("Failed to update M-Pesa payment status", cause);
    }

    if (callback?.ResultCode === 0) {
        console.log("M-Pesa payment completed:", callback.CheckoutRequestID);
    } else {
        console.warn(
            "M-Pesa payment failed:",
            callback?.ResultCode,
            callback?.ResultDesc,
        );
    }

    res.status(200).json({
        ResultCode: 0,
        ResultDesc: "Accepted",
    });
};
