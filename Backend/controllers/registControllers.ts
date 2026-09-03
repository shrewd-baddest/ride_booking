import bcrypt from "bcrypt";
import type { NextFunction, Request, Response } from "express";
import db from "../Database/database.js";
import { error, success } from "../utils/response.js";

export const register = async (
    req: Request,
    res: Response,
    next: NextFunction
): Promise<void> => {
    const {
        full_name,
        email,
        phone_number,
        password,
    } = req.body as {
        full_name: string;
        email?: string;
        phone_number: string;
        password: string;
    };

    try {
        if (!full_name || !phone_number || !password) {
            error(res, "Full name, phone number, and password are required", 400);
            return;
        }

        const existing = await db.query(
            "SELECT id FROM users WHERE phone_number = $1 LIMIT 1",
            [phone_number]
        );

        if (existing.rowCount) {
            error(res, "Phone number already registered", 409);
            return;
        }

        const hash = await bcrypt.hash(password, 10);
        const userResult = await db.query(
            `INSERT INTO users (full_name, email, phone_number, password, is_verified)
             VALUES ($1, $2, $3, $4, TRUE)
             RETURNING id, full_name, email, phone_number`,
            [full_name, email ?? null, phone_number, hash]
        );

        success(res, { user: userResult.rows[0] }, "Registration successful", 201);
    } catch (err) {
        if ((err as { code?: string }).code === "23505") {
            error(res, "Phone number already registered", 409);
            return;
        }
        next(err);
    }
};