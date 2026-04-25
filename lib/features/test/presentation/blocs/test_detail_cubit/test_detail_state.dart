part of 'test_detail_cubit.dart';

abstract class TestDetailState extends Equatable {
  const TestDetailState();

  @override
  List<Object?> get props => [];
}

class TestDetailInitial extends TestDetailState {
  const TestDetailInitial();
}

class TestDetailLoading extends TestDetailState {
  const TestDetailLoading();
}

class TestDetailLoaded extends TestDetailState {
  const TestDetailLoaded({required this.test, required this.cubeResultSets});

  final Test test;
  final List<CubeResultSet> cubeResultSets;

  @override
  List<Object?> get props => [test, cubeResultSets];
}

class TestDetailActionError extends TestDetailState {
  const TestDetailActionError({
    required this.test,
    required this.cubeResultSets,
    required this.message,
  });

  final Test test;
  final List<CubeResultSet> cubeResultSets;
  final String message;

  @override
  List<Object?> get props => [test, cubeResultSets, message];
}

class TestDetailDeleted extends TestDetailState {
  const TestDetailDeleted();
}

class TestDetailError extends TestDetailState {
  const TestDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
