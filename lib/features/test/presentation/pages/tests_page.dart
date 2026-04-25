import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di.dart';
import '../../../../core/route/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/test.dart';
import '../blocs/tests_cubit/tests_cubit.dart';
import '../widgets/test_list_item.dart';

enum _Filter { all, pending, passed, failed, skipped }

class TestsPage extends StatelessWidget {
  const TestsPage({
    super.key,
    required this.siteId,
    required this.testSetId,
    this.concretingDate,
  });

  final String siteId;
  final String testSetId;
  final DateTime? concretingDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TestsCubit>(
      create: (_) => getIt<TestsCubit>()..fetch(testSetId),
      child: _TestsView(
        siteId: siteId,
        testSetId: testSetId,
        concretingDate: concretingDate,
      ),
    );
  }
}

class _TestsView extends StatefulWidget {
  const _TestsView({
    required this.siteId,
    required this.testSetId,
    required this.concretingDate,
  });

  final String siteId;
  final String testSetId;
  final DateTime? concretingDate;

  @override
  State<_TestsView> createState() => _TestsViewState();
}

class _TestsViewState extends State<_TestsView> {
  String _query = '';
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tests')),
      body: BlocBuilder<TestsCubit, TestsState>(
        builder: (context, state) {
          if (state is TestsInitial || state is TestsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TestsError) {
            return _ErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<TestsCubit>().fetch(widget.testSetId),
            );
          }

          final items = state is TestsLoadedData ? state.items : const <Test>[];
          final counts = _counts(items);
          final filtered = _apply(items);

          return RefreshIndicator(
            onRefresh: () =>
                context.read<TestsCubit>().fetch(widget.testSetId),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    child: _SearchField(
                      onChanged: (q) => setState(() => _query = q),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: _FilterChipsRow(
                      selected: _filter,
                      counts: counts,
                      onSelected: (f) => setState(() => _filter = f),
                    ),
                  ),
                ),
                if (state is TestsLoadedNoData)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyView(),
                  )
                else if (filtered.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _NoMatchesView(),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      child: _SectionHeader(count: filtered.length),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.xl,
                    ),
                    sliver: SliverList.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return TestListItem(
                          test: item,
                          onTap: () async {
                            await context.pushNamed(
                              AppRoutes.testDetail,
                              pathParameters: {
                                'id': widget.siteId,
                                'testSetId': widget.testSetId,
                                'testId': item.id,
                              },
                            );
                            if (context.mounted) {
                              await context
                                  .read<TestsCubit>()
                                  .fetch(widget.testSetId);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (innerContext) => FloatingActionButton(
          onPressed: () async {
            await innerContext.pushNamed(
              AppRoutes.testCreate,
              pathParameters: {
                'id': widget.siteId,
                'testSetId': widget.testSetId,
              },
              extra: widget.concretingDate,
            );
            if (innerContext.mounted) {
              await innerContext.read<TestsCubit>().fetch(widget.testSetId);
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  _FilterCounts _counts(List<Test> items) {
    var pending = 0;
    var passed = 0;
    var failed = 0;
    var skipped = 0;
    for (final item in items) {
      switch (item.status) {
        case TestStatus.pending:
          pending++;
          break;
        case TestStatus.passed:
          passed++;
          break;
        case TestStatus.failed:
          failed++;
          break;
        case TestStatus.skipped:
          skipped++;
          break;
      }
    }
    return _FilterCounts(
      all: items.length,
      pending: pending,
      passed: passed,
      failed: failed,
      skipped: skipped,
    );
  }

  List<Test> _apply(List<Test> items) {
    final q = _query.trim().toLowerCase();
    return items.where((item) {
      final matchesFilter = switch (_filter) {
        _Filter.all => true,
        _Filter.pending => item.status == TestStatus.pending,
        _Filter.passed => item.status == TestStatus.passed,
        _Filter.failed => item.status == TestStatus.failed,
        _Filter.skipped => item.status == TestStatus.skipped,
      };
      if (!matchesFilter) return false;
      if (q.isEmpty) return true;
      final label = _typeLabel(item.type).toLowerCase();
      return label.contains(q);
    }).toList();
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
}

class _FilterCounts {
  const _FilterCounts({
    required this.all,
    required this.pending,
    required this.passed,
    required this.failed,
    required this.skipped,
  });

  final int all;
  final int pending;
  final int passed;
  final int failed;
  final int skipped;
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search tests…',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.ink3,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({
    required this.selected,
    required this.counts,
    required this.onSelected,
  });

  final _Filter selected;
  final _FilterCounts counts;
  final ValueChanged<_Filter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            count: counts.all,
            isSelected: selected == _Filter.all,
            onTap: () => onSelected(_Filter.all),
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'Pending',
            count: counts.pending,
            isSelected: selected == _Filter.pending,
            onTap: () => onSelected(_Filter.pending),
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'Passed',
            count: counts.passed,
            isSelected: selected == _Filter.passed,
            onTap: () => onSelected(_Filter.passed),
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'Failed',
            count: counts.failed,
            isSelected: selected == _Filter.failed,
            onTap: () => onSelected(_Filter.failed),
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'Skipped',
            count: counts.skipped,
            isSelected: selected == _Filter.skipped,
            onTap: () => onSelected(_Filter.skipped),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? AppColors.primary : AppColors.primary50;
    final fg = isSelected ? Colors.white : AppColors.primaryInk;
    final countBg = isSelected
        ? Colors.white.withValues(alpha: 0.22)
        : AppColors.primary100;
    final countFg = isSelected ? Colors.white : AppColors.primaryInk;

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 1,
                ),
                decoration: BoxDecoration(
                  color: countBg,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: countFg,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'All Tests',
          style: Theme.of(context).textTheme.titleLarge,
        ),
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
            '$count',
            style: const TextStyle(
              color: AppColors.primaryInk,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 56, color: AppColors.ink4),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No tests yet. Tap + to create.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _NoMatchesView extends StatelessWidget {
  const _NoMatchesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: AppColors.ink4),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No tests match your search.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
            const SizedBox(height: AppSpacing.sm),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
