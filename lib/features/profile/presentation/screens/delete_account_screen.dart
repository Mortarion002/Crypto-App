import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/features/profile/presentation/widgets/settings_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _watchlist = false;
  bool _profile = false;
  bool _alerts = false;
  final _controller = TextEditingController();

  bool get _ready =>
      _watchlist && _profile && _alerts && _controller.text.trim() == 'DELETE';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsDetailScaffold(
      title: 'Delete Account',
      children: [
        const SettingsInfoCard(
          icon: LucideIcons.triangleAlert,
          iconColor: AppColors.vibrantCoral,
          title: 'Deletion preview only',
          body:
              'This screen demonstrates the destructive-account flow. The button below never deletes Supabase auth users or app data.',
          badge: 'SAFE',
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'WHAT WOULD BE REMOVED'),
        SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.star,
              iconColor: AppColors.yellow,
              title: 'Watchlist items',
              subtitle: 'Saved symbols and cloud sync rows',
              trailing: Checkbox(
                value: _watchlist,
                onChanged: (v) => setState(() => _watchlist = v ?? false),
              ),
            ),
            const SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.user,
              iconColor: AppColors.cyanHighlight,
              title: 'Profile metadata',
              subtitle: 'Display name, email profile row, preferences',
              trailing: Checkbox(
                value: _profile,
                onChanged: (v) => setState(() => _profile = v ?? false),
              ),
            ),
            const SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.bell,
              iconColor: AppColors.deepPurple,
              title: 'Alert settings',
              subtitle: 'Notification categories and digest setup',
              trailing: Checkbox(
                value: _alerts,
                onChanged: (v) => setState(() => _alerts = v ?? false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'CONFIRMATION'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.canvasLevel1,
            borderRadius: AppRadius.mdRadius,
          ),
          child: TextField(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: 'Type DELETE',
              hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _ready
                  ? AppColors.vibrantCoral
                  : AppColors.surfaceContainerHigh,
              foregroundColor: _ready
                  ? Colors.white
                  : AppColors.onSurfaceVariant,
            ),
            onPressed: _ready ? _showPreviewDialog : null,
            icon: const Icon(LucideIcons.trash2, size: 18),
            label: const Text('Preview Delete Request'),
          ),
        ),
      ],
    );
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.canvasLevel1,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        title: const Text(
          'No data deleted',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'This is a dummy flow. A production build would call a verified account deletion endpoint after re-authentication.',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
