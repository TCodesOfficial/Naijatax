import { NextFunction, Request, Response } from 'express';
import * as jose from 'jose';
import { env } from '../config/env.js';

export interface DecodedUser {
  id: string;
  email: string;
  role: string;
}

let _publicKey: CryptoKey | null = null;

async function getPublicKey(): Promise<CryptoKey> {
  if (_publicKey) return _publicKey;

  const jwksUrl = `${env.SUPABASE_URL}/auth/v1/.well-known/jwks.json`;
  const res = await fetch(jwksUrl);
  if (!res.ok) throw new Error(`Failed to fetch JWKS: ${res.status}`);
  const jwks = await res.json() as { keys: jose.JWK[] };
  const jwk = jwks.keys[0];
  _publicKey = (await jose.importJWK(jwk, jwk.alg)) as CryptoKey;
  return _publicKey;
}

async function decodeToken(token: string): Promise<DecodedUser> {
  const publicKey = await getPublicKey();
  const { payload } = await jose.jwtVerify(token, publicKey, {
    algorithms: ['ES256'],
  });
  const p = payload as Record<string, unknown>;
  return {
    id: (p.sub as string) || '',
    email: (p.email as string) || '',
    role: (p.role as string) || 'USER',
  };
}

export async function requireAuth(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Access token required. Please log in or sign up.' },
    });
  }

  try {
    req.user = await decodeToken(authHeader.split(' ')[1]);
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

export async function optionalAuth(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    req.user = undefined;
    return next();
  }

  try {
    req.user = await decodeToken(authHeader.split(' ')[1]);
  } catch {
    req.user = undefined;
  }
  next();
}
