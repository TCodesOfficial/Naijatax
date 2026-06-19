import { Response } from 'express';
import { z } from 'zod';
import { prisma } from '../config/database.js';
import { sendChatMessage } from '../services/ai.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { AuthenticatedRequest } from '../auth/auth.middleware.js';

const messageSchema = z.object({
  content: z.string().min(1, 'Message content cannot be empty'),
  sessionId: z.string().optional(),
});

export const sendMessage = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Chat sessions require user login.' },
    });
  }

  const { content, sessionId } = messageSchema.parse(req.body);
  const result = await sendChatMessage(req.user.id, content, sessionId);

  res.status(200).json({
    success: true,
    data: result,
  });
});

export const getSessions = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Unauthorized' },
    });
  }

  const sessions = await prisma.chatSession.findMany({
    where: { userId: req.user.id },
    orderBy: { updatedAt: 'desc' },
  });

  res.status(200).json({
    success: true,
    data: sessions,
  });
});

export const getSessionDetail = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Unauthorized' },
    });
  }

  const session = await prisma.chatSession.findUnique({
    where: { id: req.params.id },
    include: {
      messages: { orderBy: { createdAt: 'asc' } },
    },
  });

  if (!session || session.userId !== req.user.id) {
    return res.status(404).json({
      success: false,
      error: { code: 'NOT_FOUND', message: 'Session not found' },
    });
  }

  res.status(200).json({
    success: true,
    data: session,
  });
});

export const deleteSession = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Unauthorized' },
    });
  }

  const session = await prisma.chatSession.findUnique({
    where: { id: req.params.id },
  });

  if (!session || session.userId !== req.user.id) {
    return res.status(404).json({
      success: false,
      error: { code: 'NOT_FOUND', message: 'Session not found' },
    });
  }

  await prisma.chatSession.delete({
    where: { id: req.params.id },
  });

  res.status(200).json({
    success: true,
    message: 'Session deleted successfully',
  });
});
