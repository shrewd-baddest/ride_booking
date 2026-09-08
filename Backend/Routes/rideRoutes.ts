import express from "express";
import { createRide } from "../controllers/rideControllers.js";
import { requireAuth } from "../middlewares/auth.js";

const rideRouter = express.Router();

rideRouter.post("/", requireAuth, createRide);

export default rideRouter;
