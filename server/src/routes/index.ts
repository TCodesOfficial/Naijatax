import { Router, Request, Response } from 'express';
import taxRoutes from './tax.routes.js';
import aiRoutes from './ai.routes.js';
import forumRoutes from './forum.routes.js';
import quizRoutes from './quiz.routes.js';
import newsRoutes from './news.routes.js';
import userRoutes from './user.routes.js';

const router = Router();

// Health-check
router.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    status: 'NaijaTax Enlighten API is running ✅',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  });
});

// Sub-routers
router.use('/tax', taxRoutes);
router.use('/ai', aiRoutes);
router.use('/forum', forumRoutes);
router.use('/quiz', quizRoutes);
router.use('/news', newsRoutes);
router.use('/users', userRoutes);

export default router;
