import type { Request, Response } from "express";
import db from "../Database/database.js";
import { error, success } from "../utils/response.js";

export const getDriverById = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { id } = req.params;

  if (!id) {
    error(res, "Driver id is required", 400);
    return;
  }

  try {
    const result = await db.query(
      `SELECT
        id,
        name,
        phone_number,
        email,
        rating,
        license_number,
        created_at
      FROM drivers
      WHERE id = $1
      LIMIT 1`,
      [id]
    );

    const driver = result.rows[0];

    if (!driver) {
      error(res, "Driver not found", 404);
      return;
    }

    success(res, { driver }, "Driver details fetched successfully");
  } catch (cause) {
    console.error("Failed to fetch driver details", cause);
    error(res, "Driver details could not be loaded", 500);
  }
};

export const updateDriverLocation = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { id } = req.params;
  const { latitude, longitude } = req.body as {
    latitude?: number;
    longitude?: number;
  };

  if (
    !id ||
    typeof latitude !== "number" ||
    typeof longitude !== "number" ||
    !Number.isFinite(latitude) ||
    !Number.isFinite(longitude) ||
    latitude < -90 ||
    latitude > 90 ||
    longitude < -180 ||
    longitude > 180
  ) {
    error(res, "Valid driver coordinates are required", 400);
    return;
  }

  try {
    const result = await db.query(
      `UPDATE drivers
       SET current_latitude = $1,
           current_longitude = $2,
           location_updated_at = NOW()
       WHERE id = $3
       RETURNING id, current_latitude, current_longitude, location_updated_at`,
      [latitude, longitude, id]
    );

    if (result.rowCount === 0) {
      error(res, "Driver not found", 404);
      return;
    }

    success(res, { driver: result.rows[0] }, "Driver location updated");
  } catch (cause) {
    console.error("Failed to update driver location", cause);
    error(res, "Driver location could not be updated", 500);
  }
};
