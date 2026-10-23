import { Request, Response } from 'express';
import { syncTaxNews, getPublicArticles } from '../services/news.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse } from '../utils/response.js';

export const getPublicArticlesController = asyncHandler(async (req: Request, res: Response) => {
  const featured = req.query.featured === 'true';
  const category = req.query.category as string | undefined;
  const limit = Math.min(Math.max(parseInt(req.query.limit as string) || 50, 1), 100);
  const articles = await getPublicArticles(featured, category, limit);
  successResponse(res, articles);
});

export const syncNews = asyncHandler(async (_req: Request, res: Response) => {
  const result = await syncTaxNews();
  successResponse(res, result);
});
