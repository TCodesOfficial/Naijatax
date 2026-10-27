import { Response, Request } from 'express';
import { z } from 'zod';
import {
  getQuizQuestions,
  checkQuizAnswer,
  gradeAndSaveScore,
  getQuizScoreHistory,
} from '../services/quiz.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse, errorResponse } from '../utils/response.js';

const checkSchema = z.object({
  selectedIndex: z.number().int().min(0),
});

const answersSchema = z.object({
  answers: z
    .array(
      z.object({
        questionId: z.string().min(1),
        selectedIndex: z.number().int().min(0),
      }),
    )
    .min(1)
    .max(50),
});

export const getQuestions = asyncHandler(async (req: Request, res: Response) => {
  const count = Math.min(Math.max(parseInt(req.query.count as string) || 7, 1), 50);
  const questions = await getQuizQuestions(count);
  successResponse(res, questions);
});

// Reveal correctness/explanation for a single question AFTER the user answers.
export const checkAnswer = asyncHandler(async (req: Request, res: Response) => {
  // The route is /questions/:id/check, so the URL parameter is named `id`.
  // Reading `questionId` here made every answer fail validation.
  const { id: questionId } = z
    .object({ id: z.string().min(1) })
    .parse(req.params);
  const { selectedIndex } = checkSchema.parse(req.body);

  const result = await checkQuizAnswer(questionId, selectedIndex);
  if (!result) {
    return errorResponse(res, 'NOT_FOUND', 'Question not found.', 404);
  }
  successResponse(res, result);
});

export const submitScore = asyncHandler(async (req: Request, res: Response) => {
  const { answers } = answersSchema.parse(req.body);
  const quizScore = await gradeAndSaveScore(req.user!.id, answers);
  successResponse(res, quizScore, 201);
});

export const getHistory = asyncHandler(async (req: Request, res: Response) => {
  const history = await getQuizScoreHistory(req.user!.id);
  successResponse(res, history);
});
