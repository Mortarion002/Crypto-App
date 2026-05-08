import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/features/profile/presentation/widgets/settings_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LanguageRegionScreen extends StatefulWidget {
  const LanguageRegionScreen({super.key});

  @override
  State<LanguageRegionScreen> createState() => _LanguageRegionScreenState();
}

class _LanguageRegionScreenState extends State<LanguageRegionScreen> {
  int _language = 0;
  int _region = 0;
  bool _useLocalTime = true;

  final _languages = ['English (US)', 'Hindi', 'Spanish', 'Japanese'];
  final _regions = ['United States', 'India', 'Europe', 'Japan'];

  @override
  Widget build(BuildContext context) {
    return SettingsDetailScaffold(
      title: 'Language & Region',
      children: [
        SettingsInfoCard(
          icon: LucideIcons.languages,
          iconColor: AppColors.cyanHighlight,
          title: _languages[_language],
          body:
              'Regional choices control date formats, decimal separators, market session labels, and default fiat suggestions.',
          badge: _regions[_region].toUpperCase(),
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'LANGUAGE'),
        SettingsGroupCard(
          children: _languages.asMap().entries.map((entry) {
            final selected = entry.key == _language;
            return Column(
              children: [
                SettingsRow(
                  icon: selected ? LucideIcons.check : LucideIcons.languages,
                  iconColor: selected
                      ? AppColors.mint
                      : AppColors.onSurfaceVariant,
                  title: entry.value,
                  subtitle: selected
                      ? 'Active app language'
                      : 'Available dummy translation',
                  trailing: selected
                      ? const SettingsPill(
                          label: 'ACTIVE',
                          color: AppColors.mint,
                        )
                      : TextButton(
                          onPressed: () =>
                              setState(() => _language = entry.key),
                          child: const Text('Use'),
                        ),
                ),
                if (entry.key < _languages.length - 1) const SettingsDivider(),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'REGION FORMAT'),
        SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.layoutGrid,
              iconColor: AppColors.deepPurple,
              title: 'Region',
              subtitle: _regions[_region],
              trailing: DropdownButton<int>(
                value: _region,
                dropdownColor: AppColors.canvasLevel1,
                underline: const SizedBox.shrink(),
                items: _regions
                    .asMap()
                    .entries
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _region = value ?? _region),
              ),
            ),
            const SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.clock,
              iconColor: AppColors.yellow,
              title: 'Use local timezone',
              subtitle: _useLocalTime
                  ? 'Asia/Kolkata in chart labels'
                  : 'UTC market time',
              trailing: Switch(
                value: _useLocalTime,
                onChanged: (v) => setState(() => _useLocalTime = v),
                activeTrackColor: AppColors.deepPurple,
                activeThumbColor: Colors.white,
              ),
            ),
            const SettingsDivider(),
            const SettingsRow(
              icon: LucideIcons.calendar,
              iconColor: AppColors.vibrantCoral,
              title: 'Week starts on',
              subtitle: 'Monday',
              trailing: SettingsPill(
                label: 'ISO',
                color: AppColors.vibrantCoral,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'PREVIEW'),
        const SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.dollarSign,
              iconColor: AppColors.mint,
              title: '\$64,218.42',
              subtitle: 'BTC price format',
            ),
            SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.clock,
              iconColor: AppColors.yellow,
              title: '08 May 2026, 10:30 PM',
              subtitle: 'Candle close time preview',
            ),
          ],
        ),
      ],
    );
  }
}
