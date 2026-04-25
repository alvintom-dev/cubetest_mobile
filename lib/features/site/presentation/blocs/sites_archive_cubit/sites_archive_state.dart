part of 'sites_archive_cubit.dart';

abstract class SitesArchiveState extends Equatable {
  const SitesArchiveState();

  @override
  List<Object?> get props => [];
}

class SitesArchiveInitial extends SitesArchiveState {
  const SitesArchiveInitial();
}

class SitesArchiveLoading extends SitesArchiveState {
  const SitesArchiveLoading();
}

class SitesArchiveLoadedData extends SitesArchiveState {
  const SitesArchiveLoadedData(this.sites);

  final List<Site> sites;

  @override
  List<Object?> get props => [sites];
}

class SitesArchiveLoadedNoData extends SitesArchiveState {
  const SitesArchiveLoadedNoData();
}

class SitesArchiveError extends SitesArchiveState {
  const SitesArchiveError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
