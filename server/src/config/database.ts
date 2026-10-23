import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { env } from './env.js';

declare global {
  var prisma: PrismaClient | undefined;
}

// Supabase's pooler certificate chain has a self-signed root, so full
// verification fails. Instead of globally disabling TLS verification
// (which would also exempt Gemini/JWKS/RSS connections), scope it to
// the database connection only: strip sslmode (pg treats require as
// verify-full and would override the option below) and opt out of
// certificate verification per-connection. The connection is still
// encrypted end-to-end via TLS.
const createPrismaClient = () => {
  const url = new URL(env.DATABASE_URL);
  url.searchParams.delete('sslmode');
  const adapter = new PrismaPg({
    connectionString: url.toString(),
    ssl: { rejectUnauthorized: false },
  });
  return new PrismaClient({
    adapter,
    log: ['error'],
  });
};

export const prisma = global.prisma ?? createPrismaClient();

if (env.NODE_ENV !== 'production') {
  global.prisma = prisma;
}
