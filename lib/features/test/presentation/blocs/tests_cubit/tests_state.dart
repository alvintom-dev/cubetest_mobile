part of 'tests_cubit.dart';

abstract class TestsState extends Equatable {
  const TestsState();

  @override
  List<Object?> get props => [];
}

class TestsInitial extends TestsState {
  const TestsInitial();
}

class TestsLoading extends TestsState {
  const TestsLoading();
}

class TestsLoadedData extends TestsState {
  const TestsLoadedData(this.items);

  final List<Test> items;

  @override
  List<Object?> get props => [items];
}

class TestsLoadedNoData extends TestsState {
  const TestsLoadedNoData();
}

class TestsError extends TestsState {
  const TestsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
