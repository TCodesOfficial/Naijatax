import { NextFunction, Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../config/env.js';

export interface DecodedUser {
  id: string;
  email: string;
  role: string;
}

interface JwtPayload {
  sub?: string;
  id?: string;
  email?: string;
  role?: string;
}

function decodeToken(token: string): DecodedUser {
  const decoded = jwt.verify(token, env.SUPABASE_JWT_SECRET, { algorithms: ['HS256'] }) as JwtPayload;
  return {
    id: decoded.sub || decoded.id || '',
    email: decoded.email || '',
    role: decoded.role || 'USER',
  };
}

export function requireAuth(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Access token required. Please log in or sign up.' },
    });
  }

  try {
    req.user = decodeToken(authHeader.split(' ')[1]);
    next();
  } catch {
    return res.status(401).json({
      success: false,
      error: { code: 'INVALID_TOKEN', message: 'Your session has expired or is invalid. Please log in again.' },
    });
  }
}

export function requireAdmin(req: Request, res: Response, next: NextFunction) {
  if (!req.user || req.user.role !== 'ADMIN') {
    return res.status(403).json({
      success: false,
      error: { code: 'FORBIDDEN', message: 'Admin access required.' },
    });
  }
  next();
}

export function optionalAuth(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    req.user = undefined;
    return next();
  }

  try {
    req.user = decodeToken(authHeader.split(' ')[1]);
  } catch {
    req.user = undefined;
  }
  next();
}
