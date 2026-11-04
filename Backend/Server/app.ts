import dotenv from "dotenv";

dotenv.config();

import express from "express";
import cors from "cors";
import { testDatabaseConnection } from "../Database/database.js";
import authRouter from "../Routes/authControllers.js";
import driverRouter from "../Routes/driverRoutes.js";
import rideRouter from "../Routes/rideRoutes.js";
import paymentRouter from "../Routes/paymentRoutes.js";

const app = express();

app.use(cors());
app.use(express.json());
app.use("/api/auth", authRouter);
app.use("/api/drivers", driverRouter);
app.use("/api/rides", rideRouter);
app.use("/api/payments", paymentRouter);

const PORT = process.env.PORT || 3000;

app.listen(PORT, async () => {
  console.log(`🚀 Server running on port ${PORT}`);

  await testDatabaseConnection();
});