part of 'site_form_cubit.dart';

abstract class SiteFormState extends Equatable {
  const SiteFormState();

  @override
  List<Object?> get props => [];
}

class SiteFormInitial extends SiteFormState {
  const SiteFormInitial();
}

class SiteFormSubmitting extends SiteFormState {
  const SiteFormSubmitting();
}

class SiteFormSuccess extends SiteFormState {
  const SiteFormSuccess(this.site);

  final Site site;

  @override
  List<Object?> get props => [site];
}

class SiteFormValidationError extends SiteFormState {
  const SiteFormValidationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SiteFormError extends SiteFormState {
  const SiteFormError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
