import { Router } from 'express';
import { sendMessage, getSessionsList, getSessionDetailHandler, deleteSessionHandler } from '../controllers/ai.controller.js';
import { requireAuth } from '../auth/auth.middleware.js';

const router = Router();

// All AI routes require authentication
router.post('/message', requireAuth, sendMessage);
router.get('/sessions', requireAuth, getSessionsList);
router.get('/sessions/:id', requireAuth, getSessionDetailHandler);
router.delete('/sessions/:id', requireAuth, deleteSessionHandler);

export default router;
