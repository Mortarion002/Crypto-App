import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/features/profile/presentation/widgets/settings_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometricLock = true;
  bool _twoFactor = false;
  bool _loginAlerts = true;

  @override
  Widget build(BuildContext context) {
    return SettingsDetailScaffold(
      title: 'Security',
      children: [
        const SettingsInfoCard(
          icon: LucideIcons.shieldCheck,
          iconColor: AppColors.mint,
          title: 'Security score: 82',
          body:
              'Your account is protected with Supabase authentication, login alerts, and local device controls. Add 2FA to complete the checklist.',
          badge: 'STRONG',
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'ACCESS CONTROLS'),
        SettingsGroupCard(
          children: [
            const SettingsRow(
              icon: LucideIcons.keyRound,
              iconColor: AppColors.yellow,
              title: 'Password',
              subtitle: 'Last changed 18 days ago',
              trailing: SettingsPill(label: 'UPDATE', color: AppColors.yellow),
            ),
            const SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.smartphone,
              iconColor: AppColors.cyanHighlight,
              title: 'Device Lock',
              subtitle: 'Require Face ID, fingerprint, or PIN on launch',
              trailing: Switch(
                value: _biometricLock,
                onChanged: (v) => setState(() => _biometricLock = v),
                activeTrackColor: AppColors.deepPurple,
                activeThumbColor: Colors.white,
              ),
            ),
            const SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.shieldCheck,
              iconColor: AppColors.deepPurple,
              title: 'Two-Factor Authentication',
              subtitle: _twoFactor
                  ? 'Authenticator app connected'
                  : 'Authenticator app not connected',
              trailing: Switch(
                value: _twoFactor,
                onChanged: (v) => setState(() => _twoFactor = v),
                activeTrackColor: AppColors.deepPurple,
                activeThumbColor: Colors.white,
              ),
            ),
            const SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.bell,
              iconColor: AppColors.vibrantCoral,
              title: 'Login Alerts',
              subtitle: 'Notify me when a new device signs in',
              trailing: Switch(
                value: _loginAlerts,
                onChanged: (v) => setState(() => _loginAlerts = v),
                activeTrackColor: AppColors.deepPurple,
                activeThumbColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(
          label: 'ACTIVE SESSIONS',
          trailing: '3 devices',
        ),
        const SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.smartphone,
              iconColor: AppColors.cyanHighlight,
              title: 'Pixel 8 Pro',
              subtitle: 'Current device - Kolkata, India',
              trailing: SettingsPill(label: 'NOW', color: AppColors.mint),
            ),
            SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.layoutDashboard,
              iconColor: AppColors.deepPurple,
              title: 'Chrome on Windows',
              subtitle: 'Last active 2 hours ago',
              trailing: SettingsPill(
                label: 'TRUSTED',
                color: AppColors.deepPurple,
              ),
            ),
            SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.smartphone,
              iconColor: AppColors.onSurfaceVariant,
              title: 'iPhone 15',
              subtitle: 'Last active yesterday',
              trailing: SettingsPill(label: 'REVIEW', color: AppColors.yellow),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.canvasLevel1,
            borderRadius: AppRadius.mdRadius,
          ),
          child: Text(
            'Dummy screen: security actions preview the intended UX and do not change your Supabase account.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
