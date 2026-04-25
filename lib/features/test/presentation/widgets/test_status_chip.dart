import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/test.dart';

class TestStatusChip extends StatelessWidget {
  const TestStatusChip({super.key, required this.status});

  final TestStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      TestStatus.pending =>
        ('Pending', AppColors.closedWash, AppColors.closed),
      TestStatus.passed => ('Passed', AppColors.openWash, AppColors.open),
      TestStatus.failed => ('Failed', AppColors.dangerWash, AppColors.danger),
      TestStatus.skipped => ('Skipped', AppColors.warnWash, AppColors.warn),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
