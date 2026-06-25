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
  savings: number; // Compared to the previous tax act
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
  
  const pensionRate = input.pensionRate ?? 0.08; // default 8% mandatory pension
  const rentPaid = input.rentPaid ?? 0;
  
  // 1. Calculate Deductions
  const pensionDeduction = annualGross * pensionRate;
  // Rent relief under NTA 2025: 20% of rent paid, capped at ₦500,000/year
  const rentRelief = Math.min(rentPaid * 0.20, 500000);
  
  const taxableIncome = Math.max(0, annualGross - pensionDeduction - rentRelief);

  // 2. Progressive brackets under NTA 2025 Reforms
  const brackets = [
    { limit: 800000, rate: 0.0, label: 'Exempt (First ₦800k)' },
    { limit: 3000000, rate: 0.15, label: 'First ₦3M @ 15%' },
    { limit: 3000000, rate: 0.20, label: 'Next ₦3M @ 20%' },
    { limit: 14000000, rate: 0.22, label: 'Next ₦14M @ 22%' },
    { limit: Infinity, rate: 0.25, label: 'Above ₦20.8M @ 25%' }
  ];

  let remainingIncome = taxableIncome;
  let computedTax = 0;
  const breakdown = [];

  // If gross is below the exemption threshold (₦800k), they are completely exempt
  const isExempt = annualGross <= 800000;

  if (!isExempt) {
    for (const bracket of brackets) {
      if (remainingIncome <= 0) break;
      const taxableAmount = Math.min(remainingIncome, bracket.limit);
      const taxForBracket = taxableAmount * bracket.rate;
      computedTax += taxForBracket;
      
      if (taxableAmount > 0) {
        breakdown.push({
          bracket: bracket.label,
          rate: bracket.rate,
          taxableAmount,
          tax: taxForBracket
        });
      }
      remainingIncome -= taxableAmount;
    }
  } else {
    breakdown.push({
      bracket: 'Exempt (Income below ₦800k)',
      rate: 0.0,
      taxableAmount: annualGross,
      tax: 0.0
    });
  }

  const netIncome = annualGross - computedTax - pensionDeduction;

  // 3. Compute Tax under Old Pre-2025 Tax Act (for comparative savings analytics)
  // Consolidation Relief Allowance (CRA): max(200k, 1% of gross) + 20% of gross
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

  // Savings equals the older tax burden minus the modern reformed tax
  const savings = Math.max(0, oldTax - computedTax);

  // 4. Evaluate CIT Exemption Status (Company Income Tax)
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
    monthlyIncome,
    annualGross,
    pensionDeduction,
    rentRelief,
    taxableIncome,
    computedTax,
    netIncome,
    isExempt,
    citExemption,
    savings,
    breakdown
  };
}
