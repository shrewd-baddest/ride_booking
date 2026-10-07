import express from "express";
import {
	getDriverById,
	updateDriverLocation,
} from "../controllers/driverControllers.js";

const driverRouter = express.Router();

driverRouter.get("/:id", getDriverById);
driverRouter.patch("/:id/location", updateDriverLocation);

export default driverRouter;
