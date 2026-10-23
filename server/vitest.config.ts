import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'node',
    include: ['src/**/*.test.ts'],
    // Satisfies env.ts validation when no .env file is present (CI).
    // dotenv never overrides existing process.env values, so a real .env
    // still wins locally.
    env: {
      NODE_ENV: 'test',
      DATABASE_URL: 'postgresql://user:pass@localhost:5432/naijatax_test',
      DIRECT_URL: 'postgresql://user:pass@localhost:5432/naijatax_test',
      SUPABASE_URL: 'https://test-project.supabase.co',
      GEMINI_API_KEY: 'test-gemini-key-123456',
    },
  },
});
