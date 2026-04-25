import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/di.dart';
import '../../../../core/route/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/site.dart';
import '../blocs/sites_cubit/sites_cubit.dart';
import '../widgets/site_list_item.dart';

enum _Filter { all, open, closed }

class SitesPage extends StatelessWidget {
  const SitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SitesCubit>(
      create: (_) => getIt<SitesCubit>()..fetch(),
      child: const _SitesView(),
    );
  }
}

class _SitesView extends StatefulWidget {
  const _SitesView();

  @override
  State<_SitesView> createState() => _SitesViewState();
}

class _SitesViewState extends State<_SitesView> {
  String _query = '';
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sites'),
        actions: [
          IconButton(
            tooltip: 'Archive',
            icon: const Icon(Icons.archive_outlined),
            onPressed: () async {
              await context.pushNamed(AppRoutes.sitesArchive);
              if (context.mounted) {
                await context.read<SitesCubit>().fetch();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<SitesCubit, SitesState>(
        builder: (context, state) {
          if (state is SitesLoading || state is SitesInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SitesError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<SitesCubit>().fetch(),
            );
          }

          final items =
              state is SitesLoadedData ? state.sites : const <Site>[];
          final counts = _counts(items);
          final filtered = _apply(items);

          return RefreshIndicator(
            onRefresh: () => context.read<SitesCubit>().fetch(),
            child: Column(
              children: [
                Padding(
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
                Padding(
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
                Expanded(
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (state is SitesLoadedNoData)
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
                            AppSpacing.xxlTime4,
                          ),
                          sliver: SliverList.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (_, index) {
                              final site = filtered[index];
                              return SiteListItem(
                                site: site,
                                onTap: () async {
                                  await context.pushNamed(
                                    AppRoutes.siteDetail,
                                    pathParameters: {'id': site.id},
                                  );
                                  if (context.mounted) {
                                    await context.read<SitesCubit>().fetch();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (innerContext) => FloatingActionButton(
          onPressed: () async {
            await innerContext.pushNamed(AppRoutes.siteCreate);
            if (innerContext.mounted) {
              await innerContext.read<SitesCubit>().fetch();
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  _FilterCounts _counts(List<Site> items) {
    var open = 0;
    var closed = 0;
    for (final site in items) {
      if (site.status == SiteStatus.open) {
        open++;
      } else {
        closed++;
      }
    }
    return _FilterCounts(all: items.length, open: open, closed: closed);
  }

  List<Site> _apply(List<Site> items) {
    final q = _query.trim().toLowerCase();
    return items.where((site) {
      final matchesFilter = switch (_filter) {
        _Filter.all => true,
        _Filter.open => site.status == SiteStatus.open,
        _Filter.closed => site.status == SiteStatus.close,
      };
      if (!matchesFilter) return false;
      if (q.isEmpty) return true;
      final name = site.name.toLowerCase();
      final location = (site.location ?? '').toLowerCase();
      return name.contains(q) || location.contains(q);
    }).toList();
  }
}

class _FilterCounts {
  const _FilterCounts({
    required this.all,
    required this.open,
    required this.closed,
  });

  final int all;
  final int open;
  final int closed;
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search sites…',
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
            label: 'Open',
            count: counts.open,
            isSelected: selected == _Filter.open,
            onTap: () => onSelected(_Filter.open),
          ),
          const SizedBox(width: AppSpacing.sm),
          _FilterChip(
            label: 'Closed',
            count: counts.closed,
            isSelected: selected == _Filter.closed,
            onTap: () => onSelected(_Filter.closed),
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
          'All Sites',
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
            'No sites yet. Tap + to create.',
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
            'No sites match your search.',
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
