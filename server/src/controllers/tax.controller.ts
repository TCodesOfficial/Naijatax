import { Response } from 'express';
import { z } from 'zod';
import { prisma } from '../config/database.js';
import { calculateUnifiedTax } from '../services/tax.service.js';
import { parseStatementText } from '../services/ai.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { AuthenticatedRequest } from '../auth/auth.middleware.js';
import pdfParse from 'pdf-parse';

const taxCalculationSchema = z.object({
  monthlyIncome: z.number({ required_error: 'Monthly income is required' }).nonnegative(),
  rentPaid: z.number().nonnegative().optional().default(0),
  pensionRate: z.number().min(0).max(1).optional().default(0.08),
  turnover: z.number().nonnegative().optional().default(0),
  assets: z.number().nonnegative().optional().default(0),
  isMonthly: z.boolean().optional().default(true),
});

export const calculateTax = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  const parsedBody = taxCalculationSchema.parse(req.body);
  const result = calculateUnifiedTax(parsedBody);

  // If user is authenticated, persist calculation in the database
  if (req.user) {
    await prisma.taxProfile.create({
      data: {
        userId: req.user.id,
        monthlyIncome: result.monthlyIncome,
        annualGross: result.annualGross,
        rentPaid: result.rentRelief, // save deductible portion
        pensionRate: parsedBody.pensionRate,
        computedTax: result.computedTax,
        netIncome: result.netIncome,
        isExempt: result.isExempt,
        citExemption: result.citExemption,
      },
    });
  }

  res.status(200).json({
    success: true,
    data: result,
  });
});

export const parseStatement = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  if (!req.file) {
    return res.status(400).json({
      success: false,
      error: { code: 'BAD_REQUEST', message: 'No statement file uploaded' },
    });
  }

  try {
    // Parse PDF file buffer
    const dataBuffer = req.file.buffer;
    const data = await pdfParse(dataBuffer);
    
    // Process text with AI Statement Parser
    const parsedData = await parseStatementText(data.text);

    res.status(200).json({
      success: true,
      data: parsedData,
    });
  } catch (error: any) {
    console.error('❌ Bank Statement Parse Error:', error);
    res.status(500).json({
      success: false,
      error: { code: 'STATEMENT_PARSING_FAILED', message: 'Unable to analyze statement format: ' + error.message },
    });
  }
});

export const searchVat = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  const query = req.query.q as string | undefined;

  const items = await prisma.vatItem.findMany({
    where: query ? {
      OR: [
        { name: { contains: query, mode: 'insensitive' } },
        { category: { contains: query, mode: 'insensitive' } },
      ],
    } : undefined,
    take: 20,
  });

  res.status(200).json({
    success: true,
    data: items,
  });
});
