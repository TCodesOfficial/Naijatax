import { NextFunction, Request, Response } from 'express';
import * as jose from 'jose';
import { env } from '../config/env.js';
import { prisma } from '../config/database.js';
import { errorResponse } from '../utils/response.js';

export interface DecodedUser {
  id: string;
  email: string;
  role: string;
}

const SUPABASE_ISSUER = `${env.SUPABASE_URL.replace(/\/+$/, '')}/auth/v1`;
// API keys (legacy JWT format) carry these roles; they must never authenticate.
const REJECTED_ROLES = new Set(['anon', 'service_role']);

// Remote JWKS: jose handles caching and refetches automatically when an
// unknown kid appears (Supabase signing-key rotation).
let _jwks: ReturnType<typeof jose.createRemoteJWKSet> | null = null;

function getJwks(): ReturnType<typeof jose.createRemoteJWKSet> {
  if (!_jwks) {
    _jwks = jose.createRemoteJWKSet(
      new URL(`${SUPABASE_ISSUER}/.well-known/jwks.json`),
      { cooldownDuration: 30_000, cacheMaxAge: 10 * 60_000 },
    );
  }
  return _jwks;
}

async function decodeToken(token: string): Promise<DecodedUser> {
  const { payload } = await jose.jwtVerify(token, getJwks(), {
    issuer: SUPABASE_ISSUER,
    audience: 'authenticated',
    algorithms: ['ES256', 'RS256'],
  });
  const p = payload as Record<string, unknown>;

  const tokenRole = typeof p.role === 'string' ? p.role : '';
  const appMeta = (p.app_metadata ?? {}) as Record<string, unknown>;
  const metaRole = typeof appMeta.role === 'string' ? appMeta.role : '';
  if (REJECTED_ROLES.has(tokenRole) || REJECTED_ROLES.has(metaRole)) {
    throw new Error('API keys are not valid access tokens');
  }

  const id = (p.sub as string) || '';
  if (!id) throw new Error('Token missing subject');

  return {
    id,
    email: (p.email as string) || '',
    role: metaRole || 'USER',
  };
}

export async function requireAuth(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return errorResponse(
      res,
      'UNAUTHORIZED',
      'Access token required. Please log in or sign up.',
      401,
    );
  }

  try {
    req.user = await decodeToken(authHeader.split(' ')[1]);
    next();
  } catch {
    return errorResponse(
      res,
      'INVALID_TOKEN',
      'Your session has expired or is invalid. Please log in again.',
      401,
    );
  }
}

// The Supabase JWT's role claim is always "authenticated" for real users,
// so admin status comes from our own users.role column.
export async function requireAdmin(req: Request, res: Response, next: NextFunction) {
  if (!req.user) {
    return errorResponse(
      res,
      'UNAUTHORIZED',
      'Access token required. Please log in or sign up.',
      401,
    );
  }

  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      select: { role: true },
    });
    if (user?.role !== 'ADMIN') {
      return errorResponse(res, 'FORBIDDEN', 'Admin access required.', 403);
    }
    next();
  } catch (err) {
    next(err);
  }
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
