import { Response, Request } from 'express';
import { z } from 'zod';
import { calculateUnifiedTax, saveTaxProfile, searchVatItems } from '../services/tax.service.js';
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
    await saveTaxProfile(req.user.id, result, parsedBody.pensionRate);
  }

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
  } catch (error: any) {
    console.error('Bank Statement Parse Error:', error);
    errorResponse(res, 'STATEMENT_PARSING_FAILED', 'Unable to analyze statement format: ' + error.message, 500);
  }
});

export const searchVat = asyncHandler(async (req: Request, res: Response) => {
  const query = req.query.q as string | undefined;
  const items = await searchVatItems(query);
  successResponse(res, items);
});
