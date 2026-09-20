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
