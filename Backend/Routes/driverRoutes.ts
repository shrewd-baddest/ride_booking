import express from "express";
import { getDriverById } from "../controllers/driverControllers.js";

const driverRouter = express.Router();

driverRouter.get("/:id", getDriverById);

export default driverRouter;
