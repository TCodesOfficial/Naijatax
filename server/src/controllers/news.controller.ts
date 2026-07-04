import { Request, Response } from 'express';
import { getTaxArticles, getEconomicMetrics, syncTaxNews } from '../services/news.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse } from '../utils/response.js';

export const getArticles = asyncHandler(async (req: Request, res: Response) => {
  const featured = req.query.featured === 'true';
  const articles = await getTaxArticles(featured);
  successResponse(res, articles);
});

export const getMetrics = asyncHandler(async (_req: Request, res: Response) => {
  const metrics = await getEconomicMetrics();
  successResponse(res, metrics);
});

export const syncNews = asyncHandler(async (_req: Request, res: Response) => {
  const result = await syncTaxNews();
  successResponse(res, result);
});
