import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppFormFieldCard extends StatelessWidget {
  const AppFormFieldCard({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    this.errorText,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
  });

  final String label;
  final Widget child;
  final bool required;
  final String? errorText;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final content = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(color: AppColors.ink3),
              ),
              if (required) ...[
                const SizedBox(width: 2),
                Text(
                  '*',
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.danger,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          child,
          if (errorText != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              errorText!,
              style: textTheme.labelMedium?.copyWith(color: AppColors.danger),
            ),
          ],
        ],
      ),
    );

    final card = Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.sm,
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: content,
              ),
            ),
    );

    return card;
  }
}
