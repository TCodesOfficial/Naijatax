import { Request, Response, NextFunction } from 'express';
import { ZodError } from 'zod';
import { Prisma } from '@prisma/client';

interface AppError extends Error {
  statusCode?: number;
  status?: number;
  code?: string;
}

const GENERIC_500_MESSAGE =
  'Something went wrong on our end. Please try again later.';

export function errorHandler(
  err: AppError,
  req: Request,
  res: Response,
  next: NextFunction
) {
  let statusCode = err.statusCode ?? err.status ?? 500;
  let message = err.message ?? 'Internal Server Error';
  let code = err.code;
  let details: string | Array<{ field: string; message: string }> | undefined = undefined;
  const meta = (err as any).meta;

  if (err instanceof ZodError) {
    statusCode = 400;
    code = 'VALIDATION_ERROR';
    message = 'Validation failed';
    details = err.errors.map((e) => ({
      field: e.path.join('.'),
      message: e.message,
    }));
  } else if (err instanceof Prisma.PrismaClientKnownRequestError) {
    if (err.code === 'P2002') {
      statusCode = 409;
      code = 'CONFLICT';
      message = 'Conflict: Unique constraint failed';
      const target = (err.meta?.target as string[]) ?? undefined;
      details = target ? `Unique field failed: ${target.join(', ')}` : undefined;
    } else if (err.code === 'P2025') {
      statusCode = 404;
      code = 'NOT_FOUND';
      message = 'Record not found';
    } else if (err.code === 'P2003') {
      // Foreign-key violation: the referenced row doesn't exist.
      statusCode = 404;
      code = 'NOT_FOUND';
      message = 'The referenced record does not exist.';
    }
  } else if (err.name === 'MulterError') {
    statusCode = 400;
    code = 'UPLOAD_ERROR';
    message = err.message;
  }

  if (statusCode === 500) {
    console.error('Unexpected Server Error:', err);
    // Never leak internal error text (stack details, DB messages) to clients.
    message = GENERIC_500_MESSAGE;
    code = 'INTERNAL_ERROR';
    details = undefined;
  } else {
    console.warn(`API Warning [${statusCode}]: ${message}`, details || '');
  }

  res.status(statusCode).json({
    success: false,
    error: {
      code: code || 'INTERNAL_ERROR',
      message,
      details,
    },
  });
}
