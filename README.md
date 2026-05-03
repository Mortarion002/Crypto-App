# Crypto Pulse

A high-contrast, editorial-style crypto market tracker built with Flutter. Live price feeds from Binance, cloud auth via Supabase, and a "Vivid Intelligence" dark UI designed to surface market signals at a glance.

---

## Features

| Screen | What it does |
|---|---|
| **Market** | Live 24h ticker for 20+ coins, volatility alert banner, 1D kline chart card, per-coin accent colors |
| **Coin Detail** | Full price chart with 1D / 1W / 1M interval selector, OHLC stats grid, volatility %, watchlist CTA |
| **Insights** | Market mood card (BULLISH / BEARISH / NEUTRAL), volatility gauge (CustomPainter arc + needle), top gainers & losers, AI protocol insight text |
| **Watchlist** | Saved coins with 20-point sparkline, sentiment label, local + Supabase cloud sync |
| **Settings** | Profile entry point, dark theme status, live refresh toggle, sign in/out |
| **Profile** | Supabase session info and account details |
| **Onboarding** | 4-page animated walkthrough with wave painter, stacked card preview, mini bar chart, and large gauge |
| **Auth** | Email/password sign in & sign up, dark fintech design, inline error messages |

**Live data:** Binance public REST API — no API key required.  
**Auth & DB:** Supabase (email/password, Row Level Security on all tables).  
**No secrets in source:** credentials loaded via `--dart-define-from-file`.

---

## Screenshots

> Run `flutter run --dart-define-from-file=.env.json` and open on a device/emulator.

---

## Tech Stack

| Layer | Library | Version |
|---|---|---|
| UI framework | Flutter | SDK ^3.11.5 |
| State management | flutter_riverpod | ^3.3.1 |
| Navigation | go_router | ^17.2.3 |
| HTTP client | dio | ^5.9.2 |
| Auth & DB | supabase_flutter | ^2.0.0 |
| Charts | fl_chart | ^1.2.0 |
| Local storage | shared_preferences | ^2.5.5 |
| Icons | lucide_icons_flutter | ^3.1.13 |
| Animations | flutter_animate | ^4.5.2 |
| Skeleton loading | shimmer | ^3.0.0 |
| Immutable models | freezed + freezed_annotation | ^3.2.5 / ^3.1.0 |
| JSON serialization | json_serializable + json_annotation | ^6.13.0 / ^4.11.0 |
| Code gen | build_runner + riverpod_generator | ^2.15.0 / ^4.0.3 |

---

## Architecture

Feature-first **Clean Architecture** with three layers per feature:

```
lib/
├── app/
│   └── router/              # GoRouter config, route names/paths, refresh notifier
├── core/
│   ├── config/              # Env (dart-define), API endpoints
│   ├── network/             # Dio provider (with pretty logger)
│   ├── providers/           # Shared global providers (SharedPreferences)
│   ├── theme/               # Colors, spacing, radius, typography, theme
│   └── widgets/             # AppScaffold (bottom nav shell)
└── features/
    ├── auth/
    │   ├── domain/          # AppUser entity, AuthRepository interface
    │   ├── data/            # SupabaseAuthRepository implementation
    │   └── presentation/    # AuthController (AsyncNotifier), LoginScreen, SignupScreen
    ├── market/
    │   ├── domain/          # Coin entity (Freezed), MarketRepository interface
    │   ├── data/            # BinanceMarketRemoteDataSource, repository impl
    │   └── presentation/    # MarketController, MarketScreen, widgets
    ├── coin_detail/
    │   ├── domain/          # KlinePoint entity (Freezed), repository interface
    │   ├── data/            # BinanceCoinRemoteDataSource, repository impl
    │   └── presentation/    # CoinDetailController, CoinDetailScreen, chart widgets
    ├── insights/
    │   └── presentation/    # InsightsController (derives from market data), InsightsScreen
    ├── watchlist/
    │   ├── data/            # coinSparklineProvider (FutureProvider.family)
    │   └── presentation/    # WatchlistController (Notifier), WatchlistScreen
    ├── onboarding/
    │   └── presentation/    # OnboardingScreen (4-page PageView)
    └── profile/
        └── presentation/    # SettingsScreen + ProfileScreen
```

### State management patterns

| Pattern | Used for |
|---|---|
| `AsyncNotifierProvider` | Data that loads async: market feed, coin detail, auth session |
| `NotifierProvider` | Synchronous mutable state: watchlist symbol list |
| `Provider` | Derived/computed values: insights, Dio client, repositories |
| `FutureProvider.family` | Per-coin sparkline klines, keyed by symbol string |

Auth state is streamed from Supabase into `AuthController.build()` via a `StreamSubscription`, which also feeds `RouterRefreshNotifier` (a `ChangeNotifier`) so GoRouter re-evaluates the redirect on every sign-in / sign-out.

---

## Design System — "Vivid Intelligence"

Dark editorial palette built on deep brown-black surfaces with high-contrast semantic signal colors:

| Token | Hex | Usage |
|---|---|---|
| `background` | `#1D100E` | App background |
| `canvasLevel1` | `#1E1E1E` | Cards, tiles |
| `vibrantCoral` | `#FF5D52` | Primary CTA, bearish signal, screen titles |
| `mint` | `#C8D8CC` | Bullish signal, positive % change |
| `deepPurple` | `#6C6BFF` | Analytics, neutral sentiment, sparkline fill |
| `cyanHighlight` | `#00FFFF` | Active state, avatar ring, signup CTA |
| `yellow` | `#FFD45A` | Volatility gauge, high-volatility alert |
| `onSurface` | `#F8DCD9` | Primary text |
| `onSurfaceVariant` | `#E2BEBA` | Secondary text, icons |

Per-coin accent colors: BTC → coral · ETH → deepPurple · SOL → cyan · BNB → yellow · ADA → mint · XRP → primary

---

## Navigation & Routes

The router uses a **redirect-based auth guard** evaluated on every navigation and on every Supabase auth state change:

```
/onboarding          → OnboardingScreen   (shown once on first launch)
/auth/login          → LoginScreen        (required when not signed in)
/auth/signup         → SignupScreen
/home                → MarketScreen       ┐
/insights            → InsightsScreen     ├ ShellRoute (bottom nav bar)
/watchlist           → WatchlistScreen    │
/settings            → SettingsScreen     ┘
/profile             → ProfileScreen      (outside shell, opened from Settings)
/coin/:symbol        → CoinDetailScreen   (outside shell, no nav bar)
```

**Redirect logic (evaluated in order):**
1. Onboarding not complete → `/onboarding`
2. Not logged in → `/auth/login` (skipped when already on an auth route)
3. Logged in + visiting auth/onboarding route → `/home`

---

## Data Sources

### Binance REST API (public, no key required)

| Endpoint | Used by | Returns |
|---|---|---|
| `GET /api/v3/ticker/24hr?symbols=[...]` | MarketScreen, InsightsScreen | 24h price, change %, volume, high/low for multiple symbols at once |
| `GET /api/v3/klines?symbol=X&interval=Y&limit=N` | CoinDetailScreen, Watchlist sparklines | OHLCV candlestick data |

Supported symbols are declared in `lib/core/constants/supported_coins.dart` (BTCUSDT, ETHUSDT, BNBUSDT, SOLUSDT, ADAUSDT, XRPUSDT, and more).

### Supabase

| Table | Columns | Notes |
|---|---|---|
| `profiles` | `id` (uuid PK → auth.users), `email`, `name`, `created_at` | Auto-created via `handle_new_user` trigger on signup |
| `watchlist_items` | `id`, `user_id` (→ auth.users), `symbol`, `created_at` | `UNIQUE(user_id, symbol)`; RLS enforced |

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.11.5 ([install](https://docs.flutter.dev/get-started/install))
- Dart SDK ≥ 3.11.5 (bundled with Flutter)
- A Supabase project ([supabase.com](https://supabase.com))

### 1. Clone

```bash
git clone https://github.com/Mortarion002/Crypto-App.git
cd Crypto-App/crypto_pulse
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Set up environment variables

Copy the example file and fill in your Supabase credentials:

```bash
cp .env.example.json .env.json
```

Edit `.env.json`:

```json
{
  "SUPABASE_URL": "https://your-project-id.supabase.co",
  "SUPABASE_ANON_KEY": "your_supabase_anon_key"
}
```

> `.env.json` is gitignored and never committed.  
> Find your URL and anon key in the Supabase dashboard under **Project Settings → API**.

### 4. Set up the Supabase database

Open the [Supabase SQL Editor](https://app.supabase.com/project/_/sql/new) for your project, paste the contents of [`supabase/migrations/001_init.sql`](supabase/migrations/001_init.sql), and click **Run**.

This creates:
- `profiles` table with RLS (auto-populated on signup via trigger)
- `watchlist_items` table with RLS
- `handle_new_user` function + trigger

### 5. Run

```bash
flutter run --dart-define-from-file=.env.json
```

Target a specific platform:

```bash
flutter run -d android --dart-define-from-file=.env.json
flutter run -d ios     --dart-define-from-file=.env.json
flutter run -d chrome  --dart-define-from-file=.env.json
```

---

## Building for Release

```bash
# Android APK
flutter build apk --dart-define-from-file=.env.json

# Android App Bundle (Play Store)
flutter build appbundle --dart-define-from-file=.env.json

# iOS
flutter build ios --dart-define-from-file=.env.json
```

---

## Code Generation

The project uses `build_runner` for Freezed models and Riverpod generators. Re-run after modifying any `@freezed` or `@riverpod` annotated file:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Watch mode during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Watchlist Sync

The watchlist is **local-first** (SharedPreferences) with fire-and-forget cloud sync:

- **On app start (logged in):** cloud symbols are fetched from `watchlist_items` and merged into the local list
- **On toggle:** local state updates immediately; Supabase upsert / delete runs in the background
- **Offline / not logged in:** local state always works; cloud sync silently skips

---

## Insights Derivation

`InsightsController` derives everything from the market data — no extra API calls:

| Metric | Calculation |
|---|---|
| Market mood | `gainers > losers` → BULLISH · `losers > gainers` → BEARISH · else NEUTRAL |
| Volatility index | Avg absolute 24h change across all coins × 10, clamped 0–100 |
| Volatility level | < 30 → LOW · 30–60 → MODERATE · > 60 → HIGH |
| Alert banner | Shown on MarketScreen only when `volatilityLevel == high` |

---

## Project Structure Reference

```
crypto_pulse/
├── .env.json                              # Local secrets (gitignored)
├── .env.example.json                      # Template to copy
├── pubspec.yaml
├── supabase/
│   └── migrations/
│       └── 001_init.sql                   # Run once in Supabase SQL Editor
└── lib/
    ├── main.dart                          # Supabase.initialize + ProviderScope
    ├── app/
    │   └── router/
    │       ├── app_router.dart            # GoRouter with redirect guard
    │       ├── route_names.dart           # RouteNames + RoutePaths constants
    │       └── router_refresh_notifier.dart  # ChangeNotifier on auth stream
    ├── core/
    │   ├── config/
    │   │   ├── env.dart                   # String.fromEnvironment wrappers
    │   │   └── api_endpoints.dart         # Binance base URL + paths
    │   ├── constants/
    │   │   └── supported_coins.dart       # Tracked symbol list
    │   ├── network/
    │   │   └── dio_provider.dart          # Dio with PrettyDioLogger
    │   ├── providers/
    │   │   └── shared_prefs_provider.dart
    │   ├── theme/
    │   │   ├── app_colors.dart            # Full palette
    │   │   ├── app_radius.dart            # BorderRadius constants
    │   │   ├── app_spacing.dart           # Padding / gap constants
    │   │   ├── app_theme.dart             # ThemeData (dark)
    │   │   └── app_typography.dart        # TextTheme
    │   └── widgets/
    │       └── app_scaffold.dart          # Bottom nav + ShellRoute child
    └── features/
        ├── auth/                          # Supabase email/password auth
        ├── coin_detail/                   # Per-coin chart + OHLC stats
        ├── insights/                      # Mood card, volatility gauge, movers
        ├── market/                        # Live 24h market feed
        ├── onboarding/                    # First-launch 4-page walkthrough
        ├── profile/                       # Settings + Supabase session info
        └── watchlist/                     # Saved coins with sparklines
```

---

## License

MIT — see [LICENSE](LICENSE).
