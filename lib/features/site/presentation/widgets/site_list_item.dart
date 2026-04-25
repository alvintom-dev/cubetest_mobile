import 'package:cubetest_mobile/core/formatters/date_formatter.dart';
import 'package:cubetest_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/site.dart';
import 'site_status_chip.dart';

class SiteListItem extends StatelessWidget {
  const SiteListItem({
    super.key,
    required this.site,
    this.onTap,
    this.trailing,
  });

  final Site site;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final subtitle = site.location?.trim().isNotEmpty == true
        ? '${site.testSets} test sets · ${site.location!.trim()}'
        : '${site.testSets} test sets';

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
                        site.name,
                        style: textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SiteStatusChip(status: site.status),
                          const Spacer(),
                          if (trailing != null)
                            trailing!
                          else
                            Text(
                              'Updated ${siteTimeAgo(site.updatedAt)}',
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

String siteTimeAgo(DateTime date) {
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
