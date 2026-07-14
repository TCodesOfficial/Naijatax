import { Request, Response } from 'express';
import { getTaxArticles, getEconomicMetrics, syncTaxNews, getPublicArticles, getCategories } from '../services/news.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse } from '../utils/response.js';

export const getArticles = asyncHandler(async (req: Request, res: Response) => {
  const featured = req.query.featured === 'true';
  const articles = await getTaxArticles(featured);
  successResponse(res, articles);
});

export const getPublicArticlesController = asyncHandler(async (req: Request, res: Response) => {
  const featured = req.query.featured === 'true';
  const category = req.query.category as string | undefined;
  const limit = parseInt(req.query.limit as string) || 50;
  const articles = await getPublicArticles(featured, category, limit);
  successResponse(res, articles);
});

export const getCategoriesController = asyncHandler(async (_req: Request, res: Response) => {
  const categories = await getCategories();
  successResponse(res, categories);
});

export const getMetrics = asyncHandler(async (_req: Request, res: Response) => {
  const metrics = await getEconomicMetrics();
  successResponse(res, metrics);
});

export const syncNews = asyncHandler(async (_req: Request, res: Response) => {
  const result = await syncTaxNews();
  successResponse(res, result);
});
