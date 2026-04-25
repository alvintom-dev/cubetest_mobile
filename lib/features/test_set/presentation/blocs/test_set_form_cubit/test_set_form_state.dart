part of 'test_set_form_cubit.dart';

abstract class TestSetFormState extends Equatable {
  const TestSetFormState();

  @override
  List<Object?> get props => [];
}

class TestSetFormInitial extends TestSetFormState {
  const TestSetFormInitial();
}

class TestSetFormSubmitting extends TestSetFormState {
  const TestSetFormSubmitting();
}

class TestSetFormSuccess extends TestSetFormState {
  const TestSetFormSuccess(this.testSet);

  final TestSet testSet;

  @override
  List<Object?> get props => [testSet];
}

class TestSetFormValidationError extends TestSetFormState {
  const TestSetFormValidationError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class TestSetFormError extends TestSetFormState {
  const TestSetFormError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
