part of 'test_set_detail_cubit.dart';

abstract class TestSetDetailState extends Equatable {
  const TestSetDetailState();

  @override
  List<Object?> get props => [];
}

class TestSetDetailInitial extends TestSetDetailState {
  const TestSetDetailInitial();
}

class TestSetDetailLoading extends TestSetDetailState {
  const TestSetDetailLoading();
}

class TestSetDetailLoaded extends TestSetDetailState {
  const TestSetDetailLoaded(this.testSet, [this.progress = TestSetProgress.empty]);

  final TestSet testSet;
  final TestSetProgress progress;

  @override
  List<Object?> get props => [testSet, progress];
}

class TestSetDetailDeleted extends TestSetDetailState {
  const TestSetDetailDeleted();
}

class TestSetDetailError extends TestSetDetailState {
  const TestSetDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
