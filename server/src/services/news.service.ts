import Parser from 'rss-parser';
import { prisma } from '../config/database.js';
import { env } from '../config/env.js';

// Custom field: <source>Publisher</source> (Google News RSS uses it for attribution)
const parser = new Parser({ customFields: { item: ['source'] } });

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

// ─── Feed sources ────────────────────────────────────────────────────────────
// Direct category feeds (stable, publisher-provided) + Google News search
// RSS (free, no API key, typically only minutes behind real-time).
const GOOGLE_NEWS_RSS = 'https://news.google.com/rss/search';

function googleNewsFeed(query: string, source: string) {
  const q = encodeURIComponent(`${query} when:7d`);
  return {
    url: `${GOOGLE_NEWS_RSS}?q=${q}&hl=en-NG&gl=NG&ceid=NG:en`,
    source,
    isGoogleNews: true,
  };
}

const RSS_FEEDS: Array<{ url: string; source: string; isGoogleNews?: boolean }> = [
  { url: 'https://nairametrics.com/category/taxation/feed/', source: 'Nairametrics' },
  { url: 'https://businessday.ng/category/tax/feed/', source: 'BusinessDay' },
  { url: 'https://www.punchng.com/topics/tax/feed/', source: 'Punch' },
  { url: 'https://www.vanguardngr.com/business/tax/feed/', source: 'Vanguard' },
  { url: 'https://www.thecable.ng/category/business/tax/feed/', source: 'TheCable' },
  { url: 'https://www.firs.gov.ng/feed/', source: 'FIRS Official' },
  googleNewsFeed('"Nigeria Tax Act" OR "Nigeria tax reform" OR "Finance Act Nigeria"', 'Google News · Tax Act'),
  googleNewsFeed('NRS OR "Nigeria Revenue Service" OR FIRS tax Nigeria', 'Google News · NRS/FIRS'),
  googleNewsFeed('"Taiwo Oyedele" tax', 'Google News · Policy Committee'),
  googleNewsFeed('PAYE OR VAT OR withholding tax Nigeria', 'Google News · PAYE/VAT'),
];

// Optional extra feeds from env (comma-separated) — finally honored config.
function extraFeeds(): Array<{ url: string; source: string; isGoogleNews?: boolean }> {
  return (env.NEWS_RSS_FEED ?? '')
    .split(',')
    .map((u) => u.trim())
    .filter(Boolean)
    .map((url) => ({ url, source: 'NaijaTax Wire' }));
}

// ─── Sync mutex (overlapping runs are skipped) ──────────────────────────────
let syncInFlight = false;
const MAX_ARTICLES = 300;

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

// Google News titles read "Headline - Publisher"; strip the publisher suffix
// so dedupe and display stay clean (publisher lives in the source column).
function stripGoogleSuffix(title: string): string {
  const stripped = title.replace(/\s+[-–—]\s+[^-–—]{2,60}$/, '');
  return stripped.length >= 10 ? stripped : title;
}

function sourceOf(item: any, fallback: string): string {
  const s = item?.source;
  if (typeof s === 'string' && s.trim()) return s.trim().substring(0, 60);
  if (s && typeof s === 'object' && typeof s._ === 'string' && s._.trim()) {
    return s._.trim().substring(0, 60);
  }
  return fallback;
}

type NormalizedArticle = {
  title: string;
  summary: string;
  content: string;
  source: string;
  category: string;
  url: string;
  isFeatured: boolean;
  publishedAt: Date | null;
};

function normalizeArticle(item: any, feedSource: string, isGoogleNews: boolean): NormalizedArticle | null {
  if (!item.title) return null;
  const rawTitle = isGoogleNews ? stripGoogleSuffix(item.title) : item.title;
  const content = item.content || item.contentSnippet || '';
  const summary = item.contentSnippet
    ? item.contentSnippet.substring(0, 200) + (item.contentSnippet.length > 200 ? '...' : '')
    : 'No summary available';
  const url = item.link || '';
  const source = isGoogleNews ? sourceOf(item, feedSource) : feedSource;

  const publishedRaw = item.isoDate || item.pubDate;
  let publishedAt: Date | null = null;
  if (publishedRaw) {
    const parsed = new Date(publishedRaw);
    if (!Number.isNaN(parsed.getTime())) publishedAt = parsed;
  }

  return {
    title: rawTitle.substring(0, 255),
    summary: summary.substring(0, 500),
    content: content || summary,
    source,
    category: categorizeArticle(rawTitle, content, source),
    url,
    isFeatured: false,
    publishedAt,
  };
}

// Parse a feed; some hosts (e.g. Google News) reject rss-parser's default UA,
// so fall back to a browser-UA fetch + parseString.
async function parseFeed(url: string): Promise<any> {
  try {
    return await parser.parseURL(url);
  } catch {
    const res = await fetch(url, {
      headers: {
        'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36',
        Accept: 'application/rss+xml, application/xml, text/xml, */*',
      },
      signal: AbortSignal.timeout(15_000),
    });
    if (!res.ok) throw new Error(`Feed HTTP ${res.status}`);
    const xml = await res.text();
    return parser.parseString(xml);
  }
}

export async function syncTaxNews() {
  if (syncInFlight) {
    return { success: false, skipped: true, newArticlesCount: 0 };
  }
  syncInFlight = true;
  const startedAt = Date.now();

  try {
    // One snapshot of existing articles → fast in-memory dedupe for the run.
    const existing = await prisma.taxArticle.findMany({
      select: { title: true, url: true },
    });
    const haveUrls = new Set(existing.map((e) => (e.url || '').toLowerCase()).filter(Boolean));
    const haveTitles = new Set(existing.map((e) => e.title.toLowerCase().trim()));

    let totalCount = 0;
    const feeds = [...RSS_FEEDS, ...extraFeeds()];

    for (const feed of feeds) {
      try {
        const feedData = await parseFeed(feed.url);
        let count = 0;
        for (const item of feedData.items ?? []) {
          const normalized = normalizeArticle(item, feed.source, feed.isGoogleNews ?? false);
          if (!normalized) continue;

          const urlKey = normalized.url.toLowerCase();
          const titleKey = normalized.title.toLowerCase().trim();
          if ((urlKey && haveUrls.has(urlKey)) || haveTitles.has(titleKey)) continue;

          await prisma.taxArticle.create({ data: normalized });
          if (urlKey) haveUrls.add(urlKey);
          haveTitles.add(titleKey);
          count++;
        }
        totalCount += count;
        if (count > 0) console.log(`[NEWS] ${feed.source}: +${count}`);
      } catch (error: any) {
        console.warn(`[NEWS] Feed failed (${feed.source}): ${error?.message ?? error}`);
      }
    }

    // Keep the table lean: retain only the newest MAX_ARTICLES.
    const total = await prisma.taxArticle.count();
    if (total > MAX_ARTICLES) {
      const overflow = await prisma.taxArticle.findMany({
        orderBy: [{ publishedAt: { sort: 'desc', nulls: 'last' } }, { createdAt: 'desc' }],
        skip: MAX_ARTICLES,
        select: { id: true },
      });
      if (overflow.length > 0) {
        await prisma.taxArticle.deleteMany({
          where: { id: { in: overflow.map((a) => a.id) } },
        });
      }
    }

    // Invalidate article cache after sync
    cache.clear();
    console.log(`[NEWS] Sync complete: +${totalCount} new in ${Date.now() - startedAt}ms`);
    return { success: true, newArticlesCount: totalCount };
  } finally {
    syncInFlight = false;
  }
}

const ARTICLE_ORDER = [
  { publishedAt: { sort: 'desc', nulls: 'last' } as const },
  { createdAt: 'desc' as const },
];

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
    orderBy: ARTICLE_ORDER,
    take: limit,
    select: {
      id: true,
      title: true,
      summary: true,
      content: true,
      source: true,
      category: true,
      url: true,
      isFeatured: true,
      publishedAt: true,
      createdAt: true,
    },
  });

  cache.set(cacheKey, result, 5 * 60 * 1000); // 5 min TTL
  return result;
}

export async function getTaxArticles(featuredOnly = false, limit = 50) {
  return await prisma.taxArticle.findMany({
    where: featuredOnly ? { isFeatured: true } : undefined,
    orderBy: ARTICLE_ORDER,
    take: limit,
    select: {
      id: true,
      title: true,
      summary: true,
      source: true,
      category: true,
      url: true,
      isFeatured: true,
      publishedAt: true,
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
