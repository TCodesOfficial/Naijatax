import { Response, Request } from 'express';
import { z } from 'zod';
import { calculateUnifiedTax, saveTaxProfile, getLatestTaxProfile, searchVatItems } from '../services/tax.service.js';
import { parseStatementText } from '../services/ai.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse, errorResponse } from '../utils/response.js';
import pdfParse from 'pdf-parse';

const taxCalculationSchema = z.object({
  monthlyIncome: z.number({ required_error: 'Monthly income is required' }).nonnegative(),
  rentPaid: z.number().nonnegative().optional().default(0),
  pensionRate: z.number().min(0).max(1).optional().default(0.08),
  turnover: z.number().nonnegative().optional().default(0),
  assets: z.number().nonnegative().optional().default(0),
  isMonthly: z.boolean().optional().default(true),
});

export const calculateTax = asyncHandler(async (req: Request, res: Response) => {
  const parsedBody = taxCalculationSchema.parse(req.body);
  const result = calculateUnifiedTax(parsedBody);

  if (req.user) {
    await saveTaxProfile(req.user.id, result, parsedBody.pensionRate, parsedBody.rentPaid);
  }

  successResponse(res, result);
});

export const fetchLatestProfile = asyncHandler(async (req: Request, res: Response) => {
  if (!req.user) {
    return errorResponse(res, 'UNAUTHORIZED', 'Authentication required', 401);
  }
  const profile = await getLatestTaxProfile(req.user.id);
  if (!profile) return successResponse(res, null);

  const result = calculateUnifiedTax({
    monthlyIncome: Number(profile.monthlyIncome),
    rentPaid: Number(profile.rentPaid),
    pensionRate: Number(profile.pensionRate),
    turnover: 0,
    assets: 0,
  });
  successResponse(res, result);
});

export const parseStatement = asyncHandler(async (req: Request, res: Response) => {
  if (!req.file) {
    return errorResponse(res, 'BAD_REQUEST', 'No statement file uploaded', 400);
  }

  try {
    const data = await pdfParse(req.file.buffer);
    const parsedData = await parseStatementText(data.text);
    successResponse(res, parsedData);
  } catch (error: unknown) {
    console.error('Bank Statement Parse Error:', error);
    errorResponse(res, 'STATEMENT_PARSING_FAILED', 'Unable to analyze the uploaded statement. Please ensure it is a valid bank statement PDF.', 500);
  }
});

const searchQuerySchema = z.object({
  q: z.string().max(100).optional(),
});

export const searchVat = asyncHandler(async (req: Request, res: Response) => {
  const { q } = searchQuerySchema.parse(req.query);
  const items = await searchVatItems(q);
  successResponse(res, items);
});
