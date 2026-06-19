import { Router, Request, Response } from 'express';
import { getTaxArticles, getEconomicMetrics, syncTaxNews } from '../services/news.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';

const router = Router();

// Guest-accessible: Read articles
router.get('/', asyncHandler(async (req: Request, res: Response) => {
  const featured = req.query.featured === 'true';
  const articles = await getTaxArticles(featured);
  res.status(200).json({ success: true, data: articles });
}));

// Guest-accessible: Get economic metrics
router.get('/metrics', asyncHandler(async (_req: Request, res: Response) => {
  const metrics = await getEconomicMetrics();
  res.status(200).json({ success: true, data: metrics });
}));

// Internal: Trigger a manual RSS sync (protect with a simple key check in production)
router.post('/sync', asyncHandler(async (_req: Request, res: Response) => {
  const result = await syncTaxNews();
  res.status(200).json({ success: true, data: result });
}));

export default router;
