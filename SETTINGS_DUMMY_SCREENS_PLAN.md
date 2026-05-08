# Settings Dummy Screens Plan

## App Understanding

Crypto Pulse is a Flutter/Riverpod crypto market tracker with Supabase auth, Binance public market data, and a dark "Vivid Intelligence" UI. The primary flows are:

- Market dashboard with live 24h ticker data, top movers, and volatility alerts.
- Coin detail pages with interval charts and watchlist actions.
- Insights derived from market data, including mood, volatility, gainers, and losers.
- Watchlist with locally persisted symbols and optional Supabase sync.
- Settings/Profile for account, preferences, data choices, support, and account actions.

## Research Notes

Comparable crypto tracker apps commonly expose settings and feature surfaces for:

- Exchange and wallet connections, often read-only/import focused.
- Security/privacy controls such as device lock, password, sessions, and data handling.
- Multi-currency display preferences and regional formatting.
- Chart and market-data defaults.
- Notifications for price, portfolio, movement, and digest events.
- Feedback/support entry points.

Sources checked:

- Delta by eToro App Store listing: exchange/wallet sync, price alerts, portfolio analytics, multi-currency support, security.
- Crypto Pro: privacy-first local data, FaceID/TouchID lock, exchange API import, widgets, price alerts.
- Coinpanda: exchange/wallet imports, portfolio insights, real-time market tracking.

## Existing Settings Gaps

Settings currently has working Profile, Notifications, Documentation, About, Sign In, Sign Out, Theme status, and Live Data Refresh. The remaining placeholder actions are:

- Security
- Connected Accounts
- Language & Region
- Default Currency
- Chart Interval
- Send Feedback
- Delete Account

## Implementation Map

Create one reusable settings detail pattern and add focused dummy screens under `lib/features/profile/presentation/screens/`:

- `security_settings_screen.dart`
  - Security score card.
  - Password row, biometric lock toggle, 2FA toggle, device/session list, recovery checklist.
- `connected_accounts_screen.dart`
  - Connected exchange/wallet summary.
  - Dummy accounts for Binance, Coinbase, MetaMask, Ledger.
  - Read-only status, sync cadence, permissions, and mock connect actions.
- `language_region_screen.dart`
  - Language, region, timezone, number format, week start, market session labels.
  - Preview card showing how prices/dates render.
- `market_preferences_screen.dart`
  - Supports two modes: default currency and chart interval.
  - Currency options with USD, EUR, GBP, INR, JPY, BTC.
  - Chart intervals with 1H, 4H, 1D, 1W, 1M plus candle style and overlays.
- `feedback_screen.dart`
  - Feedback category selector, rating chips, text field, contact toggle, mock send confirmation.
  - Recent roadmap cards so it feels connected to the app.
- `delete_account_screen.dart`
  - Non-destructive dummy deletion flow with impact checklist and confirmation text.
  - Keep this explicitly simulated so no real user data is removed.

Update `settings_screen.dart` to navigate to these screens instead of showing snackbars.

## UI Direction

- Keep the current dark editorial palette and compact settings row/card rhythm.
- Prefer dense, scannable operational panels over landing-page content.
- Use Lucide icons already present in the app.
- Keep all state local/dummy unless existing preferences already support persistence.
- Avoid real destructive behavior for Delete Account.

## Tests And Verification

- Update settings widget tests to assert placeholder text is gone and one or more new routes/screens open.
- Add focused widget tests for at least the highest-risk screens:
  - Security toggles render and can change.
  - Market preferences can switch interval/currency choices.
  - Delete account remains simulated.
- Run `flutter test`.
- Run `dart format` on changed Dart files.

## Git Checkpoints

1. Commit and push this plan.
2. Commit and push reusable/detail screen implementation after compile passes.
3. Commit and push test updates after `flutter test` passes.
