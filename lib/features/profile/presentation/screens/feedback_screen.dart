import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';
import 'package:crypto_pulse/features/profile/presentation/widgets/settings_detail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _category = 0;
  int _rating = 4;
  bool _contactMe = true;
  final _controller = TextEditingController();
  final _categories = const ['Bug', 'Idea', 'Data', 'Design'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsDetailScaffold(
      title: 'Send Feedback',
      children: [
        const SettingsInfoCard(
          icon: LucideIcons.messageCircle,
          iconColor: AppColors.deepPurple,
          title: 'Help shape Crypto Pulse',
          body:
              'Share a bug report, feature idea, data issue, or design note. Submissions are simulated in this build.',
          badge: 'PREVIEW',
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'CATEGORY'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.asMap().entries.map((entry) {
            final selected = entry.key == _category;
            return ChoiceChip(
              label: Text(entry.value),
              selected: selected,
              selectedColor: AppColors.deepPurple,
              backgroundColor: AppColors.canvasLevel1,
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
              onSelected: (_) => setState(() => _category = entry.key),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'MESSAGE'),
        Container(
          decoration: BoxDecoration(
            color: AppColors.canvasLevel1,
            borderRadius: AppRadius.mdRadius,
          ),
          child: TextField(
            controller: _controller,
            minLines: 5,
            maxLines: 8,
            style: const TextStyle(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText:
                  'Tell us what happened or what would make the app better...',
              hintStyle: TextStyle(color: AppColors.onSurfaceVariant),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'APP RATING'),
        Row(
          children: List.generate(5, (index) {
            final value = index + 1;
            final active = value <= _rating;
            return IconButton(
              onPressed: () => setState(() => _rating = value),
              icon: Icon(
                LucideIcons.star,
                color: active ? AppColors.yellow : AppColors.onSurfaceVariant,
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.mail,
              iconColor: AppColors.cyanHighlight,
              title: 'Contact me about this',
              subtitle: _contactMe
                  ? 'Allow follow-up by email'
                  : 'Send anonymously',
              trailing: Switch(
                value: _contactMe,
                onChanged: (v) => setState(() => _contactMe = v),
                activeTrackColor: AppColors.deepPurple,
                activeThumbColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showSent,
            icon: const Icon(LucideIcons.check, size: 18),
            label: const Text('Send Feedback'),
          ),
        ),
        const SizedBox(height: 24),
        const SettingsSectionLabel(label: 'ROADMAP SIGNALS'),
        const SettingsGroupCard(
          children: [
            SettingsRow(
              icon: LucideIcons.chartBar,
              iconColor: AppColors.vibrantCoral,
              title: 'Portfolio P&L dashboard',
              subtitle: 'Most requested by early testers',
            ),
            SettingsDivider(),
            SettingsRow(
              icon: LucideIcons.bell,
              iconColor: AppColors.yellow,
              title: 'Custom price alert builder',
              subtitle: 'Planned after notification persistence',
            ),
          ],
        ),
      ],
    );
  }

  void _showSent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Feedback captured in preview mode.'),
      ),
    );
  }
}
