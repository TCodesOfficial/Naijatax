import Parser from 'rss-parser';
import { prisma } from '../config/database.js';
import { env } from '../config/env.js';

const parser = new Parser();

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

  clear() {
    this.cache.clear();
  }
}

const cache = new MemoryCache<any>();

// Multiple RSS feeds for Nigerian tax/finance news
const RSS_FEEDS = [
  { url: 'https://nairametrics.com/category/taxation/feed/', source: 'Nairametrics' },
  { url: 'https://businessday.ng/category/tax/feed/', source: 'BusinessDay' },
  { url: 'https://www.punchng.com/topics/tax/feed/', source: 'Punch' },
  { url: 'https://www.vanguardngr.com/business/tax/feed/', source: 'Vanguard' },
  { url: 'https://www.thecable.ng/category/business/tax/feed/', source: 'TheCable' },
  { url: 'https://www.firs.gov.ng/feed/', source: 'FIRS Official' },
];

// Keywords for automatic categorization
const CATEGORY_KEYWORDS: Record<string, string[]> = {
  NTA_2025: ['nta 2025', 'nigeria tax act', 'tax reform', 'tax act 2025', 'nigeria revenue service', 'nrs', 'firs replaced'],
  PAYE: ['paye', 'personal income tax', 'pay as you earn', 'salary tax', 'minimum wage', 'rent relief', 'pension', 'tax bracket', 'tax band', 'tax threshold'],
  CIT: ['company income tax', 'cit', 'corporate tax', 'business tax', 'small business', 'sme tax', 'turnover', 'exempt', 'tax holiday', 'capital allowance'],
  VAT: ['vat', 'value added tax', 'zero-rated', 'exempt', 'standard rate', 'digital services tax', 'digital tax', 'input vat', 'output vat'],
  COMPLIANCE: ['filing', 'deadline', 'penalty', 'compliance', 'tax clearance', 'tcc', 'stamp duty', 'withholding tax', 'wht', 'capital gains', 'cgt', 'transfer pricing', 'vaids', 'amnesty', 'audit', 'filing deadline'],
};

function categorizeArticle(title: string, content: string, source: string): string {
  const text = (title + ' ' + content).toLowerCase();
  for (const [category, keywords] of Object.entries(CATEGORY_KEYWORDS)) {
    for (const keyword of keywords) {
      if (text.includes(keyword.toLowerCase())) return category;
    }
  }
  if (source.toLowerCase().includes('firs') || source.toLowerCase().includes('nrs')) return 'NTA_2025';
  return 'COMPLIANCE';
}

function normalizeArticle(item: any, source: string): Omit<import('@prisma/client').TaxArticle, 'id' | 'createdAt'> {
  const title = item.title || 'Untitled';
  const content = item.content || item.contentSnippet || '';
  const summary = item.contentSnippet?.substring(0, 200) + '...' || 'No summary available';
  const url = item.link || '';
  const category = categorizeArticle(title, content, source);
  return {
    title: title.substring(0, 255),
    summary: summary.substring(0, 500),
    content: content || summary,
    source,
    category,
    url,
    isFeatured: false,
  };
}

export async function syncTaxNews() {
  let totalCount = 0;
  for (const feed of RSS_FEEDS) {
    try {
      const feedData = await parser.parseURL(feed.url);
      let count = 0;
      for (const item of feedData.items) {
        if (!item.title || !item.contentSnippet) continue;
        const normalized = normalizeArticle(item, feed.source);
        const existing = await prisma.taxArticle.findFirst({
          where: { title: normalized.title },
        });
        if (!existing) {
          await prisma.taxArticle.create({ data: normalized });
          count++;
        }
      }
      totalCount += count;
    } catch (error) {
      // Skip failed feed silently
    }
  }
  // Invalidate article cache after sync
  cache.clear();
  return { success: true, newArticlesCount: totalCount };
}

export async function getPublicArticles(
  featuredOnly = false,
  category?: string,
  limit = 50
) {
  const cacheKey = `articles:${featuredOnly}:${category}:${limit}`;
  const cached = cache.get(cacheKey);
  if (cached) return cached;

  const where: any = featuredOnly ? { isFeatured: true } : {};
  if (category) where.category = category;

  const result = await prisma.taxArticle.findMany({
    where,
    orderBy: { createdAt: 'desc' },
    take: limit,
    select: {
      id: true,
      title: true,
      summary: true,
      source: true,
      category: true,
      url: true,
      isFeatured: true,
      createdAt: true,
    },
  });

  cache.set(cacheKey, result, 5 * 60 * 1000); // 5 min TTL
  return result;
}

export async function getTaxArticles(featuredOnly = false, limit = 50) {
  return await prisma.taxArticle.findMany({
    where: featuredOnly ? { isFeatured: true } : undefined,
    orderBy: { createdAt: 'desc' },
    take: limit,
    select: {
      id: true,
      title: true,
      summary: true,
      source: true,
      category: true,
      url: true,
      isFeatured: true,
      createdAt: true,
    },
  });
}

export async function getCategories(): Promise<string[]> {
  const cached = cache.get('categories');
  if (cached) return cached;

  const result = await prisma.taxArticle.groupBy({
    by: ['category'],
    where: { category: { not: null } },
  }).then(groups => groups.map(g => g.category).filter(Boolean) as string[]);

  cache.set('categories', result, 60 * 60 * 1000); // 1 hour TTL
  return result;
}

export async function getEconomicMetrics() {
  return {
    inflationRate: '33.69%',
    minimumWage: '₦70,000',
    currency: 'NGN (₦)',
    taxCalendar: [
      { event: 'PAYE Annual Returns filing deadline', date: 'March 31 Annually', status: 'Upcoming' },
      { event: 'Company Income Tax (CIT) filing deadline', date: 'June 30 Annually', status: 'Upcoming' },
      { event: 'Value Added Tax (VAT) monthly remittance', date: '21st of every month', status: 'Recurring' }
    ]
  };
}
