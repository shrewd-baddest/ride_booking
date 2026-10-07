import type { Response } from "express";
import db from "../Database/database.js";
import { error, success } from "../utils/response.js";
import type { AuthenticatedRequest } from "../middlewares/auth.js";

export const createRide = async (
    req: AuthenticatedRequest,
    res: Response
): Promise<void> => {
    const {
        from_location,
        to_location,
        distance,
        duration,
        created_at,
        pickup_latitude,
        pickup_longitude,
    } = req.body as {
        from_location?: string;
        to_location?: string;
        distance?: number;
        duration?: number;
        created_at?: string;
        pickup_latitude?: number;
        pickup_longitude?: number;
    };

    if (
        !req.userId ||
        !from_location ||
        !to_location ||
        typeof distance !== "number" ||
        typeof duration !== "number" ||
        typeof pickup_latitude !== "number" ||
        typeof pickup_longitude !== "number" ||
        !Number.isFinite(pickup_latitude) ||
        !Number.isFinite(pickup_longitude) ||
        pickup_latitude < -90 ||
        pickup_latitude > 90 ||
        pickup_longitude < -180 ||
        pickup_longitude > 180
    ) {
        error(res, "Ride details are required", 400);
        return;
    }

    try {
        await db.query("BEGIN");
        const driverResult = await db.query<{ id: string }>(
            `SELECT d.id
             FROM drivers d
             CROSS JOIN LATERAL (
                 SELECT 6371000 * 2 * ASIN(SQRT(LEAST(1,
                     POWER(SIN(RADIANS($1 - d.current_latitude) / 2), 2) +
                     COS(RADIANS(d.current_latitude)) * COS(RADIANS($1)) *
                     POWER(SIN(RADIANS($2 - d.current_longitude) / 2), 2)
                 ))) AS distance_meters
             ) distance
             WHERE d.current_latitude IS NOT NULL
               AND d.current_longitude IS NOT NULL
               AND d.location_updated_at >= NOW() - INTERVAL '5 minutes'
               AND NOT EXISTS (
                   SELECT 1
                   FROM rides active_ride
                   WHERE active_ride.driver_id = d.id
                     AND active_ride.status IN ('requested', 'accepted', 'in_progress')
               )
             ORDER BY distance.distance_meters
             LIMIT 1
             FOR UPDATE OF d SKIP LOCKED`,
            [pickup_latitude, pickup_longitude]
        );
        const driverId = driverResult.rows[0]?.id;

        if (!driverId) {
            await db.query("ROLLBACK");
            error(res, "No nearby drivers are currently available", 409);
            return;
        }

        const result = await db.query(
            `INSERT INTO rides
                (driver_id, user_id, from_location, to_location, distance, duration, created_at)
             VALUES ($1, $2, $3, $4, $5, $6, COALESCE($7::timestamptz, NOW()))
             RETURNING *`,
            [
                driverId,
                req.userId,
                from_location,
                to_location,
                distance,
                duration,
                created_at || null,
            ]
        );

        await db.query("COMMIT");
        success(res, { ride: result.rows[0] }, "Ride created", 201);
    } catch (cause) {
        await db.query("ROLLBACK").catch(() => undefined);
        console.error("Failed to create ride", cause);
        error(res, "Ride could not be saved", 500);
    }
};
