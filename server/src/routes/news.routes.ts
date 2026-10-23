import { Router } from 'express';
import { getPublicArticlesController, syncNews } from '../controllers/news.controller.js';
import { requireAuth, requireAdmin } from '../auth/auth.middleware.js';
import { errorResponse } from '../utils/response.js';

const router = Router();

// Public endpoints (no auth required)
router.get('/public', getPublicArticlesController);

// Proxy World Bank inflation data (avoids CORS issues on web)
router.get('/inflation', async (_req, res) => {
  try {
    const years = Math.min(Math.max(parseInt(_req.query.years as string) || 10, 1), 30);
    const endYear = new Date().getFullYear();
    const startYear = endYear - years + 1;
    const url = `https://api.worldbank.org/v2/country/NGA/indicator/FP.CPI.TOTL.ZG?format=json&per_page=${years * 3}&date=${startYear}:${endYear}`;
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 10000);
    const response = await fetch(url, { signal: controller.signal });
    clearTimeout(timeout);
    const data = await response.json();
    res.status(200).json({ success: true, data });
  } catch {
    errorResponse(res, 'INFLATION_FETCH_FAILED', 'Unable to fetch inflation data from World Bank API', 502);
  }
});

// Protected endpoints
router.post('/sync', requireAuth, requireAdmin, syncNews);

export default router;
