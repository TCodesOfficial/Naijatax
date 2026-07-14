import { Router } from 'express';
import { getArticles, getPublicArticlesController, getCategoriesController, getMetrics, syncNews } from '../controllers/news.controller.js';
import { requireAuth, requireAdmin } from '../auth/auth.middleware.js';

const router = Router();

// Public endpoints (no auth required)
router.get('/public', getPublicArticlesController);
router.get('/public/categories', getCategoriesController);
router.get('/metrics', getMetrics);

// Protected endpoints
router.get('/', getArticles);
router.post('/sync', requireAuth, requireAdmin, syncNews);

export default router;
