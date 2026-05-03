# Crypto Pulse Flutter - Project Status

Last updated: 2026-05-04

---

## Current Snapshot

Crypto Pulse is a Flutter mobile crypto sentiment dashboard using Binance public market APIs, Supabase auth/database, Riverpod state management, GoRouter navigation, SharedPreferences local storage, and the "Vivid Intelligence" dark editorial design system from the Stitch references.

Validation on 2026-05-04:
- Latest quick validation: `dart analyze` has no issues after the Settings/Profile and Insights fixes.
- Latest auth validation: signup controller tests pass after the signup feedback fix.
- Earlier full validation: `flutter test` passes 66 tests.
- Earlier build validation: `flutter build apk --debug --dart-define-from-file=.env.json` succeeds.
- Full test/build were not rerun for the latest UI batch, per request to avoid unnecessary tests.
- Git remote: `origin` -> `https://github.com/Mortarion002/Crypto-App.git`.
- Recent pushes include the Settings/Profile split, project status refresh, and signup feedback/logging fix.

---

## Latest Completed Work

### Navigation And Screens
- [x] Replaced the last bottom navigation item from Profile to Settings.
- [x] Added `/settings` and `RouteNames.settings`.
- [x] Added `SettingsScreen` as the fourth shell tab.
- [x] Moved `ProfileScreen` outside the bottom navigation shell.
- [x] Added a Profile row/button inside Settings that opens the Profile screen.
- [x] Simplified Profile into an account-details screen instead of mixing it with settings.

### Insights Fixes
- [x] Fixed the Insights AI Protocol card overflow shown on narrow mobile screens.
- [x] Changed the AI Protocol action buttons from a fixed horizontal row to a wrapping layout.

### Settings Behavior
- [x] Kept the dark theme row visible but locked, because only dark theme exists right now.
- [x] Kept the live refresh toggle wired to `SharedPreferences`.
- [x] Kept live refresh changes invalidating `MarketController`.
- [x] Kept Settings sign in/sign out actions wired to auth routes/controller.

### Native Launch And Icon Polish
- [x] Added launcher icon generation.
- [x] Replaced the default black/white native splash behavior.
- [x] Configured native launch surfaces to show the app icon on the app-colored launch screen.

### Documentation And Validation
- [x] Updated README navigation/features to mention Settings plus separate Profile.
- [x] Updated route-name tests to include Settings route constants.
- [x] Ran `dart analyze` after the latest code changes; no issues found.
- [x] Pushed the latest implementation batch to GitHub.

### Auth Feedback And Logging
- [x] Fixed signup UX when Supabase creates a user without an active session, such as email confirmation flows.
- [x] Added a success state on signup so users know to confirm email and then sign in.
- [x] Preserved friendly signup error messages for duplicate accounts, invalid emails, and short passwords.
- [x] Reduced Binance Dio logging noise by hiding full response bodies in debug logs.

---

## What Is Done

### Infrastructure
- [x] Flutter project with go_router, flutter_riverpod, dio, fl_chart, shimmer, flutter_animate, freezed, supabase_flutter, shared_preferences, lucide icons, and related tooling.
- [x] Feature-first folder architecture under `features/`, `core/`, and `app/`.
- [x] App theme system: `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, and dark `ThemeData`.
- [x] GoRouter with onboarding, auth, shell tabs, coin detail, auth redirect guard, and `RouterRefreshNotifier`.
- [x] Floating pill-style bottom navigation in `AppScaffold` with Settings as the last tab.
- [x] Riverpod `ProviderScope` and SharedPreferences override wired in `main.dart`.
- [x] Secret loading via `--dart-define-from-file=.env.json`.
- [x] `.env.example.json` committed; `.env.json` gitignored.
- [x] Supabase migration for `profiles`, `watchlist_items`, RLS policies, and signup trigger.

### Data And Domain
- [x] Binance 24h ticker endpoint for market data.
- [x] Binance klines endpoint for coin detail charts and watchlist sparklines.
- [x] Dio client with timeout and pretty logger.
- [x] `Coin`, `KlinePoint`, `AppUser`, and `MarketInsights` models/entities.
- [x] Repository boundaries for auth, market, and coin detail.

### State Management
- [x] `MarketController` auto-refreshes every 30 seconds.
- [x] `coinDetailProvider` loads chart klines by symbol and interval.
- [x] `coinSparklineProvider` loads per-symbol sparkline data.
- [x] `WatchlistController` persists local watchlist and syncs with Supabase when signed in.
- [x] `InsightsController` derives mood, volatility, top gainers/losers, headline, and insight text from market data.
- [x] `AuthController` wraps Supabase auth and maps common auth errors to friendly messages.

### Screens
- [x] Onboarding: 4-page PageView matching the refined visual direction.
- [x] Login and signup: Supabase email/password auth with inline errors.
- [x] Market: personalized-style header, market selector, high-volatility alert, Market Pulse card with BTC chart, top movers, colored coin accent bars.
- [x] Coin Detail: interval selector, price card with chart background, sentiment strength bar, 2x2 stats grid, pinned watchlist CTA.
- [x] Insights: large editorial heading, Market Mood card with LIVE badge, circular volatility gauge, responsive AI Protocol card, gainers/losers lists.
- [x] Watchlist: search bar, live saved coins, sparklines, sentiment labels, empty/end states.
- [x] Settings: profile entry point, dark theme status, live refresh toggle persisted to SharedPreferences, sign in/out.
- [x] Profile: user identity, Supabase status badge, account details, sign out.

### Tests
- [x] `test/features/auth/domain/app_user_test.dart`
- [x] `test/features/market/domain/coin_test.dart`
- [x] `test/features/auth/presentation/auth_controller_test.dart`
- [x] `test/features/insights/insights_controller_test.dart`
- [x] `test/features/watchlist/watchlist_controller_test.dart`
- [x] `test/app/router/route_names_test.dart`
- [x] `test/core/config/env_test.dart`

---

## Phased Execution Plan

### Phase 1 - Status And Roadmap Hygiene
- [x] Replace stale status notes with current implementation reality.
- [x] Record validation state and remaining risks.
- [x] Keep this file updated after each implementation batch.

### Phase 2 - Wire Existing UI Actions
- [x] Replace hardcoded `Hi, Aman!` with the signed-in user's display name.
- [x] Route profile's signed-out Sign In action to login.
- [x] Wire search icons to useful behavior or remove inactive affordances.
- [x] Ensure labels do not claim unavailable behavior.

### Phase 3 - Settings Behavior
- [x] Make Profile's live refresh toggle affect market auto-refresh.
- [x] Keep dark theme toggle persisted, but avoid pretending a light theme exists until implemented.
- [x] Add focused tests for settings-related behavior.

### Phase 4 - Resilience And Data Safety
- [x] Harden Coin Detail when market data is empty or the requested symbol is absent.
- [x] Improve watchlist cloud sync failure handling enough that failures are visible in debug logs and do not silently corrupt local state.
- [x] Avoid duplicate background requests where possible.

### Phase 5 - App Polish
- [x] Fix remaining analyzer info notes.
- [x] Wire app icon assets and launcher icon generation.
- [x] Replace the default black/white native launch splash with the app background color.
- [x] Move Profile out of the bottom tab bar and add Settings as the last tab.
- [x] Fix Insights AI Protocol action overflow on narrow screens.
- [ ] Add visual QA pass on a device/emulator or browser target.

### Phase 6 - Publish Rhythm
- [x] Commit and push each stable phase to GitHub.
- [x] Re-run targeted validation before code pushes.

---

## Known Remaining Issues

- Bell icon currently explains where volatility alerts appear; richer notification settings are not built.
- Settings theme row is intentionally locked to dark because the app only ships a dark theme right now.
- Watchlist cloud sync intentionally favors local-first UX; remote failures are debug-logged but not surfaced to users yet.
- Coin Detail now has empty/error states, but the visual treatment can still be polished.
- App icon is wired for Android, iOS, web, Windows, and macOS.
- Native launch surfaces use `#FF5D52` with the app icon centered while Flutter starts, avoiding the blank black/white startup flash.

---

## Supported Coins

| Symbol | Name | Binance Pair |
|---|---|---|
| BTC | Bitcoin | BTCUSDT |
| ETH | Ethereum | ETHUSDT |
| SOL | Solana | SOLUSDT |
| BNB | BNB | BNBUSDT |
| ADA | Cardano | ADAUSDT |
| XRP | XRP | XRPUSDT |

---

## Sentiment And Volatility Logic

```text
Per coin:    > +2% = Bullish | < -2% = Bearish | otherwise Neutral
Market mood: gainers > losers * 2 = BULLISH | losers > gainers * 2 = BEARISH | otherwise NEUTRAL
Volatility:  avg absolute 24h change < 2% = Low | 2-5% = Moderate | > 5% = High
Index:       avg absolute 24h change * 10, clamped from 0 to 100
```

---

## Supabase Schema

```sql
profiles
  id uuid primary key references auth.users(id)
  email text
  name text
  created_at timestamptz

watchlist_items
  id uuid primary key
  user_id uuid references auth.users(id)
  symbol text
  created_at timestamptz
  unique(user_id, symbol)
```

RLS: users can only read/write rows where `auth.uid()` matches their `id` or `user_id`.

---

## Git

Branch: `main`
Remote: `origin`
Push: `git push origin main`

Run the app with:

```bash
flutter run --dart-define-from-file=.env.json
```
