import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/site.dart';

class SiteStatusChip extends StatelessWidget {
  const SiteStatusChip({super.key, required this.status});

  final SiteStatus status;

  @override
  Widget build(BuildContext context) {
    final isOpen = status == SiteStatus.open;
    final label = isOpen ? 'Open' : 'Closed';
    final bg = isOpen ? AppColors.openWash : AppColors.closedWash;
    final fg = isOpen ? AppColors.open : AppColors.closed;

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
