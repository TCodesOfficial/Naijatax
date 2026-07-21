import { Response, Request } from 'express';
import { z } from 'zod';
import {
  getQuizQuestions,
  submitQuizScore,
  getQuizScoreHistory,
} from '../services/quiz.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse } from '../utils/response.js';

const scoreSchema = z.object({
  score: z.number().int().nonnegative(),
  totalQuestions: z.number().int().positive(),
});

export const getQuestions = asyncHandler(async (req: Request, res: Response) => {
  const count = Math.min(Math.max(parseInt(req.query.count as string) || 7, 1), 50);
  const questions = await getQuizQuestions(count);
  successResponse(res, questions);
});

export const submitScore = asyncHandler(async (req: Request, res: Response) => {
  const { score, totalQuestions } = scoreSchema.parse(req.body);
  const quizScore = await submitQuizScore(req.user!.id, score, totalQuestions);
  successResponse(res, quizScore, 201);
});

export const getHistory = asyncHandler(async (req: Request, res: Response) => {
  const history = await getQuizScoreHistory(req.user!.id);
  successResponse(res, history);
});
