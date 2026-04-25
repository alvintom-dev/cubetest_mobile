part of 'test_sets_cubit.dart';

abstract class TestSetsState extends Equatable {
  const TestSetsState();

  @override
  List<Object?> get props => [];
}

class TestSetsInitial extends TestSetsState {
  const TestSetsInitial();
}

class TestSetsLoading extends TestSetsState {
  const TestSetsLoading();
}

class TestSetsLoadedData extends TestSetsState {
  const TestSetsLoadedData(this.items, [this.progressBySetId = const {}]);

  final List<TestSet> items;
  final Map<String, TestSetProgress> progressBySetId;

  @override
  List<Object?> get props => [items, progressBySetId];
}

class TestSetsLoadedNoData extends TestSetsState {
  const TestSetsLoadedNoData();
}

class TestSetsError extends TestSetsState {
  const TestSetsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
