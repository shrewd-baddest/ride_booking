import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { testDatabaseConnection } from "../Database/database.js";
import authRouter from "../Routes/authControllers.js";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());
app.use("/api/auth", authRouter);

const PORT = process.env.PORT || 3000;

app.listen(PORT, async () => {
  console.log(`🚀 Server running on port ${PORT}`);

  await testDatabaseConnection();
});