import { Response } from 'express';
import { z } from 'zod';
import {
  getQuizQuestions,
  submitQuizScore,
  getQuizScoreHistory,
} from '../services/quiz.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { AuthenticatedRequest } from '../auth/auth.middleware.js';

const scoreSchema = z.object({
  score: z.number().int().nonnegative(),
  totalQuestions: z.number().int().positive(),
});

export const getQuestions = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  const questions = await getQuizQuestions();

  res.status(200).json({
    success: true,
    data: questions,
  });
});

export const submitScore = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'You must log in to record quiz scores.' },
    });
  }

  const { score, totalQuestions } = scoreSchema.parse(req.body);
  const quizScore = await submitQuizScore(req.user.id, score, totalQuestions);

  res.status(201).json({
    success: true,
    data: quizScore,
  });
});

export const getHistory = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Unauthorized' },
    });
  }

  const history = await getQuizScoreHistory(req.user.id);

  res.status(200).json({
    success: true,
    data: history,
  });
});
