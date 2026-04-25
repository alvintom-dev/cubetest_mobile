import 'package:cubetest_mobile/core/formatters/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di.dart';
import '../../../../core/route/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/site.dart';
import '../blocs/site_detail_cubit/site_detail_cubit.dart';
import '../widgets/site_list_item.dart';
import '../widgets/site_status_chip.dart';

class SiteDetailPage extends StatelessWidget {
  const SiteDetailPage({super.key, required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SiteDetailCubit>(
      create: (_) => getIt<SiteDetailCubit>()..load(siteId),
      child: _DetailView(siteId: siteId),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.siteId});

  final String siteId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SiteDetailCubit, SiteDetailState>(
      listener: (context, state) {
        if (state is SiteDetailDeleted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Site'),
          actions: [
            BlocBuilder<SiteDetailCubit, SiteDetailState>(
              builder: (context, state) {
                if (state is! SiteDetailLoaded) return const SizedBox.shrink();
                return Row(
                  children: [
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () async {
                        await context.pushNamed(
                          AppRoutes.siteEdit,
                          pathParameters: {'id': siteId},
                        );
                        if (context.mounted) {
                          await context.read<SiteDetailCubit>().load(siteId);
                        }
                      },
                    ),
                    IconButton(
                      tooltip: 'Archive',
                      icon: const Icon(Icons.archive_outlined),
                      onPressed: () => _confirmArchive(context, siteId),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<SiteDetailCubit, SiteDetailState>(
          builder: (context, state) {
            if (state is SiteDetailInitial || state is SiteDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SiteDetailError) {
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
            if (state is SiteDetailLoaded) {
              return _SiteDetailContent(site: state.site, siteId: siteId);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _confirmArchive(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Archive this site?'),
        content: const Text(
            'The site will be moved to archive. You can permanently delete it from there.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await context.read<SiteDetailCubit>().softDelete(id);
    }
  }
}

class _SiteDetailContent extends StatelessWidget {
  const _SiteDetailContent({required this.site, required this.siteId});

  final Site site;
  final String siteId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _HeroCard(site: site),
        const SizedBox(height: AppSpacing.md),
        if (site.description?.trim().isNotEmpty == true) ...[
          _DescriptionCard(text: site.description!.trim()),
          const SizedBox(height: AppSpacing.md),
        ],
        _MetaCard(site: site),
        const SizedBox(height: AppSpacing.md),
        _TestSetsCard(
          testSetCount: site.testSets,
          onTap: () async {
            await context.pushNamed(
              AppRoutes.testSets,
              pathParameters: {'id': siteId},
            );
            if (context.mounted) {
              await context.read<SiteDetailCubit>().load(siteId);
            }
          },
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
  const _HeroCard({required this.site});

  final Site site;

  @override
  Widget build(BuildContext context) {
    final tone = kTonePalette[Tone.lilac]!;
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
            child:
                Icon(Icons.apartment_rounded, color: tone.fg, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  site.name,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  site.location?.trim().isNotEmpty == true
                      ? site.location!.trim()
                      : 'No location set',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                SiteStatusChip(status: site.status),
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
  const _MetaCard({required this.site});

  final Site site;

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
            icon: Icons.event_available_rounded,
            label: 'Created',
            value: site.createdAt.toReadable(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.update_rounded,
            label: 'Last updated',
            value: '${site.updatedAt.toReadable()} · ${siteTimeAgo(site.updatedAt)}',
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
          width: 110,
          child: Text(label, style: textTheme.bodySmall),
        ),
        Expanded(
          child: Text(value, style: textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _TestSetsCard extends StatelessWidget {
  const _TestSetsCard({required this.testSetCount, required this.onTap});

  final int testSetCount;
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
                    Icons.science_rounded,
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
                        'Test Sets',
                        style: textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        testSetCount == 1
                            ? '1 test set'
                            : '$testSetCount test sets',
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
