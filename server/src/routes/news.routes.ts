import { Router } from 'express';
import { getArticles, getMetrics, syncNews } from '../controllers/news.controller.js';
import { requireAuth, requireAdmin } from '../auth/auth.middleware.js';

const router = Router();

router.get('/', getArticles);
router.get('/metrics', getMetrics);
router.post('/sync', requireAuth, requireAdmin, syncNews);

export default router;
