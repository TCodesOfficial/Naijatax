import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../config/env.js';

export interface DecodedUser {
  id: string;
  email: string;
  role: string;
}

// Extend Express Request type locally in this file
export interface AuthenticatedRequest extends Request {
  user?: DecodedUser;
}

export function requireAuth(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      error: {
        code: 'UNAUTHORIZED',
        message: 'Access token required. Please log in or sign up.',
      },
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, env.SUPABASE_JWT_SECRET) as any;
    
    // Supabase standard JWT claims: 'sub' contains the user UUID, 'email' contains the user email
    req.user = {
      id: decoded.sub || decoded.id,
      email: decoded.email,
      role: decoded.role || 'USER',
    };
    next();
  } catch (error) {
    return res.status(401).json({
      success: false,
      error: {
        code: 'INVALID_TOKEN',
        message: 'Your session has expired or is invalid. Please log in again.',
      },
    });
  }
}

export function optionalAuth(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    // Proceed as Guest
    req.user = undefined;
    return next();
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, env.SUPABASE_JWT_SECRET) as any;
    req.user = {
      id: decoded.sub || decoded.id,
      email: decoded.email,
      role: decoded.role || 'USER',
    };
    next();
  } catch (error) {
    // Even if token is expired/invalid, let guest proceed (or force login based on preference, but here we fall back to guest)
    req.user = undefined;
    next();
  }
}
