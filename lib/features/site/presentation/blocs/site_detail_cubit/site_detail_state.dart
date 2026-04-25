part of 'site_detail_cubit.dart';

abstract class SiteDetailState extends Equatable {
  const SiteDetailState();

  @override
  List<Object?> get props => [];
}

class SiteDetailInitial extends SiteDetailState {
  const SiteDetailInitial();
}

class SiteDetailLoading extends SiteDetailState {
  const SiteDetailLoading();
}

class SiteDetailLoaded extends SiteDetailState {
  const SiteDetailLoaded(this.site);

  final Site site;

  @override
  List<Object?> get props => [site];
}

class SiteDetailDeleted extends SiteDetailState {
  const SiteDetailDeleted();
}

class SiteDetailError extends SiteDetailState {
  const SiteDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
