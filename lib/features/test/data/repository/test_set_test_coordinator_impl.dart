import 'package:injectable/injectable.dart';

import '../../../../core/ports/test_set_test_coordinator.dart';
import '../../domain/repository/test_repository.dart';

@Injectable(as: TestSetTestCoordinator)
class TestSetTestCoordinatorImpl implements TestSetTestCoordinator {
  const TestSetTestCoordinatorImpl(this._repository);

  final TestRepository _repository;

  @override
  Future<void> autoCreateTestsForTestSet({
    required String testSetId,
    required DateTime concretingDate,
  }) async {
    final result = await _repository.autoCreateTestsForTestSet(
      testSetId: testSetId,
      concretingDate: concretingDate,
    );
    result.fold(
      (failure) => throw Exception(failure.toString()),
      (_) {},
    );
  }

  @override
  Future<void> cascadeDeleteTestsForTestSet({
    required String testSetId,
  }) async {
    final result =
        await _repository.deleteTestsByTestSet(testSetId: testSetId);
    result.fold(
      (failure) => throw Exception(failure.toString()),
      (_) {},
    );
  }
}
