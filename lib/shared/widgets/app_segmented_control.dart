import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppSegmentedOption<T> {
  const AppSegmentedOption({required this.value, required this.label});

  final T value;
  final String label;
}

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.enabled = true,
    this.itemsPerRow = 0,
  });

  final T value;
  final List<AppSegmentedOption<T>> options;
  final ValueChanged<T> onChanged;
  final bool enabled;

  /// When `0`, all options render in a single row.
  /// When `> 0`, options are split into rows of that size.
  final int itemsPerRow;

  @override
  Widget build(BuildContext context) {
    if (itemsPerRow <= 0 || options.length <= itemsPerRow) {
      return Opacity(
        opacity: enabled ? 1 : 0.5,
        child: _buildTrack(context, options, padTo: 0),
      );
    }

    final rows = <List<AppSegmentedOption<T>>>[];
    for (var i = 0; i < options.length; i += itemsPerRow) {
      final end = (i + itemsPerRow).clamp(0, options.length);
      rows.add(options.sublist(i, end));
    }

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            _buildTrack(context, rows[i], padTo: itemsPerRow),
          ],
        ],
      ),
    );
  }

  Widget _buildTrack(
    BuildContext context,
    List<AppSegmentedOption<T>> rowOptions, {
    required int padTo,
  }) {
    final filler = padTo > rowOptions.length ? padTo - rowOptions.length : 0;
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          for (final option in rowOptions)
            Expanded(child: _Pill<T>(
              option: option,
              selected: option.value == value,
              enabled: enabled,
              onTap: () => onChanged(option.value),
            )),
          if (filler > 0) Expanded(flex: filler, child: const SizedBox()),
        ],
      ),
    );
  }
}

class _Pill<T> extends StatelessWidget {
  const _Pill({
    required this.option,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final AppSegmentedOption<T> option;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bg = selected ? AppColors.primary : Colors.transparent;
    final fg = selected ? Colors.white : AppColors.primaryInk;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
