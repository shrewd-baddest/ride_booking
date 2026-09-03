import express from "express";
import { loginUser } from "../controllers/loginControllers.js";
import { register } from "../controllers/registControllers.js";

const authRouter = express.Router();

authRouter.post("/login", loginUser);
authRouter.post("/register", register);

export default authRouter;
