import { Response } from 'express';

export function successResponse(res: Response, data: any, statusCode = 200) {
  return res.status(statusCode).json({ success: true, data });
}

export function errorResponse(res: Response, code: string, message: string, statusCode = 500) {
  return res.status(statusCode).json({ success: false, error: { code, message } });
}
