import { Request, Response, NextFunction } from 'express';
import { ZodError } from 'zod';
import { Prisma } from '@prisma/client';

export interface AppError extends Error {
  statusCode?: number;
  code?: string;
}

export function errorHandler(
  err: AppError,
  req: Request,
  res: Response,
  next: NextFunction
) {
  let statusCode = err.statusCode ?? 500;
  let message = err.message ?? 'Internal Server Error';
  let details: any = undefined;

  if (err instanceof ZodError) {
    statusCode = 400;
    message = 'Validation failed';
    details = err.errors.map((e) => ({
      field: e.path.join('.'),
      message: e.message,
    }));
  }

  if (err instanceof Prisma.PrismaClientKnownRequestError) {
    if (err.code === 'P2002') {
      statusCode = 409;
      message = 'Conflict: Unique constraint failed';
      const target = (err.meta?.target as string[]) ?? undefined;
      details = target ? `Unique field failed: ${target.join(', ')}` : undefined;
    } else if (err.code === 'P2025') {
      statusCode = 404;
      message = 'Record not found';
    }
  }

  if (statusCode === 500) {
    console.error('Unexpected Server Error:', err);
  } else {
    console.warn(`API Warning [${statusCode}]: ${message}`, details || '');
  }

  res.status(statusCode).json({
    success: false,
    error: {
      code: err.code || 'INTERNAL_ERROR',
      message,
      details,
    },
  });
}
