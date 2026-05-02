import 'package:flutter/material.dart';
import 'package:crypto_pulse/core/theme/app_colors.dart';
import 'package:crypto_pulse/core/theme/app_radius.dart';

class ChartIntervalSelector extends StatelessWidget {
  final String selectedInterval;
  final ValueChanged<String> onIntervalSelected;

  const ChartIntervalSelector({
    super.key,
    required this.selectedInterval,
    required this.onIntervalSelected,
  });

  @override
  Widget build(BuildContext context) {
    const intervals = ['1h', '4h', '1d', '1w'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: intervals.map((interval) {
        final isSelected = selectedInterval == interval;
        return GestureDetector(
          onTap: () => onIntervalSelected(interval),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.onSurface : Colors.transparent,
              borderRadius: AppRadius.fullRadius,
            ),
            child: Text(
              interval.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? AppColors.surface : AppColors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
