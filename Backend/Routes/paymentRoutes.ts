import express from "express";
import {
    initiateMpesaPayment,
    mpesaCallback,
} from "../controllers/paymentController.js";
import { requireAuth } from "../middlewares/auth.js";

const paymentRouter = express.Router();

paymentRouter.post("/payment", requireAuth, initiateMpesaPayment);
paymentRouter.post("/callback", mpesaCallback);

export default paymentRouter;
