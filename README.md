<div align="center">

# NaijaTax Enlighten

**Your cross-platform Nigerian tax companion**

Tax calculation, an AI assistant, and everything NTA 2025 — in one app,
running on Android, iOS, web, and desktop.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%E2%89%A5%203.9-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.6-3178C6?logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Express](https://img.shields.io/badge/Express-4.x-000000?logo=express&logoColor=white)](https://expressjs.com)
[![Prisma](https://img.shields.io/badge/Prisma-7.x-2D3748?logo=prisma&logoColor=white)](https://www.prisma.io)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-3FCF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[Features](#features) · [Architecture](#architecture) · [Getting Started](#getting-started) · [API Reference](#api-reference) · [Documentation](#documentation)

</div>

---

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Environment Variables](#environment-variables)
  - [Run the Project](#run-the-project)
- [Project Structure](#project-structure)
- [API Reference](#api-reference)
- [AI Provider Fallback Design](#ai-provider-fallback-design)
- [Security](#security)
- [Data Model](#data-model)
- [Scripts](#scripts)
- [Code Quality](#code-quality)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)
- [Roadmap](#roadmap)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

<a id="features"></a>

## ✨ Features

**Tax Engine**

- **PAYE & income tax calculator** — monthly and annual assessments with rent relief,
  pension, and the progressive bands introduced by the Nigeria Tax Act (NTA) 2025.
  Works for guests; results are saved to your profile when you sign in.
- **Bank statement import** — upload a PDF bank statement and let the server extract
  income data automatically (server-side parsing with `pdf-parse` + Gemini vision).
- **VAT reference** — a seeded catalogue of ~100 goods and services classified as
  standard-rated, zero-rated, or exempt, with instant search.
- **PDF reports** — generate and share polished assessment and analytics reports.

**AI Assistant**

- **Persistent AI chat** — multi-session chat with markdown answers, streaming-friendly
  message flow, and full history persisted per user.
- **Resilient by design** — requests fail over across multiple AI providers so a single
  provider outage never takes the assistant down (see [AI Provider Fallback Design](#ai-provider-fallback-design)).

**Learning & Community**

- **Learn / NTA 2025** — structured sections covering the 2025 reforms, from PAYE bands
  to CIT thresholds, each with highlights and deep links.
- **Tax quizzes** — question sets with explanations, scoring, and a personal performance
  history.
- **Community forum** — tagged topics, threaded replies, voting, and accepted answers.
- **News feed** — Nigerian tax news synced from RSS (Nairametrics by default), plus a
  World Bank inflation chart proxied through the API to avoid CORS issues.

**Account & Security**

- **Supabase Auth** — email/password and Google Sign-In, verified server-side with
  stateless JWTs.
- **Biometric lock** — optional fingerprint/face unlock via `local_auth`.
- **Profile & avatars** — avatar uploads to Supabase Storage, onboarding status sync.
- **Documents vault** — keep tax records organized in one place.
- **Guest mode** — explore the calculator, VAT list, forum, and news without an account.

<a id="screenshots"></a>

## 📱 Screenshots

<!--
  Drop your exported screenshots into docs/screenshots/ and uncomment the block
  below. Suggested captures: dashboard, calculator, AI chat, forum, quiz, learn.

<p align="center">
  <img src="docs/screenshots/dashboard.png" alt="Dashboard" width="240" />
  <img src="docs/screenshots/calculator.png" alt="Tax calculator" width="240" />
  <img src="docs/screenshots/ai-chat.png" alt="AI assistant" width="240" />
</p>
-->

<a id="architecture"></a>

## 🏗️ Architecture

NaijaTax Enlighten is a monorepo containing a Flutter client and an Express API.
The client talks only to the API; the API owns the database, authentication
verification, and all AI/external integrations.

```
┌──────────────────────────────┐
│  Flutter client (client/)    │
│  Android · iOS · Web · Desktop│
│  Riverpod · GoRouter · Hive  │
└──────────────┬───────────────┘
               │  HTTPS · Bearer JWT · JSON
               ▼
┌──────────────────────────────┐       ┌─────────────────────────────┐
│  Express API (server/)       │──────▶│  Google Gemini (primary)    │
│  TypeScript · Zod · Helmet   │ fail- │  Groq (fallback)            │
│  JWT via Supabase JWKS       │ over  └─────────────────────────────┘
└──────┬───────────┬───────────┘
       │           │
       ▼           ▼
┌────────────┐  ┌──────────────────────────────┐
│  Prisma    │  │  Supabase                    │
│  ORM       │  │  · Auth (email + Google)     │
└─────┬──────┘  │  · Storage (avatars)         │
      ▼         └──────────────────────────────┘
┌────────────────────────────┐
│  PostgreSQL (Supabase)     │
└────────────────────────────┘
```

Key decisions:

- **One API, many clients** — all tax logic, AI prompts, and content live on the server,
  so mobile, web, and desktop stay perfectly in sync.
- **Stateless auth** — the API verifies Supabase-issued JWTs against the project's JWKS
  endpoint; no sessions are stored server-side.
- **Fail-safe AI** — every chat request runs through a provider chain under a shared
  deadline, with friendly fallback messages if all providers are busy.

<a id="tech-stack"></a>

## 🛠️ Tech Stack

| Layer | Technology | Purpose |
| :--- | :--- | :--- |
| **Client** | [Flutter](https://flutter.dev) (Dart ≥ 3.9) | Single codebase for Android, iOS, web, desktop |
| **State** | Riverpod | Predictable, testable state management |
| **Routing** | GoRouter | Declarative routing with deep links & nested shells |
| **Networking** | Dio | HTTP client with interceptors and timeouts |
| **Local storage** | Hive CE, Shared Preferences | Offline cache, theme & settings |
| **Charts / PDF** | fl_chart, pdf, printing | Visualisations and report generation |
| **Backend** | Node.js, [Express 4](https://expressjs.com), TypeScript 5.6 (ESM) | REST API |
| **Validation** | Zod | Environment and payload validation |
| **ORM** | [Prisma 7](https://www.prisma.io) (`@prisma/adapter-pg`) | Type-safe PostgreSQL access |
| **Database** | PostgreSQL (Supabase) | Managed Postgres with connection pooler |
| **Auth** | Supabase Auth + `jose` (ES256 JWKS) | JWT verification without server sessions |
| **AI** | Google Gemini, [Groq](https://groq.com) | Chat assistant and statement parsing |
| **News** | rss-parser, World Bank API | Tax news ingestion and inflation data |
| **Hardening** | helmet, CORS, express-rate-limit, sanitize-html | Security middleware baseline |

<a id="getting-started"></a>

## 🚀 Getting Started

<a id="prerequisites"></a>

### Prerequisites

| Tool | Version | Notes |
| :--- | :--- | :--- |
| Flutter + Dart | Dart SDK `>= 3.9 < 4.0` | [Install Flutter](https://docs.flutter.dev/get-started/install) |
| Node.js | 20 LTS or newer | Comes with npm |
| PostgreSQL | 14+ | Free tier on [Supabase](https://supabase.com) works fine |
| Google AI Studio key | — | [Get a Gemini API key](https://aistudio.google.com/apikey) |
| Groq key *(optional)* | — | [Get a Groq API key](https://console.groq.com/keys) for AI failover |

<a id="environment-variables"></a>

### Environment Variables

**1. Server — `server/.env`** (copy from `server/.env.example`)

| Variable | Required | Description |
| :--- | :---: | :--- |
| `PORT` | no | API port (default `3000`) |
| `NODE_ENV` | no | `development` \| `production` \| `test` |
| `DATABASE_URL` | ✅ | PostgreSQL connection string (`postgresql://…`) |
| `DIRECT_URL` | recommended | Pooler-bypass connection string for Prisma migrations |
| `SUPABASE_URL` | ✅ | Supabase project URL, e.g. `https://xxx.supabase.co` |
| `GEMINI_API_KEY` | ✅ | Google Gemini API key (primary AI provider) |
| `GROQ_API_KEY` | no | Groq API key — enables the AI fallback provider |
| `API_PREFIX` | no | Route prefix (default `/api/v1`) |
| `CORS_ORIGINS` | no | Comma-separated origins, or `*` |
| `NEWS_RSS_FEED` | no | Override the default tax-news RSS feed |

> The server validates its environment with Zod on boot and exits with a readable
> banner if anything required is missing.

**2. Client — dart-define files**

The Flutter app receives its config at build/run time via `--dart-define-from-file`.
Create **`client/.env`** (properties format) and/or **`client/config.dev.json`**
(JSON format — required by `npm run dev`) with the same five keys:

| Key | Description |
| :--- | :--- |
| `SUPABASE_URL` | Supabase project URL (same as the server's) |
| `SUPABASE_ANON_KEY` | Supabase anon/public API key |
| `API_BASE_URL` | API base URL, e.g. `http://localhost:3000/api/v1` |
| `GOOGLE_WEB_CLIENT_ID` | OAuth client ID for web sign-in |
| `GOOGLE_IOS_CLIENT_ID` | OAuth client ID for iOS sign-in |

```properties
# client/.env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
API_BASE_URL=http://localhost:3000/api/v1
GOOGLE_WEB_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=your-ios-client-id.apps.googleusercontent.com
```

Both files are gitignored — **never commit real credentials**.

<a id="run-the-project"></a>

### Run the Project

```bash
# 1. Clone
git clone https://github.com/TobiasA1/Naijatax.git
cd Naijatax

# 2. Install root tooling (concurrently)
npm install

# 3. Install, migrate, and seed the API
cd server
npm install
npm run prisma:generate
npm run prisma:migrate     # creates schema (needs DATABASE_URL)
npm run db:seed            # VAT items, quiz questions, articles
cd ..
```

**Start the API**

```bash
npm run dev:server          # → http://localhost:3000
```

**Start the app** (second terminal)

```bash
cd client
flutter pub get
flutter run --dart-define-from-file=.env
# or target Chrome directly:
flutter run -d chrome --dart-define-from-file=.env
```

**Or run both together** from the repository root (uses `client/config.dev.json`):

```bash
npm run dev
```

Verify the API is healthy:

```bash
curl http://localhost:3000/api/v1/health
# {"success":true,"status":"NaijaTax Enlighten API is running ✅", ...}
```

<a id="project-structure"></a>

## 📚 Project Structure

```
Naijatax/
├── client/                        # Flutter application
│   ├── lib/
│   │   ├── main.dart              # Bootstrap: Hive + Supabase init, ProviderScope
│   │   ├── core/
│   │   │   ├── constants/         # App-wide constants & dart-define reads
│   │   │   ├── router/            # GoRouter config (StatefulShellRoute + branches)
│   │   │   ├── theme/             # Material theme, colors, typography
│   │   │   └── utils/             # Formatters and helpers
│   │   ├── models/                # Plain Dart models (tax, forum, quiz, news…)
│   │   ├── providers/             # Riverpod providers (auth, tax, forum, quiz…)
│   │   ├── screens/               # Feature screens (dashboard, ai_chat, forum…)
│   │   ├── services/              # API client, storage, PDF, biometrics
│   │   └── widgets/               # Reusable widgets (nav shell, cards, avatars)
│   └── .env                       # Local dart-define config (gitignored)
│
├── server/                        # Express REST API
│   ├── src/
│   │   ├── server.ts              # App entry: middleware, security, listen
│   │   ├── config/                # env (Zod), Prisma client, AI prompts
│   │   ├── auth/                  # Supabase JWT verification (jose, ES256)
│   │   ├── middleware/            # Error handler, async wrapper
│   │   ├── routes/                # /tax /ai /forum /quiz /news /users
│   │   ├── controllers/           # Request handlers
│   │   ├── services/              # Business logic (tax, ai, forum, quiz, news)
│   │   └── utils/                 # Response helpers
│   ├── prisma/
│   │   ├── schema.prisma          # Data model (10 models)
│   │   ├── migrations/            # SQL migrations
│   │   └── seed.ts                # VAT items, quiz questions, articles
│   └── .env                       # Local secrets (gitignored)
│
├── Project Diagrams/              # ERD, UML & sequence diagrams (draw.io)
├── package.json                   # Workspace scripts (dev, build, db…)
└── README.md
```

<a id="api-reference"></a>

## 🔌 API Reference

- **Base URL:** `http://localhost:3000/api/v1`
- **Auth:** `Authorization: Bearer <supabase-jwt>` on protected routes
- **Guest access:** routes marked *Guest* accept requests without a token (and attach the
  user when one is provided)

**Response envelope**

```json
{ "success": true, "data": { } }
```

```json
{ "success": false, "error": { "code": "UNAUTHORIZED", "message": "Access token required. Please log in or sign up." } }
```

### Health

| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/health` | — | API health, version, timestamp |
| `GET` | `/` | — | Root uptime probe (runs `SELECT 1` against the DB) |

### Tax

| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `POST` | `/tax/calculate` | Guest | Run a tax assessment (saved when authenticated) |
| `GET` | `/tax/vat` | Guest | Search VAT items |
| `POST` | `/tax/parse-statement` | ✅ | Upload & parse a bank-statement PDF (multipart `statement`, ≤ 10 MB) |
| `GET` | `/tax/profiles/latest` | ✅ | Latest saved assessment |
| `GET` | `/tax/profiles/history` | ✅ | Assessment history |

### AI Assistant

| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `POST` | `/ai/message` | ✅ | Send a chat message (creates/continues a session) |
| `GET` | `/ai/sessions` | ✅ | List chat sessions |
| `GET` | `/ai/sessions/:id` | ✅ | Fetch session messages |
| `DELETE` | `/ai/sessions/:id` | ✅ | Delete a session |

### Forum

| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/forum` | Guest | List topics |
| `GET` | `/forum/:id` | Guest | Topic detail with replies |
| `POST` | `/forum` | ✅ | Create a topic |
| `POST` | `/forum/:id/replies` | ✅ | Reply to a topic |
| `PATCH` | `/forum/replies/:id/accept` | ✅ | Mark a reply as accepted |

### Quiz

| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/quiz/questions` | Guest | Fetch a question set |
| `POST` | `/quiz/scores` | ✅ | Submit a score |
| `GET` | `/quiz/scores/history` | ✅ | Personal score history |

### News & Metrics

| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `GET` | `/news/public` | — | Public article feed |
| `GET` | `/news/public/categories` | — | Available categories |
| `GET` | `/news` | — | Full article list |
| `GET` | `/news/metrics` | — | Feed metrics |
| `GET` | `/news/inflation` | — | World Bank Nigeria inflation proxy |
| `POST` | `/news/sync` | 🛡️ Admin | Trigger RSS sync |

### Users

| Method | Endpoint | Auth | Description |
| :--- | :--- | :---: | :--- |
| `PATCH` | `/users/avatar` | ✅ | Update avatar URL |
| `PATCH` | `/users/onboarded` | ✅ | Mark onboarding complete |
| `GET` | `/users/onboarded` | ✅ | Onboarding status |

<a id="ai-provider-fallback-design"></a>

## 🤖 AI Provider Fallback Design

AI providers fail. Rather than surfacing 5xx errors to users, every `/ai/message`
request walks a **provider chain** inside a shared deadline:

```
client (20s timeout)
   │
   ▼
server request (18s shared budget)
   │
   ├─ 1. Google Gemini  ── gemini-3.8-flash      (primary)
   ├─ 2. Groq           ── openai/gpt-oss-120b   (used only if GROQ_API_KEY is set)
   └─ 3. Google Gemini  ── gemini-3.6-flash      (last resort)
   │
   ▼
success → { success: true, data }
all failed → friendly, retryable error (raw errors logged server-side only)
```

Behaviour details:

- Cross-provider retries fire immediately; same-provider retries back off (1s on 503,
  4s on 429).
- Groq non-transient errors skip forward in the chain instead of failing the request.
- Non-retryable Gemini errors (e.g. invalid key) short-circuit with a clear log line.
- The client recognises server "busy" messages and surfaces a **Retry** action.
- Latency, provider, and failures are logged per attempt (`✅ AI OK via <provider> in Xms`).

<a id="security"></a>

## 🔒 Security

| Concern | Mitigation |
| :--- | :--- |
| Transport headers | `helmet` |
| Cross-origin traffic | `cors` with an explicit origin allowlist |
| Abuse | `express-rate-limit` — 500 requests / 15 min window |
| Payload size | JSON bodies capped at **100 KB**; uploads at **10 MB** |
| Stored-XSS | `sanitize-html` strips all tags from inbound string payloads |
| Authentication | Supabase JWTs verified with `jose` against the project JWKS (ES256) |
| Secrets | Zod-validated `.env`; example file committed in place of real values |
| SQL injection | Prisma parameterized queries |
| Admin actions | `requireAdmin` guard (e.g. news sync) |

<a id="data-model"></a>

## 🗄️ Data Model

Schema lives in [`server/prisma/schema.prisma`](server/prisma/schema.prisma) and is
migrated with Prisma Migrate.

| Model | Purpose |
| :--- | :--- |
| `User` | Mirrors Supabase Auth IDs (UUID), profile, role, onboarding |
| `TaxProfile` | Saved assessments (income, reliefs, computed tax) |
| `VatItem` | VAT catalogue — standard / zero-rated / exempt rates |
| `QuizQuestion` | Quiz items with options and explanations |
| `QuizScore` | Per-user quiz results |
| `ChatSession` / `ChatMessage` | AI chat history (session → messages) |
| `ForumTopic` / `ForumReply` | Community discussions with votes & accepted answers |
| `TaxArticle` | Educational/news content with source attribution |

Entity-relationship and UML diagrams are available in [`Project Diagrams/`](Project%20Diagrams).

<a id="scripts"></a>

## 📦 Scripts

**Repository root**

| Command | Description |
| :--- | :--- |
| `npm run dev` | API + app concurrently |
| `npm run dev:server` | API only (tsx watch) |
| `npm run dev:client` | Flutter (mobile/desktop) with `config.dev.json` |
| `npm run dev:web` | Flutter on Chrome with `.env` |
| `npm run build:server` | Compile TypeScript → `server/dist` |
| `npm run build:client` | Build release APK |
| `npm run build:web` | Build release web bundle |
| `npm run analyze` | `dart analyze` on the client |
| `npm run lint:server` | `tsc --noEmit` on the API |
| `npm run db:migrate` | Prisma migrate dev |
| `npm run db:seed` | Seed VAT items, quiz questions, articles |

**Server (`server/`)**

| Command | Description |
| :--- | :--- |
| `npm run dev` | Dev server with hot reload (`tsx watch`) |
| `npm run build` | Type-check & emit to `dist/` |
| `npm start` | Run the compiled server |
| `npm run prisma:generate` | Regenerate the Prisma client |
| `npm run prisma:migrate` | Create/apply migrations |
| `npm run db:seed` | Seed the database |

<a id="code-quality"></a>

## 🧪 Code Quality

```bash
npm run analyze        # Flutter/Dart static analysis
npm run lint:server    # TypeScript type-check (no emit)
```

- Lints: `flutter_lints` on the client, strict TypeScript on the server.
- Vitest is available in the server toolchain for test suites.

<a id="deployment"></a>

## 🌐 Deployment

**API** (e.g. Render)

```bash
# build
cd server && npm ci && npm run prisma:generate && npm run build
# start
cd server && npm start
```

Set every variable from [Environment Variables](#environment-variables) in the service
dashboard (`GROQ_API_KEY` optional but recommended for AI failover). Point
`API_BASE_URL` at the deployed API when building the client.

**Client**

```bash
npm run build:client   # Android APK  (--dart-define-from-file=.env)
npm run build:web      # Web bundle   (--dart-define-from-file=config.dev.json)
```

Build commands are intended for deploy time — run them whenever you cut a release.

<a id="troubleshooting"></a>

## 🔧 Troubleshooting

| Symptom | Fix |
| :--- | :--- |
| Server exits with the red config banner | Fill the missing variables in `server/.env` (names are listed in the banner) |
| `npm run dev` fails on the client step | Create `client/config.dev.json` (same keys as `.env`, JSON format) |
| `prisma migrate` connection errors | Use a valid `DIRECT_URL` that bypasses the Supabase pooler |
| App boots without sign-in | Missing/empty `SUPABASE_URL` / `SUPABASE_ANON_KEY` → the app starts in offline mode; check your dart-define file |
| AI replies say the assistant is busy | All providers were under load — tap **Retry**, or set `GROQ_API_KEY` to add a fallback provider |

<a id="roadmap"></a>

## 🗺️ Roadmap

- State-by-state PAYE rules beyond the federal baseline
- Filing-deadline reminders and push notifications
- Offline-first quiz mode with sync
- Broader AI knowledge base as NRS guidance evolves

<a id="documentation"></a>

## 📖 Documentation

- [`Project Diagrams/`](Project%20Diagrams) — ERD, use-case, activity, class, and sequence diagrams
- `NaijaTax_System_Documentation.md` — extended system documentation (local copy)
- [`server/prisma/schema.prisma`](server/prisma/schema.prisma) — canonical data model
- [`server/.env.example`](server/.env.example) — server environment template

<a id="contributing"></a>

## 🤝 Contributing

1. Fork the repository and create a feature branch (`git checkout -b feature/my-change`)
2. Make your changes with focused commits
3. Run `npm run analyze` and `npm run lint:server`
4. Open a pull request describing the change and its motivation

Bug reports and feature requests are welcome via [Issues](https://github.com/TobiasA1/Naijatax/issues).

<a id="license"></a>

## 📄 License

Released under the MIT License — see [LICENSE](LICENSE).

---

<div align="center">
  <sub>Built for Nigerian taxpayers · NaijaTax Enlighten © 2026</sub>
</div>
