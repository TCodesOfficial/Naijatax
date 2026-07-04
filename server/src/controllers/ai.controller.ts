import { Response } from 'express';
import { z } from 'zod';
import {
  getSessions,
  getSessionDetail,
  deleteSession,
  sendChatMessage,
} from '../services/ai.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse, errorResponse } from '../utils/response.js';
import { Request } from 'express';

const messageSchema = z.object({
  content: z.string().min(1, 'Message content cannot be empty'),
  sessionId: z.string().optional(),
});

export const sendMessage = asyncHandler(async (req: Request, res: Response) => {
  const { content, sessionId } = messageSchema.parse(req.body);
  const result = await sendChatMessage(req.user!.id, content, sessionId);
  successResponse(res, result);
});

export const getSessionsList = asyncHandler(async (req: Request, res: Response) => {
  const sessions = await getSessions(req.user!.id);
  successResponse(res, sessions);
});

export const getSessionDetailHandler = asyncHandler(async (req: Request, res: Response) => {
  const session = await getSessionDetail(req.params.id, req.user!.id);
  if (!session) {
    return errorResponse(res, 'NOT_FOUND', 'Session not found', 404);
  }
  successResponse(res, session);
});

export const deleteSessionHandler = asyncHandler(async (req: Request, res: Response) => {
  const deleted = await deleteSession(req.params.id, req.user!.id);
  if (!deleted) {
    return errorResponse(res, 'NOT_FOUND', 'Session not found', 404);
  }
  successResponse(res, { message: 'Session deleted successfully' });
});
