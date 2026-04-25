part of 'sites_cubit.dart';

abstract class SitesState extends Equatable {
  const SitesState();

  @override
  List<Object?> get props => [];
}

class SitesInitial extends SitesState {
  const SitesInitial();
}

class SitesLoading extends SitesState {
  const SitesLoading();
}

class SitesLoadedData extends SitesState {
  const SitesLoadedData(this.sites);

  final List<Site> sites;

  @override
  List<Object?> get props => [sites];
}

class SitesLoadedNoData extends SitesState {
  const SitesLoadedNoData();
}

class SitesError extends SitesState {
  const SitesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
