part of 'test_form_cubit.dart';

abstract class TestFormState extends Equatable {
  const TestFormState();

  @override
  List<Object?> get props => [];
}

class TestFormInitial extends TestFormState {
  const TestFormInitial();
}

class TestFormSubmitting extends TestFormState {
  const TestFormSubmitting();
}

class TestFormSuccess extends TestFormState {
  const TestFormSuccess(this.test);

  final Test test;

  @override
  List<Object?> get props => [test];
}

class TestFormValidationError extends TestFormState {
  const TestFormValidationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class TestFormError extends TestFormState {
  const TestFormError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
