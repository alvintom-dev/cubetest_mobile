import 'package:cubetest_mobile/core/formatters/date_formatter.dart';
import 'package:cubetest_mobile/core/ports/test_set_progress.dart';
import 'package:cubetest_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/test_set.dart';

class TestSetListItem extends StatelessWidget {
  const TestSetListItem({
    super.key,
    required this.testSet,
    this.progress,
    this.onTap,
    this.trailing,
  });

  final TestSet testSet;
  final TestSetProgress? progress;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final title = testSet.name?.trim().isNotEmpty == true
        ? testSet.name!
        : '(Unnamed)';
    final progressDisplay = (progress ?? TestSetProgress.empty).display;
    final date = testSet.appointDate.toReadable();
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: AppShadows.sm,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _IconChip(),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '$progressDisplay tests · $date',
                        style: textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _StatusDotChip(status: testSet.status),
                          const Spacer(),
                          Text(
                            'Updated ${_timeAgo(testSet.updatedAt)}',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip();

  @override
  Widget build(BuildContext context) {
    final tone = kTonePalette[Tone.lilac]!;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: tone.bg,
        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.apartment_rounded, color: tone.fg, size: 24),
    );
  }
}

class _StatusDotChip extends StatelessWidget {
  const _StatusDotChip({required this.status});

  final TestSetStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      TestSetStatus.notStarted =>
        ('Not Started', AppColors.closedWash, AppColors.closed),
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

String _timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.isNegative) return 'just now';
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';

  final today = DateTime(now.year, now.month, now.day);
  final that = DateTime(date.year, date.month, date.day);
  final dayDiff = today.difference(that).inDays;

  if (dayDiff == 1) return 'yesterday';
  if (dayDiff < 7) return '${dayDiff}d ago';
  if (dayDiff < 28) return '${(dayDiff / 7).floor()}w ago';
  return date.toShort();
}
