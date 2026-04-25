import 'package:cubetest_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/cube_result_set.dart';

class CubeResultSetListItem extends StatelessWidget {
  const CubeResultSetListItem({
    super.key,
    required this.cubeResultSet,
    required this.index,
    this.onEdit,
    this.onDelete,
  });

  final CubeResultSet cubeResultSet;
  final int index;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasLoads = cubeResultSet.load1 != null ||
        cubeResultSet.load2 != null ||
        cubeResultSet.load3 != null;
    final hasNotes = cubeResultSet.notes?.trim().isNotEmpty == true;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconChip(),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result #${index + 1}',
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Avg ${cubeResultSet.averageStrength.toStringAsFixed(2)} MPa',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEdit,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.danger,
                ),
                onPressed: onDelete,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _DataRow(
            label: 'Strengths',
            value:
                '${_fmt(cubeResultSet.strength1)} / ${_fmt(cubeResultSet.strength2)} / ${_fmt(cubeResultSet.strength3)} MPa',
          ),
          if (hasLoads) ...[
            const SizedBox(height: AppSpacing.xs),
            _DataRow(
              label: 'Loads',
              value:
                  '${_fmtOptional(cubeResultSet.load1)} / ${_fmtOptional(cubeResultSet.load2)} / ${_fmtOptional(cubeResultSet.load3)} kN',
            ),
          ],
          if (hasNotes) ...[
            const SizedBox(height: AppSpacing.xs),
            _DataRow(
              label: 'Notes',
              value: cubeResultSet.notes!.trim(),
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(double value) => value.toStringAsFixed(2);
  String _fmtOptional(double? value) =>
      value == null ? '—' : value.toStringAsFixed(2);
}

class _IconChip extends StatelessWidget {
  const _IconChip();

  @override
  Widget build(BuildContext context) {
    final tone = kTonePalette[Tone.peach]!;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: tone.bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.grid_view_rounded, color: tone.fg, size: 20),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: textTheme.bodySmall),
        ),
        Expanded(
          child: Text(value, style: textTheme.bodyMedium),
        ),
      ],
    );
  }
}
