import type { Response } from "express";
import db from "../Database/database.js";
import { error, success } from "../utils/response.js";
import type { AuthenticatedRequest } from "../middlewares/auth.js";

export const createRide = async (
    req: AuthenticatedRequest,
    res: Response
): Promise<void> => {
    const {
        driver_id,
        from_location,
        to_location,
        distance,
        duration,
        created_at,
    } = req.body as {
        driver_id?: string | null;
        from_location?: string;
        to_location?: string;
        distance?: number;
        duration?: number;
        created_at?: string;
    };

    if (
        !req.userId ||
        !from_location ||
        !to_location ||
        typeof distance !== "number" ||
        typeof duration !== "number"
    ) {
        error(res, "Ride details are required", 400);
        return;
    }

    try {
        const result = await db.query(
            `INSERT INTO rides
                (driver_id, user_id, from_location, to_location, distance, duration, created_at)
             VALUES ($1, $2, $3, $4, $5, $6, COALESCE($7::timestamptz, NOW()))
             RETURNING *`,
            [
                driver_id || null,
                req.userId,
                from_location,
                to_location,
                distance,
                duration,
                created_at || null,
            ]
        );

        success(res, { ride: result.rows[0] }, "Ride created", 201);
    } catch (cause) {
        console.error("Failed to create ride", cause);
        error(res, "Ride could not be saved", 500);
    }
};
