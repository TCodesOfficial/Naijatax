import { PrismaClient } from '../generated/prisma/client.js';
// import { env } from './env.js';

// declare global {
//   var prisma: PrismaClient | undefined;
// }

// export const prisma = global.prisma ?? new PrismaClient({
//   log: env.NODE_ENV === 'development' ? ['query', 'info', 'warn', 'error'] : ['error'],
// });

// if (env.NODE_ENV !== 'production') {
//   global.prisma = prisma;
// }


import { PrismaPg } from '@prisma/adapter-pg'; // 1. Import your database adapter
//import { PrismaClient } from './generated/prisma/client.js'; // 2. Update to your schema's custom output path
import { env } from './env.js';

declare global {
  var prisma: PrismaClient | undefined;
}

// Helper function to initialize the Prisma Client with its runtime adapter
const createPrismaClient = () => {
  // Initialize the driver adapter using your environment connection string
  const adapter = new PrismaPg({
    connectionString: env.DATABASE_URL, 
  });

  return new PrismaClient({
    adapter, // 3. Pass the adapter here
    log: env.NODE_ENV === 'development' ? ['query', 'info', 'warn', 'error'] : ['error'],
  });
};

export const prisma = global.prisma ?? createPrismaClient();

if (env.NODE_ENV !== 'production') {
  global.prisma = prisma;
}
