# NaijaTax Enlighten — Architecture, Packages & Database Reference

> Complete reference for the NaijaTax system: every third-party package on client and server
> (what it is, why it was chosen, where it is used), how the client and server integrate with
> each other and with external services, and the full PostgreSQL database schema with table
> structures and relationships.
>
> **Tech stack:** Flutter (Riverpod, GoRouter, Hive) · Express + TypeScript · Prisma ORM ·
> PostgreSQL (Supabase) · Supabase Auth & Storage · Google Gemini AI · World Bank API

---

## 1. System Overview

```
┌────────────────────────────────  FLUTTER CLIENT (Android · iOS · Web · Desktop)  ───────────────────────────────┐
│                                                                                                                │
│  UI (screens/)  ── Riverpod Providers ── Services ──┬── api_service.dart (Dio) ──────────┐                      │
│   landing · auth · dashboard · calculator ·         ├── auth_provider (Supabase Auth) ──┤                      │
│   vat · quiz · forum · ai_chat · news · learn ·     ├── storage_service (Hive ×3)      │                      │
│   documents · profile · onboarding · support        ├── pdf_service (pdf + printing)   │                      │
│                                                     ├── avatar_service (image_picker)  │                      │
│                                                     ├── biometric_service (local_auth) │                      │
│                                                     └── inflation_service (Dio) ────────┼── World Bank API     │
└────────────────────────────────────────────────────────────────────────────────────────┼──────────────────────┘
                                                 │ HTTPS · JSON ({success, data|error}) │
                                                 ▼                                      │
┌────────────────────────────────  EXPRESS SERVER (Render)  ────────────────────────────┐│
│  server.ts middleware pipeline: rate-limit → compression → helmet → cors → json →     ││
│  sanitize-html → routes → 404 → errorHandler                                          ││
│                                                                                       ││
│  /api/v1 ── routes: tax · ai · forum · quiz · news · users ── controllers ── services ││
│                                    │            │                                    ││
│              auth.middleware (jose + Supabase JWKS)                                   ││
│                                    │                                                  ││
│              config/database.ts (Prisma + @prisma/adapter-pg) ◄──────────────────────┘│
└──────────────────────────────────────┬─────────────────────────────────────────────────┘
                                       │ SQL (pooler)
                                       ▼
                     ┌──── PostgreSQL (Supabase) — 11 tables ────┐
                     │ users · tax_profiles · vat_items ·        │
                     │ quiz_questions · quiz_scores ·            │
                     │ chat_sessions · chat_messages ·           │
                     │ forum_topics · forum_replies ·            │
                     │ forum_votes · tax_articles                │
                     └──────────────┬────────────────────────────┘
                                    │
   Supabase Auth (email OTP/password + Google OAuth)   Supabase Storage (avatar bucket)
   ▲ direct from client (supabase_flutter)             ▲ direct from client after upload
   │                                                   │
   │   Google Gemini (@google/genai) ◄── server ai.service.ts (GEMINI_API_KEY)
   │   RSS feeds (rss-parser) ◄───────── server news.service.ts (30-min sync)
   └── Google Sign-In (google_sign_in) ─► client auth_provider
```

**Request envelope:** every API response uses `{ success: true, data }` or
`{ success: false, error: { code, message } }` — produced centrally by
`server/src/utils/response.ts` and consumed by `client/lib/services/api_service.dart`.

**Why this stack**

| Layer | Choice | Reason |
|---|---|---|
| Client state | Riverpod | Compile-safe DI, testable providers, no BuildContext plumbing |
| Routing | GoRouter | Declarative URL/path routes, deep-link + web support, redirect guards |
| Offline | Hive (hive_ce_flutter) | Millisecond key-value/noSQL reads for settings, cached articles, tax profile drafts |
| Server | Express 4 + TypeScript | Small, well-understood HTTP layer; strong typing via tsc in CI |
| DB access | Prisma 7 + driver adapter | Type-safe queries, migrations, one schema for client + server |
| Auth | Supabase Auth verified server-side via jose | Client gets tokens free; server verifies JWT against Supabase JWKS — no session store needed |
| AI | Google Gemini via `@google/genai` | Generative AI for chat, statement extraction, quiz generation |
| News | `rss-parser` + in-memory scheduler | Self-hosted sync of FIRS/other feeds into `tax_articles` every 30 min |

---

## 2. Client Packages (Flutter)

Declared in `client/pubspec.yaml`. Versions are the declared constraints.

### 2.1 Runtime dependencies

| Package | Version | Category | Why chosen / what for | Where used |
|---|---|---|---|---|
| `flutter` (SDK) | ≥3.9 / Dart ≥3.9 | Framework | UI toolkit for Android, iOS, Web, Desktop from one codebase | Entire `client/lib` |
| `flutter_riverpod` | ^2.5.1 | State management | Central reactive state: no context plumbing, auto-dispose, overrideable in tests | 8 providers in `lib/providers/` (`auth`, `tax`, `vat`, `quiz`, `forum`, `article`, `inflation`, `theme`) consumed by ~38 screen/widget files |
| `go_router` | ^17.3.0 | Navigation | Declarative route table with redirect guards (auth/onboarding gates) and web URL support | `lib/core/router/app_router.dart` + `context.go/push` in ~23 files |
| `flutter_web_plugins` | SDK | Navigation (web) | `setUrlStrategy(PathStrategy)` to drop `/#/` from web URLs | router setup |
| `curved_navigation_bar` | ^1.0.6 | UI chrome | Animated bottom navigation for the post-auth shell | `lib/widgets/adaptive_scaffold.dart` |
| `dio` | ^5.7.0 | Networking | HTTP client with interceptors (auth token injection), timeouts, typed errors — used both for the API and external calls | `lib/services/api_service.dart` (all REST calls), `lib/services/inflation_service.dart` (World Bank) |
| `supabase_flutter` | ^2.6.0 | Auth / Backend | Supabase Auth (email/password, phone OTP, session persistence), Storage client for avatars, deep links for email redirects | `lib/providers/auth_provider.dart`, `lib/services/avatar_service.dart`, `lib/services/storage_service.dart` |
| `google_sign_in` | ^6.2.2 | Auth | Google OAuth credential → Supabase sign-in token exchange | `lib/providers/auth_provider.dart` |
| `hive_ce_flutter` | ^2.3.4 | Offline storage | Fast local boxes for offline capability: settings, cached learn articles, tax-profile drafts | `lib/services/storage_service.dart` → boxes `settingsBox`, `articlesBox`, `taxProfileBox` (opened in `main.dart`) |
| `local_auth` | ^3.0.1 | Security | Fingerprint/Face unlock gate over saved session | `lib/services/biometric_service.dart` (settings flag stored in `shared_preferences`) |
| `fl_chart` | ^1.2.0 | Charts | Line/bar charts for dashboard trends and calculator breakdowns | Dashboard & calculator screens |
| `pdf` | ^3.11.1 | PDF generation | Programmatically lays out tax computation / history receipts | `lib/services/pdf_service.dart` |
| `printing` | ^5.13.1 | PDF output | Renders the generated PDF for print/share sheet (uses `pdf` document) | `lib/services/pdf_service.dart` |
| `flutter_animate` | ^4.5.0 | Animations | Declarative `.animate()` chains (fades/slides) without hand-rolled controllers | Applied across screens/widgets |
| `google_fonts` | ^8.1.0 | Typography | Plus Jakarta Sans / Inter font families loaded at runtime from `app_theme.dart` | `lib/core/theme/app_theme.dart` |
| `file_picker` | ^12.0.0-beta.7 | Input | Pick bank-statement files for AI parsing | Documents / statement upload flow |
| `image_picker` | ^1.2.2 | Input | Camera/gallery pick for profile avatar | `lib/services/avatar_service.dart`, profile screen |
| `cached_network_image_ce` | ^4.6.4 | UI/network | Disk-cached remote images (avatars, article/news imagery) with placeholder/error handling | Profile, news/learn cards |
| `shared_preferences` | ^2.5.5 | Key-value flags | Small persistent flags (biometric-unlock enabled) | `lib/services/biometric_service.dart` |
| `intl` | ^0.20.2 | Formatting | Currency (₦), dates, numbers — Naira formatter with kobo rounding | `AppFormatter` in `lib/core/utils/`, PDF output, charts |
| `url_launcher` | ^6.3.0 | Integration | Open external links (news sources, learn resources, email) | News/learn/support screens |
| `flutter_markdown` | ^0.7.0 | UI | Renders Gemini's Markdown answers in chat | `lib/screens/ai_chat/` |

*Declared but not installed:* `firebase_core` / `firebase_analytics` are commented out in
`pubspec.yaml` — no Firebase code exists yet; nothing to remove there.

**Dev dependencies**

| Package | Version | Purpose | Where used |
|---|---|---|---|
| `flutter_test` | SDK | Widget/unit test framework | `client/test/widget_test.dart` |
| `flutter_lints` | ^5.0.0 | Lint rule set (`flutter_lints.yaml`) | `flutter analyze` in CI |
| `flutter_launcher_icons` | ^0.14.1 | Generates all Android/iOS/Web/macOS/Windows app icons | Config: `client/flutter_launcher_icons.yaml` (manual `dart run flutter_launcher_icons`) |
| `flutter_native_splash` | ^2.4.3 | Generates native splash screens (Android 12+ and pre-12, iOS, web) | Config: `client/flutter_native_splash.yaml` (manual `dart run flutter_native_splash:create`) |

### 2.2 Client integration deep-dives

**REST + auth token** — `services/api_service.dart` wraps a single `Dio` instance. A request
interceptor calls `Supabase.instance.client.auth.currentSession?.accessToken` and attaches
`Authorization: Bearer <jwt>` to every API call; `baseApiUrl` arrives via
`--dart-define-from-file` (`config.dev.json` / `.env`). Responses are unwrapped from the
`{success, data|error}` envelope and thrown as typed failures the UI shows via
`showAppSnack`.

**Authentication** — `providers/auth_provider.dart` owns all flows: email/password sign-in,
phone OTP, **Google Sign-In** (→ `supabase.auth.signInWithIdToken`), sign-up with email
confirmation, password reset via deep link (`naijatax://`), sign-out, and biometric re-entry
(`local_auth` gate in front of the persisted session). User profile rows are mirrored to the
server's `users` table through the API, keyed by the Supabase auth UUID.

**Offline storage** — `storage_service.dart` opens three Hive boxes:
`settingsBox` (theme + prefs), `articlesBox` (last-fetched learn/news articles for offline
reading), `taxProfileBox` (calculator draft/last result). Hive holds *no images* — image
caches are memory-only per process or handled by `cached_network_image_ce`.

**PDF receipts** — `pdf_service.dart` builds a `pdf` document (tables for income, reliefs,
bands, CIT) with `intl` formatting, then `printing` shows the platform print/share sheet.

**External data** — `inflation_service.dart` + `inflation_provider.dart` call the World Bank
inflation API directly over `Dio` (no server involved).

---

## 3. Server Packages (Express / TypeScript)

Declared in `server/package.json`. `type: module` (ESM), compiled with `tsc` to `dist/`.

### 3.1 Runtime dependencies

| Package | Version | Category | Why chosen / what for | Where used |
|---|---|---|---|---|
| `express` | ^4.21.0 | HTTP framework | Minimal, battle-tested routing/middleware model | `src/server.ts`, all `src/routes/*` |
| `@prisma/client` | ^7.8.0 | ORM | Type-safe queries over all 11 tables, migrations, relation integrity | `src/config/database.ts`; all `src/services/*` |
| `@prisma/adapter-pg` | ^7.8.0 | Driver adapter | Prisma 7 driver-adapter path onto `pg` connections (Supabase pooler URL) | `src/config/database.ts` |
| `zod` | ^3.23.8 | Validation | Fails fast at boot if any env var is missing/malformed | `src/config/env.ts` (+ `prisma.config.ts`) |
| `dotenv` | ^16.6.1 | Config | Loads `.env` before validation | `src/config/env.ts`, `prisma.config.ts`, `prisma/seed.ts` |
| `jose` | ^6.2.3 | Security (JWT) | Verifies Supabase access tokens against the tenant **JWKS** (ES256/RS256) — stateless auth, no session store | `src/auth/auth.middleware.ts` |
| `helmet` | ^7.1.0 | Security | Secure default HTTP headers | `src/server.ts` |
| `cors` | ^2.8.5 | Security | Origin allow-list from `CORS_ORIGINS` (web client) | `src/server.ts` |
| `express-rate-limit` | ^8.5.2 | Security | 4 limiters: global 500/15min, AI 30, parse 10, calculate 120 — protects paid Gemini quota | `src/server.ts` |
| `compression` | ^1.8.2 | Performance | gzip responses (cost on Render bandwidth) | `src/server.ts` |
| `sanitize-html` | ^2.3.0→^2.17.5 | Security | Strips HTML from every string in every JSON body (XSS) before controllers see it | recursive middleware in `src/server.ts` |
| `multer` | ^2.2.0 | Uploads | Multipart handling for bank-statement upload (memory storage, size-capped) | `src/routes/tax.routes.ts` (`POST /tax/parse-statement`) |
| `pdf-parse` | ^1.1.1 | Content extraction | Extracts raw text from uploaded PDF statements for AI parsing | `src/services/tax.service.ts` |
| `rss-parser` | ^3.13.0 | External feeds | Fetches FIRS/other tax RSS feeds | `src/services/news.service.ts` |
| `@google/genai` | ^2.8.0 | AI | Google Gemini: chat assistant, statement extraction, quiz/article generation | `src/services/ai.service.ts`, `tax.service.ts` (with fallbacks handled per service) |

### 3.2 Dev dependencies

| Package | Version | Purpose |
|---|---|---|
| `typescript` | ^5.6.0 | `tsc` compile (`npm run build`) + `tsc --noEmit` type-check in CI |
| `tsx` | ^4.21.1 | Watched ESM dev runner (`npm run dev`) and Prisma seed execution |
| `prisma` | ^7.8.0 | CLI: `generate`, `migrate dev`, `db seed` (via `node_modules\prisma\build\index.js`) |
| `vitest` | ^4.1.8 | Test runner for `src/services/tax.service.test.ts` (21 tests; fakes env via `vitest.config.ts`) |
| `@types/express` `@types/cors` `@types/compression` `@types/multer` `@types/pdf-parse` `@types/sanitize-html` `@types/node` | various | Type definitions for the packages above |

### 3.3 Server integration deep-dives

**Middleware pipeline** (exact order in `src/server.ts`):

1. `trust proxy = 1` — correct client IPs behind Render's load balancer (rate limiting)
2. `express-rate-limit` — global limiter, then endpoint-specific limiters mounted just before routes
3. `compression()` → `helmet()` → `cors(origin list, credentials)`
4. `express.json({ limit: "100kb" })`
5. recursive **sanitize-html** body scrubbing (strings only, tags stripped)
6. `GET /` health (raw `SELECT 1` probe for UptimeRobot)
7. `/api/v1` router → sub-routers `tax · ai · forum · quiz · news · users` (+ `/health`)
8. 404 catcher → global `errorHandler` (uniform envelope, logs stack, maps known codes to HTTP status)
9. after boot: news sync scheduler (first run +10s, then every 30 min, mutex-guarded)

**Environment boot-gating** — `config/env.ts` reads `.env` via `dotenv` and validates with
`zod`; the process exits at startup if anything required (`DATABASE_URL`,
`SUPABASE_URL`, `GEMINI_API_KEY`, …) is missing.

**Database connection** — `config/database.ts` creates the Prisma client using
`@prisma/adapter-pg` pointed at the Supabase Postgres pooler URL; exported singleton
`prisma` is imported by every service.

**Auth** — `auth/auth.middleware.ts` fetches Supabase's JWKS (via `jose`) and verifies each
request's `Authorization: Bearer` token (signature, expiry, issuer, audience). On success it
attaches `req.user = { id, email }` — the `id` is the Supabase auth UUID that also is
`users.id`, tying every write to a row. Routes marked public (health, some GETs) skip it.

**Upload → AI pipeline** — `POST /api/v1/tax/parse-statement` (limiter 10/15min):
`multer` (memory, capped size) → `pdf-parse` text extraction → Gemini prompt → normalized
income/deduction suggestion returned to the client.

**AI chat** — `POST /api/v1/ai/message` (limiter 30/15min): loads/persists
`chat_sessions`/`chat_messages`, builds a prompt from `config/prompts.ts` system
instructions + recent history, calls Gemini, streams/stores the reply.

**News sync** — `news.service.ts` polls feeds with `rss-parser`, upserts normalized items
into `tax_articles` (dedupe by URL), enforcing `is_featured`/`category`/`published_at`.

---

## 4. Root Workspace Tooling

Root `package.json` only orchestrates (no runtime code):

| Package | Version | Purpose |
|---|---|---|
| `concurrently` | ^9.1.0 | `npm run dev` runs `dev:server` + `dev:client` in one terminal with color-labeled output |

Scripts: `dev`, `dev:server`, `dev:client`, `dev:web`, `build:server`, `build:client`
(APK), `build:web`, `analyze`, `lint:server`, `db:migrate`, `db:seed`.
CI lives in `.github/workflows/ci.yml` (server: `tsc --noEmit` + `vitest`; client:
`flutter analyze --no-pub` + widget test).

---

## 5. Database Schema (PostgreSQL via Prisma on Supabase)

Source of truth: `server/prisma/schema.prisma` (11 models → 11 physical tables).

### 5.1 How Prisma maps to PostgreSQL

| Prisma construct | PostgreSQL result |
|---|---|
| `@@map("snake_case")` | physical table name (model name stays PascalCase in code) |
| `@map("snake_case")` | physical column name (field stays camelCase in code) |
| `String @id` (User) | `text PRIMARY KEY` — holds the Supabase auth UUID |
| `String @id @default(cuid())` | `text PRIMARY KEY` — client-generated cuid |
| `Decimal @db.Decimal(p, s)` | `NUMERIC(p, s)` (exact money arithmetic) |
| `Json` | `JSONB` (arrays: options, tags) |
| `DateTime` / `@default(now())` | `timestamp(3)` / server-side default |
| `@updatedAt` | updated by Prisma client on each update |
| `Boolean @default(...)` | `boolean` with default |
| scalar FK field (`userId`) + `@relation(..., onDelete: Cascade)` | `user_id TEXT REFERENCES users(id) ON DELETE CASCADE` |
| `@unique` / `@@unique([...])` | unique constraint (supports `ON CONFLICT`) |
| `@@index([...])` | secondary index for query paths |

### 5.2 Table structures

#### `users` ← model `User` — identity mirror of Supabase Auth
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK | Supabase auth UUID |
| email | text | UNIQUE, nullable | email-based sign-in |
| phone | text | UNIQUE, nullable | phone-based sign-in |
| display_name | text | nullable | profile name |
| avatar_url | text | nullable | Supabase Storage URL |
| address | text | nullable | residential address |
| onboarded | boolean | default false | onboarding completed |
| role | text | default `'USER'` | `USER` \| `ADMIN` |
| created_at | timestamp(3) | default now() | created |
| updated_at | timestamp(3) | @updatedAt | last update |

#### `tax_profiles` ← model `TaxProfile` — saved calculator runs / tax history
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK (cuid) | |
| user_id | text | FK → users.id, CASCADE, **indexed with created_at** | owner |
| monthly_income | NUMERIC(15,2) | | input |
| annual_gross | NUMERIC(15,2) | | input |
| rent_paid | NUMERIC(15,2) | | rent relief input |
| pension_rate | NUMERIC(4,2) | | pension % input |
| computed_tax | NUMERIC(15,2) | | PAYE result |
| net_income | NUMERIC(15,2) | | after-tax result |
| is_exempt | boolean | default false | ≤ ₦800k exemption |
| cit_exemption | text | default `'EXEMPT'` | CIT status (EXEMPT / TAXABLE_20 / TAXABLE_30 / conditions text) |
| turnover | NUMERIC(15,2) | default 0 | CIT turnover input |
| assets | NUMERIC(15,2) | default 0 | CIT total assets input |
| flat_rate | NUMERIC(6,4) | nullable | user-selected flat rate (percentage mode) |
| rent_relief_rate | NUMERIC(6,4) | nullable | custom rent-relief rate |
| created_at | timestamp(3) | default now() | |

#### `vat_items` ← model `VatItem` — reference data for the VAT lookup tool
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK (cuid) | |
| name | text | UNIQUE | item/service name |
| category | text | | grouping |
| status | text | **indexed** | `STANDARD` \| `ZERO_RATED` \| `EXEMPT` |
| rate | NUMERIC(4,2) | | e.g. 7.50 |
| created_at | timestamp(3) | default now() | |

#### `quiz_questions` ← model `QuizQuestion` — tax quiz bank (seeded)
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK (cuid) | |
| question | text | | prompt |
| options | JSONB | | array of answer strings |
| correct_index | integer | | index of right option |
| explanation | text | | shown after answering |
| created_at | timestamp(3) | default now() | |

#### `quiz_scores` ← model `QuizScore` — per-user results
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK (cuid) | |
| user_id | text | FK → users.id, CASCADE, indexed (user_id, created_at) | owner |
| score | integer | | correct answers |
| total_questions | integer | | quiz size |
| created_at | timestamp(3) | default now() | |

#### `chat_sessions` ← model `ChatSession` — AI chat threads
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK (cuid) | |
| user_id | text | FK → users.id, CASCADE, indexed (user_id, updated_at) | owner |
| title | text | | thread title |
| created_at | timestamp(3) | default now() | |
| updated_at | timestamp(3) | @updatedAt | recency ordering |

#### `chat_messages` ← model `ChatMessage` — messages inside a session
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK (cuid) | |
| session_id | text | FK → chat_sessions.id, CASCADE, indexed (session_id, created_at) | parent thread |
| role | text | | `user` \| `assistant` \| `system` |
| content | text | | message body |
| created_at | timestamp(3) | default now() | |

#### `forum_topics` ← model `ForumTopic` — community questions
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK (cuid) | |
| title | text | | topic title |
| content | text | | body |
| tags | JSONB | | e.g. `["PAYE","VAT"]` |
| user_id | text | FK → users.id, CASCADE, indexed (user_id, created_at) | author |
| up_votes / down_votes | integer | default 0 | denormalized tallies (fast list rendering) |
| created_at | timestamp(3) | default now() | |
| updated_at | timestamp(3) | @updatedAt | edited marker |

#### `forum_replies` ← model `ForumReply` — answers to topics
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK (cuid) | |
| topic_id | text | FK → forum_topics.id, CASCADE, indexed (topic_id, created_at) | parent topic |
| user_id | text | FK → users.id, CASCADE | author |
| content | text | | reply body |
| is_accepted | boolean | default false | marked solution |
| created_at | timestamp(3) | default now() | |

#### `forum_votes` ← model `ForumVote` — one vote per user per topic
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK (cuid) | |
| topic_id | text | FK → forum_topics.id, CASCADE | target |
| user_id | text | FK → users.id, CASCADE, indexed (user_id, created_at) | voter |
| direction | integer | | `1` upvote, `-1` downvote |
| created_at | timestamp(3) | default now() | |
| — | — | **UNIQUE (topic_id, user_id)** | prevents double-voting |

#### `tax_articles` ← model `TaxArticle` — news/learn content (seeded + RSS-synced)
| Column (DB) | Type | Constraints | Purpose |
|---|---|---|---|
| id | text | PK (cuid) | |
| title / summary / content | text | | article body parts |
| source | text | | e.g. FIRS, KPMG |
| category | text | nullable, **indexed** | `NTA_2025` \| `PAYE` \| `CIT` \| `VAT` \| `COMPLIANCE` |
| url | text | nullable | canonical link |
| is_featured | boolean | default false | indexed (is_featured, created_at DESC) |
| published_at | timestamp(3) | nullable | original feed time |
| created_at | timestamp(3) | default now(), **indexed DESC** | feed order |

### 5.3 Relationships

| Parent | Child | FK column | Cardinality | On delete |
|---|---|---|---|---|
| users | tax_profiles | user_id | 1 : N | CASCADE |
| users | quiz_scores | user_id | 1 : N | CASCADE |
| users | chat_sessions | user_id | 1 : N | CASCADE |
| chat_sessions | chat_messages | session_id | 1 : N | CASCADE |
| users | forum_topics | user_id | 1 : N | CASCADE |
| forum_topics | forum_replies | topic_id | 1 : N | CASCADE |
| users | forum_replies | user_id | 1 : N | CASCADE |
| forum_topics | forum_votes | topic_id | 1 : N | CASCADE |
| users | forum_votes | user_id | 1 : N | CASCADE |

Reference (standalone, no FKs): **`vat_items`**, **`quiz_questions`**, **`tax_articles`**.

```
                        ┌────────────┐
                        │   users    │  Supabase auth UUID
                        └─────┬──────┘
        ┌──────────┬──────────┼──────────┬───────────┬───────────┐
        ▼          ▼          ▼          ▼           ▼           ▼
 tax_profiles  quiz_scores  chat_sessions  forum_topics  forum_replies  forum_votes
                            │        │        │      ▲         │     │       │
                            ▼        │        │      │         │     │       │
                     chat_messages    │        │      └─────┬───┘     │       │
                                      │        └────────────┼─────────┘       │
                                      │                     │                 │
                                      └───(all cascade)─────┴─────────────────┘

  Standalone reference tables (no FK):  vat_items · quiz_questions · tax_articles
```

Deleting a `users` row (or signing-out-and-purging) therefore removes all of that user's
profiles, scores, sessions/messages, topics, replies, and votes atomically.

### 5.4 Feature → table integration map

| App feature | Client entry | API (Express) | Tables touched |
|---|---|---|---|
| Sign-up / sign-in / profile | `auth_provider` | `POST/GET/PATCH /api/v1/users` | `users` |
| Onboarding wizard | onboarding screens | `users` | `users` |
| Tax calculator + history | `tax_provider` | `POST /api/v1/tax/calculate`, `GET/DELETE /api/v1/tax/profiles` | `tax_profiles` |
| Statement upload (AI parse) | documents screen | `POST /api/v1/tax/parse-statement` (multer → pdf-parse → Gemini) | none (stateless) |
| VAT lookup tool | `vat_provider` | `GET /api/v1/tax/vat-items` | `vat_items` |
| Quiz play + results | `quiz_provider` | `GET /api/v1/quiz/questions`, `POST /api/v1/quiz/score` | `quiz_questions`, `quiz_scores` |
| AI chat | `ai_chat` screen | `POST /api/v1/ai/message`, `GET /api/v1/ai/sessions` | `chat_sessions`, `chat_messages` |
| Forum (list/post/reply/vote) | `forum_provider` | `/api/v1/forum/*` | `forum_topics`, `forum_replies`, `forum_votes`, `users` |
| News + Learn articles | `article_provider` | `GET /api/v1/news` (synced from RSS) | `tax_articles` |
| Profile picture | `avatar_service` | — (direct Supabase Storage) | `users.avatar_url` |
| Offline settings/articles/drafts | `storage_service` | — (client-only) | Hive boxes, no SQL |
| Inflation stats | `inflation_provider` | — (direct World Bank API) | none |
| PDF receipt | `pdf_service` | — (client-only generation) | none |

---

## 6. End-to-End Flows

1. **Authentication** — Client → Supabase Auth (password / OTP / Google) → access JWT.
   Client attaches JWT to every API call; server `auth.middleware` verifies it against
   Supabase JWKS; `req.user.id` (UUID) upserts/reads `users`. Email reset uses Supabase
   template with `{{ .Token }}`; redirect deep link `naijatax://`.
2. **Tax calculation** — Calculator UI → `POST /tax/calculate` (120/15min limiter) →
   `tax.service.ts` computes PAYE bands (0/15/18/21/23/25% above ₦800k) + CIT rule →
   result returned; client saves via `POST /tax/profiles` → row in `tax_profiles`.
   Receipt rendered client-side (`pdf` + `printing`).
3. **Statement parsing** — `file_picker` → `POST /tax/parse-statement` (10/15min) →
   multer memory upload → `pdf-parse` text → Gemini extraction prompt → suggested figures
   back to the calculator form (nothing persisted).
4. **AI chat** — Chat UI → `POST /ai/message` (30/15min) → session/history load →
   system prompt (`prompts.ts`) + history → Gemini → reply stored in `chat_messages`,
   session `updated_at` bumped → Markdown rendered by `flutter_markdown`.
5. **Forum** — Topics/replies CRUD under JWT; votes enforce `UNIQUE(topic_id,user_id)`;
   tallies updated on `forum_topics.up_votes/down_votes`.
6. **Quiz** — Question bank read-only (seeded); scores appended to `quiz_scores`.
7. **News** — Server cron (30 min) fetches RSS → upserts `tax_articles` → client lists via
   `/news` (category/featured indexes serve the queries).
8. **Avatar** — `image_picker` → Supabase Storage upload → public URL saved to
   `users.avatar_url` via `/users` PATCH → `cached_network_image_ce` renders it.

---

## 7. Package Audit

| Area | Verdict |
|---|---|
| **Client runtime (21 installed)** | **All 21 used.** Every dependency resolves to at least one import in `lib/` (verified by code search). |
| **Client `flutter_localizations`** | **Unused — removed.** Was declared (`sdk: flutter`) but never imported anywhere and no `localizationsDelegates`/`supportedLocales` were configured, so it contributed nothing at runtime. |
| **Client dev deps (4)** | All used: `flutter_test` (tests), `flutter_lints` (analyze), `flutter_launcher_icons` + `flutter_native_splash` (asset generation). |
| **Client commented-out** | `firebase_core`, `firebase_analytics` remain commented in `pubspec.yaml` — not installed, no dead code references. |
| **Server runtime (14)** | **All 14 used** — each package maps to concrete imports (table in §3.1). |
| **Server dev (8)** | All used (build, run, test, type-check, seed, migration). |
| **Root** | `concurrently` used by `npm run dev`. |
| **Cosmetic note** | `pubspec.yaml` comment claims `shared_preferences` stores a "theme toggle" — theme actually persists in Hive's `settingsBox`; the preference stores the biometric flag. Harmless comment drift. |
