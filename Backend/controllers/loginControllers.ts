import bcrypt from "bcrypt";
import type { NextFunction, Request, Response } from "express";
import db from "../Database/database.js";
import { error, success } from "../utils/response.js";
import { sign } from "../utils/tokens.js";

export const loginUser = async (
    req: Request,
    res: Response,
    next: NextFunction
): Promise<void> => {
    const { phone_number, password } = req.body as Partial<{
        phone_number: string;
        password: string;
    }>;

    if (!phone_number || !password) {
        error(res, "Phone number and password are required", 400);
        return;
    }

    try {
        const result = await db.query(
            "SELECT * FROM users WHERE phone_number = $1 LIMIT 1",
            [phone_number]
        );
        const user = result.rows[0];

        if (!user) {
            error(res, "Invalid credentials", 401);
            return;
        }

        const passwordMatch = await bcrypt.compare(password, user.password as string);

        if (!passwordMatch) {
            error(res, "Invalid credentials", 401);
            return;
        }

        const token = sign({
            id: Number(user.id),
            phone_number: user.phone_number as string,
        });

        success(
            res,
            {
                token,
                user: {
                    id: user.id,
                    full_name: user.full_name,
                    email: user.email,
                    phone_number: user.phone_number,
                },
            },
            "success"
        );
    } catch (err) {
        next(err);
    }
};
