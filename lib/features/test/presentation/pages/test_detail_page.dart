import 'package:cubetest_mobile/core/formatters/date_formatter.dart';
import 'package:cubetest_mobile/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di.dart';
import '../../domain/entities/cube_result_set.dart';
import '../../domain/entities/test.dart';
import '../../domain/usecases/create_cube_result_set_usecase.dart';
import '../../domain/usecases/update_cube_result_set_usecase.dart';
import '../../domain/usecases/update_test_status_usecase.dart';
import '../blocs/test_detail_cubit/test_detail_cubit.dart';
import '../widgets/cube_result_set_form.dart';
import '../widgets/cube_result_set_list_item.dart';
import '../widgets/test_status_chip.dart';

class TestDetailPage extends StatelessWidget {
  const TestDetailPage({super.key, required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TestDetailCubit>(
      create: (_) => getIt<TestDetailCubit>()..load(testId),
      child: _DetailView(testId: testId),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TestDetailCubit, TestDetailState>(
      listener: (context, state) {
        if (state is TestDetailDeleted) {
          context.pop();
        } else if (state is TestDetailActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test'),
          actions: [
            BlocBuilder<TestDetailCubit, TestDetailState>(
              builder: (context, state) {
                if (state is! TestDetailLoaded) return const SizedBox.shrink();
                return IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDeleteTest(context),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<TestDetailCubit, TestDetailState>(
          builder: (context, state) {
            if (state is TestDetailInitial || state is TestDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TestDetailError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppColors.danger,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(state.message, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }
            if (state is TestDetailLoaded) {
              return _Content(
                test: state.test,
                cubeResultSets: state.cubeResultSets,
                onEditResult: (item) =>
                    _showResultForm(context, initial: item),
              );
            }
            if (state is TestDetailActionError) {
              return _Content(
                test: state.test,
                cubeResultSets: state.cubeResultSets,
                onEditResult: (item) =>
                    _showResultForm(context, initial: item),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton:
            BlocBuilder<TestDetailCubit, TestDetailState>(
          builder: (context, state) {
            if (state is! TestDetailLoaded) return const SizedBox.shrink();
            return FloatingActionButton(
              onPressed: () => _showResultForm(context),
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteTest(BuildContext context) async {
    final cubit = context.read<TestDetailCubit>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this test?'),
        content: const Text('The test and its results will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await cubit.deleteTest();
    }
  }

  Future<void> _showResultForm(
    BuildContext context, {
    CubeResultSet? initial,
  }) async {
    final cubit = context.read<TestDetailCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgWash,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom +
                AppSpacing.lg,
          ),
          child: SingleChildScrollView(
            child: CubeResultSetForm(
              initial: initial,
              submitting: false,
              onSubmit: (data) {
                Navigator.of(sheetContext).pop();
                if (initial == null) {
                  cubit.addCubeResultSet(CreateCubeResultSetUsecaseParam(
                    testId: testId,
                    load1: data.load1,
                    load2: data.load2,
                    load3: data.load3,
                    strength1: data.strength1,
                    strength2: data.strength2,
                    strength3: data.strength3,
                    notes: data.notes,
                  ));
                } else {
                  cubit.updateCubeResultSet(UpdateCubeResultSetUsecaseParam(
                    id: initial.id,
                    load1: data.load1,
                    load2: data.load2,
                    load3: data.load3,
                    strength1: data.strength1,
                    strength2: data.strength2,
                    strength3: data.strength3,
                    notes: data.notes,
                  ));
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.test,
    required this.cubeResultSets,
    required this.onEditResult,
  });

  final Test test;
  final List<CubeResultSet> cubeResultSets;
  final void Function(CubeResultSet item) onEditResult;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _HeroCard(test: test),
        const SizedBox(height: AppSpacing.md),
        _MetaCard(test: test),
        const SizedBox(height: AppSpacing.md),
        _StatusCard(test: test, resultCount: cubeResultSets.length),
        const SizedBox(height: AppSpacing.md),
        _ResultsSection(
          items: cubeResultSets,
          onEdit: onEditResult,
          onDelete: (id) => _confirmDeleteResult(context, id),
        ),
      ],
    );
  }

  Future<void> _confirmDeleteResult(
    BuildContext context,
    String id,
  ) async {
    final cubit = context.read<TestDetailCubit>();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this result?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await cubit.deleteCubeResultSet(id);
    }
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.test});

  final Test test;

  @override
  Widget build(BuildContext context) {
    final tone = kTonePalette[_toneFor(test.type)]!;
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: tone.bg,
              borderRadius: BorderRadius.circular(AppRadius.sm + 4),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.science_rounded, color: tone.fg, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_typeLabel(test.type), style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Due ${test.dueDate.toReadable()}',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                TestStatusChip(status: test.status),
              ],
            ),
          ),
        ],
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

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.test});

  final Test test;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final overdue = test.isOverdue(now);
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: textTheme.labelLarge),
          const SizedBox(height: AppSpacing.md),
          _MetaRow(
            icon: Icons.event_rounded,
            label: 'Due date',
            value: test.dueDate.toReadable(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.flag_rounded,
            label: 'Overdue',
            value: overdue ? 'Yes' : 'No',
            valueColor: overdue ? AppColors.danger : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.check_circle_outline_rounded,
            label: 'Completed at',
            value: test.completedAt == null
                ? '—'
                : test.completedAt!.toReadable(),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.ink3),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 120,
          child: Text(label, style: textTheme.bodySmall),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(color: valueColor),
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.test, required this.resultCount});

  final Test test;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Update status', style: textTheme.labelLarge),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final option in TestStatus.values)
                _StatusOption(
                  status: option,
                  isSelected: test.status == option,
                  onTap: () => _apply(context, option),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _apply(BuildContext context, TestStatus status) {
    if (status == test.status) return;
    if ((status == TestStatus.passed || status == TestStatus.failed) &&
        resultCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Cannot mark as passed/failed without at least one cube result set'),
        ),
      );
      return;
    }
    context.read<TestDetailCubit>().updateStatus(
          UpdateTestStatusUsecaseParam(id: test.id, status: status),
        );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  final TestStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (label, _, _) = _styleFor(status);
    final bg = isSelected ? AppColors.primary : AppColors.primary50;
    final fg = isSelected ? Colors.white : AppColors.primaryInk;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm + 2,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  (String, Color, Color) _styleFor(TestStatus status) {
    switch (status) {
      case TestStatus.pending:
        return ('Pending', AppColors.closedWash, AppColors.closed);
      case TestStatus.passed:
        return ('Passed', AppColors.openWash, AppColors.open);
      case TestStatus.failed:
        return ('Failed', AppColors.dangerWash, AppColors.danger);
      case TestStatus.skipped:
        return ('Skipped', AppColors.warnWash, AppColors.warn);
    }
  }
}

class _ResultsSection extends StatelessWidget {
  const _ResultsSection({
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CubeResultSet> items;
  final void Function(CubeResultSet item) onEdit;
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Text('Results', style: textTheme.titleLarge),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${items.length}',
                  style: const TextStyle(
                    color: AppColors.primaryInk,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (items.isEmpty)
          _Card(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.grid_view_rounded,
                    size: 40,
                    color: AppColors.ink4,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No results yet. Tap + to add.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          )
        else
          for (var i = 0; i < items.length; i++) ...[
            CubeResultSetListItem(
              cubeResultSet: items[i],
              index: i,
              onEdit: () => onEdit(items[i]),
              onDelete: () => onDelete(items[i].id),
            ),
            if (i < items.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
      ],
    );
  }
}
