import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { env } from './config/env.js';
import { prisma } from './config/database.js';
import { errorHandler } from './middleware/errorHandler.js';
import apiRouter from './routes/index.js';

const app = express();

// ─── Security & Parsing Middleware ───────────────────────────────────────────
app.use(helmet());
app.use(cors({
  origin: env.NODE_ENV === 'production'
    ? ['https://naijatax.app']
    : ['http://localhost:3000', 'http://localhost:5000', 'http://localhost:5173', 'http://localhost:8080'],
  credentials: true,
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// ─── API Routes ──────────────────────────────────────────────────────────────
app.use(env.API_PREFIX, apiRouter);

// ─── 404 handler ─────────────────────────────────────────────────────────────
app.use((_req, res) => {
  res.status(404).json({
    success: false,
    error: { code: 'NOT_FOUND', message: 'The requested endpoint does not exist.' },
  });
});


// ─── Global Error Handler ────────────────────────────────────────────────────
app.use(errorHandler);


// ─── Server Bootstrap ────────────────────────────────────────────────────────
async function runApp() {
  try {
    // Verify DB connection on startup
    await prisma.$connect();
    console.log('✅ Connected to Supabase PostgreSQL database');

    app.listen(env.PORT, () => {
      console.log(`🚀 NaijaTax Enlighten API running on http://localhost:${env.PORT}`);
      console.log(`📡 API prefix: ${env.API_PREFIX}`);
      console.log(`🌍 Environment: ${env.NODE_ENV}`);
    });
  } catch (error) {
    console.error('❌ Failed to connect to the database:', error);
    await prisma.$disconnect();
    process.exit(1);
  }
}

runApp();
