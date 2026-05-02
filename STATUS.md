# Crypto Pulse Flutter — Project Status

Last updated: 2026-05-02

---

## What Is Done

### Infrastructure
- [x] Flutter project created with full dependency set (go_router, riverpod, dio, fl_chart, shimmer, flutter_animate, freezed, hive, etc.)
- [x] Feature-first folder architecture in place
- [x] App theme system: `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius` — all matching DESIGN.md
- [x] GoRouter configured with named routes for all main screens
- [x] `AppScaffold` with floating pill-style bottom nav (cyan active indicator)
- [x] Riverpod `ProviderScope` wired in `main.dart`
- [x] SharedPreferences provider with override at startup

### API Layer (fully wired)
- [x] Binance public REST API — `GET /ticker/24hr` for all 6 tracked coins
- [x] Binance public REST API — `GET /klines` for coin detail charts (1h, 4h, 1d, 1w intervals)
- [x] Dio HTTP client with 15s timeout and pretty logger
- [x] `BinanceMarketRemoteDataSource` — fetches tickers
- [x] `BinanceCoinRemoteDataSource` — fetches klines with configurable `limit`
- [x] DTOs: `BinanceTickerDto` (freezed), `BinanceKlineDto`

### Domain Models
- [x] `Coin` entity (freezed) — symbol, name, price, priceChange%, volume, high, low, isUp
- [x] `KlinePoint` entity (freezed) — timestamp, open, high, low, close, volume
- [x] `MarketInsights` — topGainers, topLosers, marketHeadline, volatilityIndex
- [x] `WatchlistItem` — stored as `List<String>` (symbols) in SharedPreferences

### State Management
- [x] `MarketController` — AsyncNotifier, auto-refreshes every 30s
- [x] `CoinDetailProvider` — FutureProvider.family by symbol + interval
- [x] `WatchlistController` — Notifier, persists to SharedPreferences
- [x] `InsightsController` — derives insights from market data (top gainers/losers, volatility, headline)

### Screens (connected to real data)
- [x] **MarketScreen** — coin list, mood card, pull-to-refresh, loading skeletons, stagger animations
- [x] **CoinDetailScreen** — price, chart, interval selector, stats, watchlist toggle
- [x] **InsightsScreen** — mood card, top movers list
- [x] **WatchlistScreen** — persisted list, swipe-to-delete, empty state

---

## What Needs Work / Is Missing

### Screens — Design Gaps (screens exist but don't match design images)

| Screen | Status | What's Missing |
|---|---|---|
| Home (Market) | Partial | No personalized header (avatar, "CRYPTO PULSE", icons); no greeting "Hi, Aman!"; no market alert card; Market Pulse card is basic; coin tiles have no colored left border |
| Coin Detail | Partial | Interval selector is below chart, not above; no card-style price display with sparkline background; no market sentiment progress bar; stats are rows not a 2×2 grid; no big "ADD TO WATCHLIST" button at bottom |
| Insights | Partial | No "INSIGHTS" large heading; no Market Mood card with LIVE badge; no circular volatility gauge; no AI Protocol card; top movers are plain CoinCards |
| Watchlist | Partial | No "WATCHLIST" header; no search bar; no sparkline in tiles; no sentiment badge on tiles; empty state is a plain text widget |
| Profile | Missing | Screen is a `PlaceholderScreen` — avatar, name, settings toggles, sign out not built |

### Screens — Not Created At All

| Screen | Status |
|---|---|
| Onboarding Screen 1 — "Read The Market Before It Moves" | Missing |
| Onboarding Screen 2 — "Live Prices. Clear Signals." | Missing |
| Onboarding Screen 3 — "Follow The Coins That Matter" | Missing |
| Onboarding Screen 4 — "Turn Noise Into Insight" | Missing |
| Auth / Login Screen | Missing |
| Auth / Signup Screen | Missing |

### Features — Not Implemented

- [ ] Onboarding flow (check `onboarding_complete` flag → redirect to onboarding if new user)
- [ ] Sparklines in watchlist tiles (need sparkline provider fetching 20-point klines per coin)
- [ ] Circular volatility gauge widget (custom painter or fl_chart radial)
- [ ] Market Pulse mini-chart in home screen (BTC klines as background)
- [ ] Coin accent colors per symbol (BTC=coral, ETH=purple, SOL=cyan, BNB=yellow)
- [ ] Sentiment strength progress bar in coin detail
- [ ] Market Mood LIVE badge animation
- [ ] Search bar functionality in watchlist
- [ ] Auth (Supabase or Firebase) — not connected at all
- [ ] Cloud watchlist sync — currently local only (SharedPreferences)
- [ ] Profile settings persistence (theme toggle, refresh toggle)

### Router
- [ ] Onboarding route (`/onboarding`) not defined
- [ ] Profile screen is a placeholder `PlaceholderScreen`, not a real screen
- [ ] No onboarding redirect on first launch

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

## Sentiment Logic (implemented)

```
Per coin: >2% = Bullish | <-2% = Bearish | else = Neutral
Market mood: gainers > losers*2 = Bullish | losers > gainers*2 = Bearish | else = Neutral
Volatility: avg |priceChange| < 2% = Low | 2-5% = Moderate | >5% = High
Volatility index: avg |priceChange| * 10 (display scale 0–100)
```

---

## Git Remote

Branch: `main` — connected to GitHub origin.
Push with: `git push origin main`
