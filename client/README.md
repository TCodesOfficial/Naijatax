# NaijaTax Enlighten — Flutter Client

The Flutter application for **NaijaTax Enlighten**, a cross-platform Nigerian tax
companion: PAYE/CIT calculation, a VAT reference, an AI tax assistant, community
forum, quizzes, and NTA 2025 learning material — on Android, iOS, web, and desktop.

> Full project documentation lives in the [repository root README](../README.md).

## Prerequisites

- Flutter with Dart SDK `>= 3.9 < 4.0`
- A running instance of the NaijaTax API (see [`../server`](../server))
- A Supabase project (Auth + Storage)

## Configuration

The app reads its configuration from dart-define files via
`--dart-define-from-file`. Create `client/.env` (properties format):

```properties
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
API_BASE_URL=http://localhost:3000/api/v1
GOOGLE_WEB_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=your-ios-client-id.apps.googleusercontent.com
```

`config.dev.json` (JSON format, same keys) is required by the root
`npm run dev` script. Both files are gitignored — never commit real credentials.

## Run

```bash
flutter pub get
flutter run --dart-define-from-file=.env          # mobile/desktop
flutter run -d chrome --dart-define-from-file=.env # web
```

## Project Layout

```
lib/
├── main.dart          # Bootstrap (Hive + Supabase init, ProviderScope)
├── core/              # constants, router (GoRouter), theme, utils
├── models/            # Plain Dart data models
├── providers/         # Riverpod providers (auth, tax, forum, quiz, news…)
├── screens/           # Feature screens (dashboard, ai_chat, forum, quiz…)
├── services/          # API client, storage, PDF generation, biometrics
└── widgets/           # Reusable UI (nav shell, cards, avatars, charts)
```

## Quality

```bash
flutter analyze   # or: npm run analyze (from the repo root)
```
