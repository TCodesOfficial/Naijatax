import { describe, it, expect } from 'vitest';
import { calculateUnifiedTax } from './tax.service.js';

// All cases use isMonthly: false (annual input) and explicit deductions so
// every expectation is hand-checkable. Defaults when unspecified:
// pensionRate 0.08, rentReliefRate 0.20 (capped at ₦500k).

describe('calculateUnifiedTax — progressive bands (NTA 2025)', () => {
  const annual = (monthlyIncome: number, extra = {}) => ({ monthlyIncome, isMonthly: false, pensionRate: 0, rentPaid: 0, ...extra });

  it('taxes income up to ₦800k at 0% and marks it exempt', () => {
    const r = calculateUnifiedTax(annual(800000));
    expect(r.computedTax).toBe(0);
    expect(r.isExempt).toBe(true);
    expect(r.taxableIncome).toBe(800000);
  });

  it('flips isExempt just above the ₦800k threshold', () => {
    const r = calculateUnifiedTax(annual(800001));
    expect(r.isExempt).toBe(false);
    expect(r.computedTax).toBeCloseTo(0.15, 6);
  });

  it('applies only the 15% slice at ₦1M', () => {
    const r = calculateUnifiedTax(annual(1000000));
    // 800k @ 0% + 200k @ 15% = 30,000
    expect(r.computedTax).toBe(30000);
    expect(r.netIncome).toBe(970000);
  });

  it('caps the 15% band exactly at ₦3M → ₦330,000', () => {
    const r = calculateUnifiedTax(annual(3000000));
    expect(r.computedTax).toBe(330000);
    expect(r.breakdown).toHaveLength(2);
  });

  it('reaches ₦1.95M at the ₦12M boundary', () => {
    const r = calculateUnifiedTax(annual(12000000));
    // 330k + 9M @ 18% = 330k + 1.62M
    expect(r.computedTax).toBe(1950000);
  });

  it('reaches ₦4.68M at the ₦25M boundary', () => {
    const r = calculateUnifiedTax(annual(25000000));
    // 1.95M + 13M @ 21% = 1.95M + 2.73M
    expect(r.computedTax).toBe(4680000);
  });

  it('reaches ₦10.43M at the ₦50M boundary', () => {
    const r = calculateUnifiedTax(annual(50000000));
    // 4.68M + 25M @ 23% = 4.68M + 5.75M
    expect(r.computedTax).toBe(10430000);
  });

  it('uses 25% only on income above ₦50M', () => {
    const r = calculateUnifiedTax(annual(60000000));
    // 10.43M + 10M @ 25% = 12.93M
    expect(r.computedTax).toBe(12930000);
    expect(r.breakdown.at(-1)?.rate).toBe(0.25);
  });

  it('returns the zero-income fallback breakdown row', () => {
    const r = calculateUnifiedTax(annual(0));
    expect(r.computedTax).toBe(0);
    expect(r.isExempt).toBe(true);
    expect(r.breakdown).toEqual([
      { bracket: 'Exempt (Taxable income is ₦0)', rate: 0, taxableAmount: 0, tax: 0 },
    ]);
  });
});

describe('calculateUnifiedTax — deductions', () => {
  it('subtracts pension and capped rent relief before banding', () => {
    const r = calculateUnifiedTax({
      monthlyIncome: 100000, // annual 1.2M (default isMonthly: true)
      pensionRate: 0.08,
      rentPaid: 1000000, // 20% → 200k relief
    });
    expect(r.pensionDeduction).toBe(96000);
    expect(r.rentRelief).toBe(200000);
    expect(r.taxableIncome).toBe(904000);
    // 800k @ 0% + 104k @ 15%
    expect(r.computedTax).toBe(15600);
  });

  it('caps rent relief at ₦500k', () => {
    const r = calculateUnifiedTax({
      monthlyIncome: 100000,
      pensionRate: 0,
      rentPaid: 5000000,
    });
    expect(r.rentRelief).toBe(500000);
    expect(r.taxableIncome).toBe(700000); // below the exemption threshold
    expect(r.isExempt).toBe(true);
    expect(r.computedTax).toBe(0);
  });

  it('gives identical results for monthly vs annual input', () => {
    const monthly = calculateUnifiedTax({ monthlyIncome: 100000 });
    const annual = calculateUnifiedTax({ monthlyIncome: 1200000, isMonthly: false });
    expect(monthly.annualGross).toBe(annual.annualGross);
    expect(monthly.computedTax).toBe(annual.computedTax);
    expect(monthly.taxableIncome).toBe(annual.taxableIncome);
  });
});

describe('calculateUnifiedTax — percentage (flat) mode', () => {
  it('applies the selected flat rate to taxable income', () => {
    const r = calculateUnifiedTax({
      monthlyIncome: 1000000,
      isMonthly: false,
      pensionRate: 0,
      rentPaid: 0,
      flatRate: 0.15,
    });
    expect(r.computedTax).toBe(150000);
    expect(r.breakdown).toHaveLength(1);
    expect(r.breakdown[0].bracket).toContain('Flat 15%');
  });

  it('does NOT grant the ₦800k exemption for a user-selected 0% rate', () => {
    const r = calculateUnifiedTax({
      monthlyIncome: 1000000,
      isMonthly: false,
      pensionRate: 0,
      rentPaid: 0,
      flatRate: 0,
    });
    expect(r.computedTax).toBe(0);
    expect(r.isExempt).toBe(false);
  });
});

describe('calculateUnifiedTax — comparative savings', () => {
  it('reports old-regime savings of ₦18,000 for a ₦1.2M earner', () => {
    const r = calculateUnifiedTax({
      monthlyIncome: 100000,
      pensionRate: 0,
      rentPaid: 0,
    });
    // New law: 800k @ 0% + 400k @ 15% = 60,000
    expect(r.computedTax).toBe(60000);
    // Old law: CRA = max(200k, 1%×1.2M) + 20%×1.2M = 440k
    // taxable 760k → 21k + 33k + 24k = 78k
    expect(r.savings).toBe(18000);
  });

  it('never reports negative savings', () => {
    const r = calculateUnifiedTax({ monthlyIncome: 40000, pensionRate: 0, rentPaid: 0 });
    expect(r.savings).toBeGreaterThanOrEqual(0);
  });
});

describe('calculateUnifiedTax — CIT classification', () => {
  const cit = (turnover: number, assets: number) =>
    calculateUnifiedTax({
      monthlyIncome: 100000,
      pensionRate: 0,
      rentPaid: 0,
      turnover,
      assets,
    }).citExemption;

  it('is N/A when no business details are provided', () => {
    expect(cit(0, 0)).toBe('N/A (No business details provided)');
  });

  it('grants small-business exemption within both caps', () => {
    expect(cit(50000000, 100000000)).toBe('EXEMPT (Small Business Exemption)');
    expect(cit(100000000, 250000000)).toBe('EXEMPT (Small Business Exemption)');
  });

  it('rejects the asset test when assets exceed ₦250M', () => {
    expect(cit(50000000, 300000000)).toBe(
      'TAXABLE_20 (Small Business conditions not met - 20% Rate)',
    );
  });

  it('rejects assets-only inputs with no reported turnover', () => {
    expect(cit(0, 300000000)).toBe(
      'TAXABLE_20 (Small Business conditions not met - 20% Rate)',
    );
  });

  it('uses 20% for medium turnover and 30% for large turnover', () => {
    expect(cit(200000000, 0)).toBe('TAXABLE_20 (Medium Business - 20% Rate)');
    expect(cit(500000000, 0)).toBe('TAXABLE_20 (Medium Business - 20% Rate)');
    expect(cit(500000001, 0)).toBe('TAXABLE_30 (Large Business - 30% Rate)');
    expect(cit(600000000, 0)).toBe('TAXABLE_30 (Large Business - 30% Rate)');
  });
});
