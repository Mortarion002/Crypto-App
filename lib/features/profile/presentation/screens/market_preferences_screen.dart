import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/features/profile/presentation/widgets/settings_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum MarketPreferencesMode { currency, chartInterval }

class MarketPreferencesScreen extends StatefulWidget {
  final MarketPreferencesMode initialMode;

  const MarketPreferencesScreen({required this.initialMode, super.key});

  @override
  State<MarketPreferencesScreen> createState() =>
      _MarketPreferencesScreenState();
}

class _MarketPreferencesScreenState extends State<MarketPreferencesScreen> {
  late MarketPreferencesMode _mode = widget.initialMode;
  int _currency = 0;
  int _interval = 2;
  bool _candles = true;
  bool _movingAverage = true;
  bool _volumeBars = true;

  final _currencies = const [
    ('USD', 'US Dollar', r'$64,218.42'),
    ('EUR', 'Euro', 'EUR 59,044.91'),
    ('GBP', 'British Pound', 'GBP 50,946.22'),
    ('INR', 'Indian Rupee', 'Rs 53,51,905.17'),
    ('JPY', 'Japanese Yen', 'JPY 9,928,441'),
    ('BTC', 'Bitcoin Units', '1.000000 BTC'),
  ];

  final _intervals = const [
    ('1H', 'Scalp view', '60 one-minute candles'),
    ('4H', 'Intraday view', '48 five-minute candles'),
    ('1D', 'Daily pulse', '24 hourly candles'),
    ('1W', 'Swing view', '7 daily candles'),
    ('1M', 'Position view', '30 daily candles'),
  ];

  @override
  Widget build(BuildContext context) {
    final isCurrency = _mode == MarketPreferencesMode.currency;

    return SettingsDetailScaffold(
      title: isCurrency ? 'Default Currency' : 'Chart Interval',
      children: [
        Row(
          children: [
            Expanded(
              child: _ModeButton(
                label: 'Currency',
                selected: isCurrency,
                onTap: () =>
                    setState(() => _mode = MarketPreferencesMode.currency),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ModeButton(
                label: 'Charts',
                selected: !isCurrency,
                onTap: () =>
                    setState(() => _mode = MarketPreferencesMode.chartInterval),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (isCurrency) ..._currencyContent() else ..._chartContent(),
      ],
    );
  }

  List<Widget> _currencyContent() {
    final selected = _currencies[_currency];
    return [
      SettingsInfoCard(
        icon: LucideIcons.dollarSign,
        iconColor: AppColors.mint,
        title: 'Default display: ${selected.$1}',
        body:
            'Market cards, detail stats, alerts, and portfolio previews use ${selected.$2} by default.',
        badge: selected.$3,
      ),
      const SizedBox(height: 24),
      const SettingsSectionLabel(label: 'FIAT AND CRYPTO UNITS'),
      SettingsGroupCard(
        children: _currencies.asMap().entries.map((entry) {
          final selected = entry.key == _currency;
          final item = entry.value;
          return Column(
            children: [
              SettingsRow(
                icon: selected ? LucideIcons.check : LucideIcons.dollarSign,
                iconColor: selected
                    ? AppColors.mint
                    : AppColors.onSurfaceVariant,
                title: '${item.$1} - ${item.$2}',
                subtitle: item.$3,
                trailing: selected
                    ? const SettingsPill(
                        label: 'DEFAULT',
                        color: AppColors.mint,
                      )
                    : TextButton(
                        onPressed: () => setState(() => _currency = entry.key),
                        child: const Text('Set'),
                      ),
              ),
              if (entry.key < _currencies.length - 1) const SettingsDivider(),
            ],
          );
        }).toList(),
      ),
    ];
  }

  List<Widget> _chartContent() {
    final selected = _intervals[_interval];
    return [
      SettingsInfoCard(
        icon: LucideIcons.chartBar,
        iconColor: AppColors.vibrantCoral,
        title: 'Default interval: ${selected.$1}',
        body:
            '${selected.$2} is used when opening coin detail charts and market pulse previews.',
        badge: selected.$3,
      ),
      const SizedBox(height: 24),
      const SettingsSectionLabel(label: 'INTERVALS'),
      SettingsGroupCard(
        children: _intervals.asMap().entries.map((entry) {
          final selected = entry.key == _interval;
          final item = entry.value;
          return Column(
            children: [
              SettingsRow(
                icon: selected ? LucideIcons.check : LucideIcons.clock,
                iconColor: selected
                    ? AppColors.mint
                    : AppColors.onSurfaceVariant,
                title: item.$1,
                subtitle: '${item.$2} - ${item.$3}',
                trailing: selected
                    ? const SettingsPill(
                        label: 'DEFAULT',
                        color: AppColors.mint,
                      )
                    : TextButton(
                        onPressed: () => setState(() => _interval = entry.key),
                        child: const Text('Use'),
                      ),
              ),
              if (entry.key < _intervals.length - 1) const SettingsDivider(),
            ],
          );
        }).toList(),
      ),
      const SizedBox(height: 24),
      const SettingsSectionLabel(label: 'CHART LAYERS'),
      SettingsGroupCard(
        children: [
          SettingsRow(
            icon: LucideIcons.activity,
            iconColor: AppColors.yellow,
            title: 'Candlestick Mode',
            subtitle: 'Show OHLC candles instead of a line chart',
            trailing: Switch(
              value: _candles,
              onChanged: (v) => setState(() => _candles = v),
              activeTrackColor: AppColors.deepPurple,
              activeThumbColor: Colors.white,
            ),
          ),
          const SettingsDivider(),
          SettingsRow(
            icon: LucideIcons.trendingUp,
            iconColor: AppColors.deepPurple,
            title: 'Moving Average',
            subtitle: 'Overlay a 20-period trend line',
            trailing: Switch(
              value: _movingAverage,
              onChanged: (v) => setState(() => _movingAverage = v),
              activeTrackColor: AppColors.deepPurple,
              activeThumbColor: Colors.white,
            ),
          ),
          const SettingsDivider(),
          SettingsRow(
            icon: LucideIcons.layoutGrid,
            iconColor: AppColors.cyanHighlight,
            title: 'Volume Bars',
            subtitle: 'Show volume below price movement',
            trailing: Switch(
              value: _volumeBars,
              onChanged: (v) => setState(() => _volumeBars = v),
              activeTrackColor: AppColors.deepPurple,
              activeThumbColor: Colors.white,
            ),
          ),
        ],
      ),
    ];
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.deepPurple : AppColors.canvasLevel1,
          borderRadius: AppRadius.smRadius,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: selected ? Colors.white : AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
