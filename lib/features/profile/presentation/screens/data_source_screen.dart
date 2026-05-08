import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/features/profile/presentation/widgets/settings_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DataSourceScreen extends StatefulWidget {
  const DataSourceScreen({super.key});

  @override
  State<DataSourceScreen> createState() => _DataSourceScreenState();
}

class _DataSourceScreenState extends State<DataSourceScreen> {
  bool _binance = true;
  bool _coinGecko = false;
  bool _cacheFallback = true;

  @override
  Widget build(BuildContext context) {
    return SettingsDetailScaffold(
      title: 'Data Source',
      children: [
        const SettingsInfoCard(
          icon: LucideIcons.server,
          iconColor: AppColors.cyanHighlight,
          title: 'Binance Public API',
          body:
              'Crypto Pulse currently reads public ticker and candlestick endpoints without requiring an API key.',
          badge: 'LIVE',
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'MARKET FEEDS'),
        SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.activity,
              iconColor: AppColors.mint,
              title: 'Binance spot market',
              subtitle: '24h ticker, klines, price change, high/low',
              trailing: Switch(
                value: _binance,
                onChanged: (v) => setState(() => _binance = v),
                activeTrackColor: AppColors.deepPurple,
                activeThumbColor: Colors.white,
              ),
            ),
            const SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.layoutGrid,
              iconColor: AppColors.deepPurple,
              title: 'CoinGecko metadata',
              subtitle: 'Token categories, logos, community signals',
              trailing: Switch(
                value: _coinGecko,
                onChanged: (v) => setState(() => _coinGecko = v),
                activeTrackColor: AppColors.deepPurple,
                activeThumbColor: Colors.white,
              ),
            ),
            const SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.refreshCw,
              iconColor: AppColors.yellow,
              title: 'Cached fallback',
              subtitle: 'Show last known prices during temporary outages',
              trailing: Switch(
                value: _cacheFallback,
                onChanged: (v) => setState(() => _cacheFallback = v),
                activeTrackColor: AppColors.deepPurple,
                activeThumbColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'HEALTH'),
        const SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.check,
              iconColor: AppColors.mint,
              title: 'Ticker latency',
              subtitle: '342 ms average over the last 20 requests',
              trailing: SettingsPill(label: 'GOOD', color: AppColors.mint),
            ),
            SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.clock,
              iconColor: AppColors.yellow,
              title: 'Refresh cadence',
              subtitle: 'Every 30 seconds while live refresh is enabled',
            ),
          ],
        ),
      ],
    );
  }
}
