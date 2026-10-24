import express, { Request, Response } from "express"; // ✅ FIXED: Added Response here
import cors from "cors";
import helmet from "helmet";
import compression from "compression";
import rateLimit from "express-rate-limit";
import sanitizeHtml from "sanitize-html";
import { env } from "./config/env.js";
import { prisma } from "./config/database.js";
import { errorHandler } from "./middleware/errorHandler.js";
import { errorResponse } from "./utils/response.js";
import apiRouter from "./routes/index.js";
import { syncTaxNews } from "./services/news.service.js";

const app = express();

// Behind Render's load balancer — one hop, so req.ip comes from
// X-Forwarded-For and rate limiting keys correctly per client.
app.set("trust proxy", 1);

const limitResponse = (code: string, message: string) =>
  ({
    success: false,
    error: { code, message },
  }) as const;

// ─── Rate Limiting ───────────────────────────────────────────────────────────
const WINDOW_MS = 15 * 60 * 1000;
const makeLimiter = (max: number) =>
  rateLimit({
    windowMs: WINDOW_MS,
    max,
    standardHeaders: true,
    legacyHeaders: false,
    message: limitResponse(
      "RATE_LIMITED",
      "Too many requests. Please try again later.",
    ),
  });

const limiter = makeLimiter(500);
app.use(limiter);

// Tighter limits on the costliest endpoints: AI calls hit paid providers
// (Gemini/Groq) and statement parsing uploads + AI, so abuse can't rack up
// provider bills from a single client.
const aiLimiter = makeLimiter(30);
const parseLimiter = makeLimiter(10);
const calculateLimiter = makeLimiter(120);

// ─── Security & Parsing Middleware ───────────────────────────────────────────
app.use(compression());
app.use(helmet());
app.use(
  cors({
    origin: env.CORS_ORIGINS.includes("*") ? true : env.CORS_ORIGINS,
    credentials: true,
  }),
);
app.use(express.json({ limit: "100kb" }));

// ─── Input Sanitization Middleware ───────────────────────────────────────────
const sanitize = (obj: unknown): unknown => {
  if (typeof obj === "string")
    return sanitizeHtml(obj, { allowedTags: [], allowedAttributes: {} });
  if (Array.isArray(obj)) return obj.map(sanitize);
  if (obj instanceof Date) return obj;
  if (obj && typeof obj === "object") {
    return Object.fromEntries(
      Object.entries(obj as Record<string, unknown>).map(([k, v]) => [
        k,
        sanitize(v),
      ]),
    );
  }
  return obj;
};
app.use((req, _res, next) => {
  if (req.body && typeof req.body === "object") {
    req.body = sanitize(req.body);
  }
  next();
});

// ─── Base Health Route for UptimeRobot ───────────────────────────────────────
// Moved here so it executes before the 404 catcher intercepts it.
app.get("/", async (_req: Request, res: Response) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    // Same envelope as GET /api/v1/health below.
    res.status(200).json({
      success: true,
      status: "NaijaTax Enlighten API is running ✅",
      version: "1.0.0",
      timestamp: new Date().toISOString(),
    });
  } catch {
    errorResponse(res, "UNAVAILABLE", "Database unavailable.", 503);
  }
});

// ─── API Routes ──────────────────────────────────────────────────────────────
// API responses are per-user and change often; without this, mobile Safari
// may reuse a cached GET (e.g. profile, history) and show stale data.
app.use(env.API_PREFIX, (_req, res, next) => {
  res.set("Cache-Control", "no-store");
  next();
});
app.use(`${env.API_PREFIX}/ai/message`, aiLimiter);
app.use(`${env.API_PREFIX}/tax/parse-statement`, parseLimiter);
app.use(`${env.API_PREFIX}/tax/calculate`, calculateLimiter);
app.use(env.API_PREFIX, apiRouter);

// ─── 404 handler ─────────────────────────────────────────────────────────────
app.use((_req, res) => {
  errorResponse(
    res,
    "NOT_FOUND",
    "The requested endpoint does not exist.",
    404,
  );
});

// ─── Global Error Handler ────────────────────────────────────────────────────
app.use(errorHandler);

// ─── Real-time tax news auto-sync ───────────────────────────────────────────
// Initial sync shortly after boot, then every 30 minutes. syncTaxNews has an
// internal mutex so overlapping runs are skipped, and it never throws.
const NEWS_SYNC_INTERVAL_MS = 30 * 60 * 1000;

function scheduleNewsSync() {
  setTimeout(() => {
    syncTaxNews().catch((e) => console.warn("[NEWS] Startup sync failed:", e));
  }, 10_000);
  setInterval(() => {
    syncTaxNews().catch((e) => console.warn("[NEWS] Scheduled sync failed:", e));
  }, NEWS_SYNC_INTERVAL_MS);
}

// ─── Process-level safety nets ───────────────────────────────────────────────
process.on("unhandledRejection", (reason) => {
  console.error("Unhandled promise rejection:", reason);
});
process.on("uncaughtException", (err) => {
  console.error("Uncaught exception:", err);
  // The process state may be compromised — exit and let the platform restart.
  process.exit(1);
});

// ─── Server Bootstrap ────────────────────────────────────────────────────────
async function runApp() {
  try {
    await prisma.$connect();
    app.listen(env.PORT, () => {
      console.log(`Server is running on port ${env.PORT}`);
      scheduleNewsSync();
    });
  } catch (error) {
    console.error("Failed to connect to database:", error);
    await prisma.$disconnect();
    process.exit(1);
  }
}

runApp();
