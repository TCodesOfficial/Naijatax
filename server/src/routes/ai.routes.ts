import { Router } from 'express';
import { sendMessage, getSessions, getSessionDetail, deleteSession } from '../controllers/ai.controller.js';
import { requireAuth } from '../auth/auth.middleware.js';

const router = Router();

// All AI routes require authentication
router.post('/message', requireAuth, sendMessage);
router.get('/sessions', requireAuth, getSessions);
router.get('/sessions/:id', requireAuth, getSessionDetail);
router.delete('/sessions/:id', requireAuth, deleteSession);

export default router;
