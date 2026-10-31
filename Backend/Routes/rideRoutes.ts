import express from "express";
import { createRide, getRideHistory } from "../controllers/rideControllers.js";
import { requireAuth } from "../middlewares/auth.js";

const rideRouter = express.Router();

rideRouter.post("/", requireAuth, createRide);
rideRouter.get("/history", requireAuth, getRideHistory);

export default rideRouter;
