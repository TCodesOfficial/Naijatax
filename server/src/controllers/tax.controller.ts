// import { Response, Request } from 'express';
// import { z } from 'zod';
// import { calculateUnifiedTax, saveTaxProfile, getLatestTaxProfile, getTaxHistory, searchVatItems } from '../services/tax.service.js';
// import { parseStatementText } from '../services/ai.service.js';
// import { asyncHandler } from '../utils/asyncHandler.js';
// import { successResponse, errorResponse } from '../utils/response.js';
// import pdfParse from 'pdf-parse';

// const taxCalculationSchema = z.object({
//   monthlyIncome: z.number({ required_error: 'Monthly income is required' }).nonnegative(),
//   rentPaid: z.number().nonnegative().optional().default(0),
//   pensionRate: z.number().min(0).max(1).optional().default(0.08),
//   turnover: z.number().nonnegative().optional().default(0),
//   assets: z.number().nonnegative().optional().default(0),
//   isMonthly: z.boolean().optional().default(true),
// });

// export const calculateTax = asyncHandler(async (req: Request, res: Response) => {
//   const parsedBody = taxCalculationSchema.parse(req.body);
//   const result = calculateUnifiedTax(parsedBody);

//   if (req.user) {
//     await saveTaxProfile(req.user.id, result, parsedBody.pensionRate, parsedBody.rentPaid);
//   }

//   successResponse(res, result);
// });

// export const fetchLatestProfile = asyncHandler(async (req: Request, res: Response) => {
//   if (!req.user) {
//     return errorResponse(res, 'UNAUTHORIZED', 'Authentication required', 401);
//   }
//   const profile = await getLatestTaxProfile(req.user.id);
//   if (!profile) return successResponse(res, null);

//   const result = calculateUnifiedTax({
//     monthlyIncome: Number(profile.monthlyIncome),
//     rentPaid: Number(profile.rentPaid),
//     pensionRate: Number(profile.pensionRate),
//     turnover: Number(profile.turnover ?? 0),
//     assets: Number(profile.assets ?? 0),
//   });
//   successResponse(res, result);
// });

// export const fetchTaxHistory = asyncHandler(async (req: Request, res: Response) => {
//   if (!req.user) {
//     return errorResponse(res, 'UNAUTHORIZED', 'Authentication required', 401);
//   }
//   const profiles = await getTaxHistory(req.user.id);
//   const results = profiles.map((p) => ({
//     id: p.id,
//     createdAt: p.createdAt,
//     ...calculateUnifiedTax({
//       monthlyIncome: Number(p.monthlyIncome),
//       rentPaid: Number(p.rentPaid),
//       pensionRate: Number(p.pensionRate),
//       turnover: 0,
//       assets: 0,
//     }),
//   }));
//   successResponse(res, results);
// });

// export const parseStatement = asyncHandler(async (req: Request, res: Response) => {
//   if (!req.file) {
//     return errorResponse(res, 'BAD_REQUEST', 'No statement file uploaded', 400);
//   }

//   try {
//     const data = await pdfParse(req.file.buffer);
//     const parsedData = await parseStatementText(data.text);
//     successResponse(res, parsedData);
//   } catch (error: unknown) {
//     console.error('Bank Statement Parse Error:', error);
//     errorResponse(res, 'STATEMENT_PARSING_FAILED', 'Unable to analyze the uploaded statement. Please ensure it is a valid bank statement PDF.', 500);
//   }
// });

// const searchQuerySchema = z.object({
//   q: z.string().max(100).optional(),
//   status: z.enum(['STANDARD', 'ZERO_RATED', 'EXEMPT']).optional(),
// });

// export const searchVat = asyncHandler(async (req: Request, res: Response) => {
//   const { q, status } = searchQuerySchema.parse(req.query);
//   const items = await searchVatItems(q, status);
//   successResponse(res, items);
// });


import { Request, Response } from 'express';
import pdfParse from 'pdf-parse';
import { z } from 'zod';
import { parseStatementText } from '../services/ai.service.js';
import { calculateUnifiedTax, getLatestTaxProfile, getTaxHistory, saveTaxProfile, searchVatItems } from '../services/tax.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { errorResponse, successResponse } from '../utils/response.js';

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
    // FIX: Pass parsedBody.turnover and parsedBody.assets so they actually save to Prisma!
    await saveTaxProfile(
      req.user.id, 
      result, 
      parsedBody.pensionRate, 
      parsedBody.rentPaid,
      parsedBody.turnover,
      parsedBody.assets
    );
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
    // Safe fallbacks to prevent errors if older profiles have empty fields
    turnover: Number(profile.turnover ?? 0),
    assets: Number(profile.assets ?? 0),
  });
  successResponse(res, result);
});

export const fetchTaxHistory = asyncHandler(async (req: Request, res: Response) => {
  if (!req.user) {
    return errorResponse(res, 'UNAUTHORIZED', 'Authentication required', 401);
  }
  const profiles = await getTaxHistory(req.user.id);
  const results = profiles.map((p) => ({
    id: p.id,
    createdAt: p.createdAt,
    ...calculateUnifiedTax({
      monthlyIncome: Number(p.monthlyIncome),
      rentPaid: Number(p.rentPaid),
      pensionRate: Number(p.pensionRate),
      turnover: Number(p.turnover ?? 0),
      assets: Number(p.assets ?? 0),
    }),
  }));
  successResponse(res, results);
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
  status: z.enum(['STANDARD', 'ZERO_RATED', 'EXEMPT']).optional(),
});

export const searchVat = asyncHandler(async (req: Request, res: Response) => {
  const { q, status } = searchQuerySchema.parse(req.query);
  const items = await searchVatItems(q, status);
  successResponse(res, items);
});
