import Parser from 'rss-parser';
import { prisma } from '../config/database.js';

const parser = new Parser();

// Public RSS Feeds related to Nigerian business/finance news (Nairametrics is a top tax/finance source)
const FINANCIAL_RSS_FEED = 'https://nairametrics.com/category/taxation/feed/';

export async function syncTaxNews() {
  console.log('🔄 Syncing tax news from RSS feed...');
  try {
    const feed = await parser.parseURL(FINANCIAL_RSS_FEED);
    let count = 0;

    for (const item of feed.items) {
      if (!item.title || !item.contentSnippet) continue;

      // Check if article already exists
      const existing = await prisma.taxArticle.findFirst({
        where: { title: item.title }
      });

      if (!existing) {
        await prisma.taxArticle.create({
          data: {
            title: item.title,
            summary: item.contentSnippet.substring(0, 200) + '...',
            content: item.content || item.contentSnippet,
            source: feed.title || 'Nairametrics',
            url: item.link,
            isFeatured: false
          }
        });
        count++;
      }
    }
    console.log(`✅ RSS sync complete. Ingested ${count} new articles.`);
    return { success: true, newArticlesCount: count };
  } catch (error) {
    console.warn('⚠️ Unable to sync news from RSS feed, falling back to database cache.', error);
    return { success: false, error: 'RSS feed unavailable' };
  }
}

export async function getTaxArticles(featuredOnly = false) {
  return await prisma.taxArticle.findMany({
    where: featuredOnly ? { isFeatured: true } : undefined,
    orderBy: { createdAt: 'desc' },
    take: 15
  });
}

export async function getEconomicMetrics() {
  // Free public API mock & fallback configuration for Nigeria inflation & key economic metrics
  return {
    inflationRate: '33.69%', // Current inflation index fallback
    minimumWage: '₦70,000',  // 2024/2025 mandated minimum wage
    currency: 'NGN (₦)',
    taxCalendar: [
      { event: 'PAYE Annual Returns filing deadline', date: 'March 31 Annually', status: 'Upcoming' },
      { event: 'Company Income Tax (CIT) filing deadline', date: 'June 30 Annually', status: 'Upcoming' },
      { event: 'Value Added Tax (VAT) monthly remittance', date: '21st of every month', status: 'Recurring' }
    ]
  };
}
