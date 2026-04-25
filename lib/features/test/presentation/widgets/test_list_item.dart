import 'package:cubetest_mobile/core/formatters/date_formatter.dart';
import 'package:cubetest_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/test.dart';
import 'test_status_chip.dart';

class TestListItem extends StatelessWidget {
  const TestListItem({
    super.key,
    required this.test,
    this.onTap,
  });

  final Test test;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final overdue = test.isOverdue(now);

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
                _TypeChip(type: test.type),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _typeLabel(test.type),
                        style: textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        'Due ${test.dueDate.toReadable()}',
                        style: textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TestStatusChip(status: test.status),
                          if (overdue) ...[
                            const SizedBox(width: AppSpacing.sm),
                            const _OverdueChip(),
                          ],
                          const Spacer(),
                          Text(
                            _relativeDueText(test, now),
                            style: textTheme.bodySmall?.copyWith(
                              color: overdue
                                  ? AppColors.danger
                                  : AppColors.ink3,
                            ),
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

  String _typeLabel(TestType type) {
    switch (type) {
      case TestType.day7:
        return '7-day test';
      case TestType.day14:
        return '14-day test';
      case TestType.day28:
        return '28-day test';
    }
  }

  String _relativeDueText(Test test, DateTime now) {
    if (test.isCompleted) {
      return test.completedAt != null
          ? 'Done ${test.completedAt!.toReadable()}'
          : 'Done';
    }
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(test.dueDate.year, test.dueDate.month, test.dueDate.day);
    final diff = due.difference(today).inDays;
    if (diff < 0) return '${-diff}d overdue';
    if (diff == 0) return 'due today';
    if (diff == 1) return 'due tomorrow';
    if (diff < 7) return 'in ${diff}d';
    if (diff < 28) return 'in ${(diff / 7).floor()}w';
    return 'due ${test.dueDate.toShort()}';
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final TestType type;

  @override
  Widget build(BuildContext context) {
    final tone = kTonePalette[_toneFor(type)]!;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: tone.bg,
        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.science_rounded, color: tone.fg, size: 24),
    );
  }

  Tone _toneFor(TestType type) {
    switch (type) {
      case TestType.day7:
        return Tone.peach;
      case TestType.day14:
        return Tone.sky;
      case TestType.day28:
        return Tone.mint;
    }
  }
}

class _OverdueChip extends StatelessWidget {
  const _OverdueChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.dangerWash,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: const Text(
        'Overdue',
        style: TextStyle(
          color: AppColors.danger,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
