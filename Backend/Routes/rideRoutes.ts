import express from "express";
import { createRide, getRideHistory } from "../controllers/rideControllers.js";
import { requireAuth } from "../middlewares/auth.js";
import { initiateMpesaPayment } from "../controllers/paymentController.js";

const rideRouter = express.Router();

rideRouter.post("/", requireAuth, createRide);
rideRouter.get("/history", requireAuth, getRideHistory);
rideRouter.post("/payment", requireAuth, initiateMpesaPayment);

export default rideRouter;
