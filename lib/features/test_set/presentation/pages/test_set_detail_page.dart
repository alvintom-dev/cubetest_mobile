import 'package:cubetest_mobile/core/formatters/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di.dart';
import '../../../../core/ports/test_set_progress.dart';
import '../../../../core/route/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/test_set.dart';
import '../blocs/test_set_detail_cubit/test_set_detail_cubit.dart';
import '../widgets/test_set_status_chip.dart';

class TestSetDetailPage extends StatelessWidget {
  const TestSetDetailPage({super.key, required this.testSetId});

  final String testSetId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TestSetDetailCubit>(
      create: (_) => getIt<TestSetDetailCubit>()..load(testSetId),
      child: _DetailView(testSetId: testSetId),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.testSetId});

  final String testSetId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TestSetDetailCubit, TestSetDetailState>(
      listener: (context, state) {
        if (state is TestSetDetailDeleted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test Set'),
          actions: [
            BlocBuilder<TestSetDetailCubit, TestSetDetailState>(
              builder: (context, state) {
                if (state is! TestSetDetailLoaded) {
                  return const SizedBox.shrink();
                }
                final siteId = state.testSet.siteId;
                return Row(
                  children: [
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () async {
                        await context.pushNamed(
                          AppRoutes.testSetEdit,
                          pathParameters: {
                            'id': siteId,
                            'testSetId': testSetId,
                          },
                        );
                        if (context.mounted) {
                          await context
                              .read<TestSetDetailCubit>()
                              .load(testSetId);
                        }
                      },
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () =>
                          _confirmDelete(context, testSetId),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<TestSetDetailCubit, TestSetDetailState>(
          builder: (context, state) {
            if (state is TestSetDetailInitial ||
                state is TestSetDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TestSetDetailError) {
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
            if (state is TestSetDetailLoaded) {
              return _Content(
                testSet: state.testSet,
                progress: state.progress,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this test set?'),
        content: const Text('The test set will be moved to trash.'),
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
    if (confirm == true && context.mounted) {
      await context.read<TestSetDetailCubit>().softDelete(id);
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.testSet, required this.progress});

  final TestSet testSet;
  final TestSetProgress progress;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _HeroCard(testSet: testSet),
        const SizedBox(height: AppSpacing.md),
        if (testSet.description?.trim().isNotEmpty == true) ...[
          _DescriptionCard(text: testSet.description!.trim()),
          const SizedBox(height: AppSpacing.md),
        ],
        _MetaCard(testSet: testSet, progress: progress),
        const SizedBox(height: AppSpacing.md),
        _TestsCard(
          progress: progress,
          onTap: () => context.pushNamed(
            AppRoutes.tests,
            pathParameters: {
              'id': testSet.siteId,
              'testSetId': testSet.id,
            },
            extra: testSet.appointDate,
          ),
        ),
      ],
    );
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
  const _HeroCard({required this.testSet});

  final TestSet testSet;

  @override
  Widget build(BuildContext context) {
    final tone = kTonePalette[Tone.lilac]!;
    final textTheme = Theme.of(context).textTheme;
    final title = testSet.name?.trim().isNotEmpty == true
        ? testSet.name!
        : '(Unnamed)';
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
                Text(title, style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Concreting on ${testSet.appointDate.toReadable()}',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                TestSetStatusChip(status: testSet.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(text, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.testSet, required this.progress});

  final TestSet testSet;
  final TestSetProgress progress;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Details', style: textTheme.labelLarge),
          const SizedBox(height: AppSpacing.md),
          _MetaRow(
            icon: Icons.event_rounded,
            label: 'Concreting',
            value: testSet.appointDate.toReadable(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.speed_rounded,
            label: 'Required strength',
            value: '${testSet.requiredStrength} MPa',
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.task_alt_rounded,
            label: 'Progress',
            value: progress.display,
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.event_available_rounded,
            label: 'Created',
            value: testSet.createdAt.toReadable(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.update_rounded,
            label: 'Last updated',
            value: testSet.updatedAt.toReadable(),
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
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.ink3),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 140,
          child: Text(label, style: textTheme.bodySmall),
        ),
        Expanded(
          child: Text(value, style: textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _TestsCard extends StatelessWidget {
  const _TestsCard({required this.progress, required this.onTap});

  final TestSetProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = kTonePalette[Tone.mint]!;
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
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tone.bg,
                    borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.list_alt_rounded,
                    color: tone.fg,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tests',
                        style: textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '${progress.display} complete',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.ink3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
