import dotenv from 'dotenv';
import { z } from 'zod';

// Load .env file
dotenv.config();

const envSchema = z.object({
  PORT: z.string().transform(Number).default('3000'),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  DATABASE_URL: z.string().startsWith('postgresql://').or(z.string().startsWith('postgres://')),
  SUPABASE_JWT_SECRET: z.string().min(10, 'Supabase JWT secret must be defined'),
  OPENAI_API_KEY: z.string().min(10, 'OpenAI API key must be defined'),
  API_PREFIX: z.string().default('/api/v1'),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  console.error('❌ Invalid environment configuration:');
  console.error(JSON.stringify(parsed.error.format(), null, 2));
  process.exit(1);
}

export const env = parsed.data;
