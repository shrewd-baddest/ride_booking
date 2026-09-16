import  jwt  from 'jsonwebtoken';
import type { NextFunction, Request, Response } from "express";
import { verify } from "../utils/tokens.js";
import { error } from "../utils/response.js";

export interface AuthenticatedRequest extends Request {
    userId?: string;
}

export const requireAuth = (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
): void => {
    const authorization = req.header("authorization");
    const token = authorization?.startsWith("Bearer ")
        ? authorization.substring("Bearer ".length)
        : null;

    if (!token) {
        error(res, "Authentication required", 401);
        return;
    }

    try {
        req.userId = jwt.verify(token, process.env.JWT_SECRET as string) as string;
        
        next();
    } catch {
        error(res, "Invalid or expired token", 401);
    }
};
