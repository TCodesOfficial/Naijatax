import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { env } from './env.js';

declare global {
  var prisma: PrismaClient | undefined;
}

// pg v9 forces sslmode=require to verify-full, rejecting Supabase's
// self-signed pooler certificate. Disable TLS cert verification so
// the connection succeeds. The connection is still encrypted via TLS.
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

const createPrismaClient = () => {
  const adapter = new PrismaPg({
    connectionString: env.DATABASE_URL,
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
