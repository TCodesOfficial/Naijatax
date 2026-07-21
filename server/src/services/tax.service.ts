import { prisma } from '../config/database.js';

// ─── In-Memory TTL Cache ─────────────────────────────────────────────────────
class MemoryCache<T> {
  private cache = new Map<string, { data: T; expiresAt: number }>();

  get(key: string): T | null {
    const entry = this.cache.get(key);
    if (!entry) return null;
    if (Date.now() > entry.expiresAt) {
      this.cache.delete(key);
      return null;
    }
    return entry.data;
  }

  set(key: string, data: T, ttlMs: number) {
    this.cache.set(key, { data, expiresAt: Date.now() + ttlMs });
  }
}

const cache = new MemoryCache<any>();

export interface TaxAssessmentInput {
  monthlyIncome: number;
  rentPaid?: number;
  pensionRate?: number;
  turnover?: number;
  assets?: number;
  isMonthly?: boolean;
}

export interface TaxAssessmentResult {
  monthlyIncome: number;
  annualGross: number;
  pensionDeduction: number;
  rentRelief: number;
  taxableIncome: number;
  computedTax: number;
  netIncome: number;
  isExempt: boolean;
  citExemption: string;
  savings: number;
  breakdown: Array<{
    bracket: string;
    rate: number;
    taxableAmount: number;
    tax: number;
  }>;
}

export function calculateUnifiedTax(input: TaxAssessmentInput): TaxAssessmentResult {
  const isMonthly = input.isMonthly ?? true;
  const monthlyIncome = isMonthly ? input.monthlyIncome : input.monthlyIncome / 12;
  const annualGross = monthlyIncome * 12;

  const pensionRate = input.pensionRate ?? 0.08;
  const rentPaid = input.rentPaid ?? 0;

  const pensionDeduction = annualGross * pensionRate;
  const rentRelief = Math.min(rentPaid * 0.20, 500000);
  const taxableIncome = Math.max(0, annualGross - pensionDeduction - rentRelief);

  const brackets = [
    { limit: 800000, rate: 0.0, label: 'Exempt (First ₦800k)' },
    { limit: 3000000, rate: 0.15, label: 'First ₦3M @ 15%' },
    { limit: 3000000, rate: 0.20, label: 'Next ₦3M @ 20%' },
    { limit: 14000000, rate: 0.22, label: 'Next ₦14M @ 22%' },
    { limit: Infinity, rate: 0.25, label: 'Above ₦20.8M @ 25%' }
  ];

  let remainingIncome = taxableIncome;
  let computedTax = 0;
  const breakdown: TaxAssessmentResult['breakdown'] = [];
  const isExempt = annualGross <= 800000;

  if (!isExempt) {
    for (const bracket of brackets) {
      if (remainingIncome <= 0) break;
      const taxableAmount = Math.min(remainingIncome, bracket.limit);
      const taxForBracket = taxableAmount * bracket.rate;
      computedTax += taxForBracket;

      if (taxableAmount > 0) {
        breakdown.push({ bracket: bracket.label, rate: bracket.rate, taxableAmount, tax: taxForBracket });
      }
      remainingIncome -= taxableAmount;
    }
  } else {
    breakdown.push({ bracket: 'Exempt (Income below ₦800k)', rate: 0.0, taxableAmount: annualGross, tax: 0.0 });
  }

  const netIncome = annualGross - computedTax - pensionDeduction;

  // Old Pre-2025 Tax Act (for comparative savings analytics)
  const oldCRA = Math.max(200000, annualGross * 0.01) + (annualGross * 0.20);
  const oldTaxableIncome = Math.max(0, annualGross - oldCRA - pensionDeduction);

  const oldBands = [
    { limit: 300000, rate: 0.07 },
    { limit: 300000, rate: 0.11 },
    { limit: 500000, rate: 0.15 },
    { limit: 500000, rate: 0.19 },
    { limit: 1600000, rate: 0.21 },
    { limit: Infinity, rate: 0.24 }
  ];

  let oldRemaining = oldTaxableIncome;
  let oldTax = 0;

  for (const band of oldBands) {
    if (oldRemaining <= 0) break;
    const amt = Math.min(oldRemaining, band.limit);
    oldTax += amt * band.rate;
    oldRemaining -= amt;
  }

  const savings = Math.max(0, oldTax - computedTax);

  // CIT Exemption Status
  const turnover = input.turnover ?? 0;
  const assets = input.assets ?? 0;
  let citExemption = 'N/A (No business details provided)';

  if (turnover > 0 || assets > 0) {
    if (turnover <= 100000000 && assets <= 250000000) {
      citExemption = 'EXEMPT (Small Business Exemption)';
    } else if (turnover <= 500000000) {
      citExemption = 'TAXABLE_20 (Medium Business - 20% Rate)';
    } else {
      citExemption = 'TAXABLE_30 (Large Business - 30% Rate)';
    }
  }

  return {
    monthlyIncome, annualGross, pensionDeduction, rentRelief, taxableIncome,
    computedTax, netIncome, isExempt, citExemption, savings, breakdown
  };
}

export async function saveTaxProfile(userId: string, result: TaxAssessmentResult, pensionRate: number, rentPaid: number) {
  return await prisma.taxProfile.create({
    data: {
      userId,
      monthlyIncome: result.monthlyIncome,
      annualGross: result.annualGross,
      rentPaid,
      pensionRate,
      computedTax: result.computedTax,
      netIncome: result.netIncome,
      isExempt: result.isExempt,
      citExemption: result.citExemption,
    },
  });
}

export async function getLatestTaxProfile(userId: string) {
  return await prisma.taxProfile.findFirst({
    where: { userId },
    orderBy: { createdAt: 'desc' },
  });
}

export async function searchVatItems(query?: string, status?: string) {
  const cacheKey = `vat:${query || ''}:${status || ''}`;
  const cached = cache.get(cacheKey);
  if (cached) return cached;

  const where: Record<string, unknown> = {};
  if (query) {
    where.OR = [
      { name: { contains: query, mode: 'insensitive' } },
      { category: { contains: query, mode: 'insensitive' } },
    ];
  }
  if (status) {
    where.status = status;
  }
  const result = await prisma.vatItem.findMany({
    where: Object.keys(where).length > 0 ? where : undefined,
    orderBy: { category: 'asc' },
  });

  cache.set(cacheKey, result, 60 * 60 * 1000); // 1 hour TTL
  return result;
}
