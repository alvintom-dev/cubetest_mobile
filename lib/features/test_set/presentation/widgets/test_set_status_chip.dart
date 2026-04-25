import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/test_set.dart';

class TestSetStatusChip extends StatelessWidget {
  const TestSetStatusChip({super.key, required this.status});

  final TestSetStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      TestSetStatus.notStarted =>
        ('Not started', AppColors.closedWash, AppColors.closed),
      TestSetStatus.active =>
        ('Active', AppColors.activeWashed, AppColors.active),
      TestSetStatus.blocked =>
        ('Blocked', AppColors.dangerWash, AppColors.danger),
      TestSetStatus.completed =>
        ('Completed', AppColors.openWash, AppColors.open),
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
