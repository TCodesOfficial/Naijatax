import { Router } from 'express';
import { getArticles, getPublicArticlesController, getCategoriesController, getMetrics, syncNews } from '../controllers/news.controller.js';
import { requireAuth, requireAdmin } from '../auth/auth.middleware.js';

const router = Router();

// Public endpoints (no auth required)
router.get('/public', getPublicArticlesController);
router.get('/public/categories', getCategoriesController);
router.get('/metrics', getMetrics);

// Proxy World Bank inflation data (avoids CORS issues on web)
router.get('/inflation', async (_req, res) => {
  try {
    const years = parseInt(_req.query.years as string) || 10;
    const endYear = new Date().getFullYear();
    const startYear = endYear - years + 1;
    const url = `https://api.worldbank.org/v2/country/NGA/indicator/FP.CPI.TOTL.ZG?format=json&per_page=${years * 3}&date=${startYear}:${endYear}`;
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 15000);
    const response = await fetch(url, { signal: controller.signal });
    clearTimeout(timeout);
    const data = await response.json();
    res.status(200).json({ success: true, data });
  } catch (error) {
    res.status(502).json({ success: false, error: { code: 'INFLATION_FETCH_FAILED', message: 'Unable to fetch inflation data from World Bank API' } });
  }
});

// Protected endpoints
router.get('/', getArticles);
router.post('/sync', requireAuth, requireAdmin, syncNews);

export default router;
