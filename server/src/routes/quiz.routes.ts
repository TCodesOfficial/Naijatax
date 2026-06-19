import { Router } from 'express';
import { getQuestions, submitScore, getHistory } from '../controllers/quiz.controller.js';
import { requireAuth, optionalAuth } from '../auth/auth.middleware.js';

const router = Router();

// Questions are viewable to all (but scores only save for authenticated users)
router.get('/questions', optionalAuth, getQuestions);

// Auth-required: Save and retrieve scores
router.post('/scores', requireAuth, submitScore);
router.get('/scores/history', requireAuth, getHistory);

export default router;
