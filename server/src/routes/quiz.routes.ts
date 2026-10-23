import { Router } from 'express';
import { getQuestions, checkAnswer, submitScore, getHistory } from '../controllers/quiz.controller.js';
import { requireAuth, optionalAuth } from '../auth/auth.middleware.js';

const router = Router();

// Questions are viewable to all (but answers only reveal per-question, after
// the user has picked an option)
router.get('/questions', optionalAuth, getQuestions);
router.post('/questions/:id/check', optionalAuth, checkAnswer);

// Auth-required: Save and retrieve scores
router.post('/scores', requireAuth, submitScore);
router.get('/scores/history', requireAuth, getHistory);

export default router;
