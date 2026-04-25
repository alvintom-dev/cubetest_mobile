import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di.dart';
import '../../../../core/theme/app_theme.dart';
import '../blocs/sites_archive_cubit/sites_archive_cubit.dart';
import '../widgets/site_list_item.dart';

class SitesArchivePage extends StatelessWidget {
  const SitesArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SitesArchiveCubit>(
      create: (_) => getIt<SitesArchiveCubit>()..fetch(),
      child: const _ArchiveView(),
    );
  }
}

class _ArchiveView extends StatelessWidget {
  const _ArchiveView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Archived Sites')),
      body: BlocBuilder<SitesArchiveCubit, SitesArchiveState>(
        builder: (context, state) {
          if (state is SitesArchiveLoading || state is SitesArchiveInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SitesArchiveError) {
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
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => context.read<SitesArchiveCubit>().fetch(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is SitesArchiveLoadedNoData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.archive_outlined, size: 56, color: AppColors.ink4),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Archive is empty.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }
          if (state is SitesArchiveLoadedData) {
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              itemCount: state.sites.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, index) {
                final site = state.sites[index];
                return SiteListItem(
                  site: site,
                  trailing: IconButton(
                    tooltip: 'Permanently delete',
                    icon: const Icon(
                      Icons.delete_forever,
                      color: AppColors.danger,
                    ),
                    onPressed: () => _confirmPermanentDelete(context, site.id),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _confirmPermanentDelete(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Permanently delete?'),
        content: const Text('This action cannot be undone.'),
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
      await context.read<SitesArchiveCubit>().permanentDelete(id);
    }
  }
}
