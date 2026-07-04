import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import sanitizeHtml from 'sanitize-html';
import { env } from './config/env.js';
import { prisma } from './config/database.js';
import { errorHandler } from './middleware/errorHandler.js';
import apiRouter from './routes/index.js';

const app = express();

// ─── Rate Limiting ───────────────────────────────────────────────────────────
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, error: { code: 'RATE_LIMITED', message: 'Too many requests. Please try again later.' } },
});
app.use(limiter);

// ─── Security & Parsing Middleware ───────────────────────────────────────────
app.use(helmet());
app.use(cors({
  origin: env.CORS_ORIGINS.includes('*') ? true : env.CORS_ORIGINS,
  credentials: true,
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// ─── Input Sanitization Middleware ───────────────────────────────────────────
const sanitize = (obj: unknown): unknown => {
  if (typeof obj === 'string') return sanitizeHtml(obj, { allowedTags: [], allowedAttributes: {} });
  if (Array.isArray(obj)) return obj.map(sanitize);
  if (obj && typeof obj === 'object') {
    return Object.fromEntries(Object.entries(obj as Record<string, unknown>).map(([k, v]) => [k, sanitize(v)]));
  }
  return obj;
};
app.use((_req, res, next) => {
  const originalJson = res.json.bind(res);
  res.json = (body: unknown) => originalJson(sanitize(body));
  next();
});
app.use((req, _res, next) => {
  if (req.body && typeof req.body === 'object') {
    req.body = sanitize(req.body);
  }
  next();
});

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
    if (env.NODE_ENV === 'development') {
      console.log('✅ Connected to Supabase PostgreSQL database');
    }

    app.listen(env.PORT, () => {
      if (env.NODE_ENV === 'development') {
        console.log(`🚀 NaijaTax Enlighten API running on http://localhost:${env.PORT}`);
        console.log(`📡 API prefix: ${env.API_PREFIX}`);
      }
    });
  } catch (error) {
    console.error('❌ Failed to connect to the database:', error);
    await prisma.$disconnect();
    process.exit(1);
  }
}

runApp();
