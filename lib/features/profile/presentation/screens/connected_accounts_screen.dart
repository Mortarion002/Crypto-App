import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/features/profile/presentation/widgets/settings_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ConnectedAccountsScreen extends StatelessWidget {
  const ConnectedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsDetailScaffold(
      title: 'Connected Accounts',
      children: [
        SettingsInfoCard(
          icon: LucideIcons.link,
          iconColor: AppColors.cyanHighlight,
          title: 'Portfolio sync preview',
          body:
              'Connect read-only exchanges and wallets to import balances, trades, and allocation data. This screen uses sample accounts only.',
          badge: 'DUMMY',
        ),
        SizedBox(height: 24),
        SettingsSectionLabel(label: 'EXCHANGES', trailing: '2 connected'),
        SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.server,
              iconColor: AppColors.yellow,
              title: 'Binance',
              subtitle: 'Read-only API - balances, fills, open orders',
              trailing: SettingsPill(label: 'LIVE', color: AppColors.mint),
            ),
            SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.layoutGrid,
              iconColor: AppColors.deepPurple,
              title: 'Coinbase',
              subtitle: 'OAuth sync - last updated 14 min ago',
              trailing: SettingsPill(
                label: 'SYNCED',
                color: AppColors.deepPurple,
              ),
            ),
            SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.plus,
              iconColor: AppColors.cyanHighlight,
              title: 'Add Exchange',
              subtitle: 'Kraken, OKX, Bybit, Robinhood and more',
              trailing: SettingsPill(
                label: 'CONNECT',
                color: AppColors.cyanHighlight,
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        SettingsSectionLabel(label: 'WALLETS', trailing: '2 tracked'),
        SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.layers,
              iconColor: AppColors.vibrantCoral,
              title: 'MetaMask',
              subtitle: 'Ethereum, Base, Polygon - read-only address',
              trailing: SettingsPill(
                label: '3 CHAINS',
                color: AppColors.vibrantCoral,
              ),
            ),
            SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.shieldCheck,
              iconColor: AppColors.mint,
              title: 'Ledger',
              subtitle: 'Cold wallet watch mode - BTC and ETH',
              trailing: SettingsPill(label: 'WATCH', color: AppColors.mint),
            ),
            SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.plus,
              iconColor: AppColors.cyanHighlight,
              title: 'Add Wallet',
              subtitle: 'Paste a public address or scan a QR code',
              trailing: SettingsPill(
                label: 'ADD',
                color: AppColors.cyanHighlight,
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        SettingsSectionLabel(label: 'PERMISSIONS'),
        SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.check,
              iconColor: AppColors.mint,
              title: 'Read-only imports',
              subtitle: 'Crypto Pulse never requests withdrawal permission',
            ),
            SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.refreshCw,
              iconColor: AppColors.deepPurple,
              title: 'Auto-sync cadence',
              subtitle: 'Every 15 minutes while the app is active',
            ),
          ],
        ),
      ],
    );
  }
}
