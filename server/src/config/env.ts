import dotenv from 'dotenv';
import { z } from 'zod';

// Load .env file
dotenv.config();

const envSchema = z.object({
  PORT: z.string().transform(Number).default('3000'),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  DATABASE_URL: z.string().startsWith('postgresql://').or(z.string().startsWith('postgres://'))
    .describe('PostgreSQL connection string for Supabase (postgresql://...)'),
  DIRECT_URL: z.string().optional()
    .describe('Direct PostgreSQL connection string for Prisma migrations (bypasses connection pooler)'),
  SUPABASE_JWT_SECRET: z.string().min(10, 'SUPABASE_JWT_SECRET is required. Find it in your Supabase dashboard under Settings > API > JWT Secret.')
    .describe('Supabase JWT secret for verifying authentication tokens'),
  OPENAI_API_KEY: z.string().min(10, 'OPENAI_API_KEY is required. Get one from https://platform.openai.com/api-keys')
    .describe('OpenAI API key for AI chatbot and bank statement parsing'),
  API_PREFIX: z.string().default('/api/v1'),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  console.error('');
  console.error('╔══════════════════════════════════════════════════════════╗');
  console.error('║         NaijaTax Enlighten - Server Configuration       ║');
  console.error('╠══════════════════════════════════════════════════════════╣');
  console.error('║  One or more required environment variables are missing ║');
  console.error('║  or invalid. Please check your .env file.               ║');
  console.error('╚══════════════════════════════════════════════════════════╝');
  console.error('');
  const formatted = parsed.error.format();
  for (const [key, value] of Object.entries(formatted)) {
    if (key === '_errors') continue;
    if (typeof value === 'object' && value !== null && '_errors' in value) {
      console.error(`  ❌ ${key}: ${(value as { _errors: string[] })._errors.join(', ')}`);
    }
  }
  console.error('');
  console.error('  Required variables:');
  console.error('    DATABASE_URL       - postgresql://user:pass@host:port/db');
  console.error('    SUPABASE_JWT_SECRET - From Supabase Dashboard > Settings > API');
  console.error('    OPENAI_API_KEY     - From https://platform.openai.com/api-keys');
  console.error('');
  process.exit(1);
}

export const env = parsed.data;
