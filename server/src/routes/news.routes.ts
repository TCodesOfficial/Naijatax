import { Router } from 'express';
import { getArticles, getMetrics, syncNews } from '../controllers/news.controller.js';
import { requireAuth } from '../auth/auth.middleware.js';

const router = Router();

router.get('/', getArticles);
router.get('/metrics', getMetrics);
router.post('/sync', requireAuth, syncNews);

export default router;
