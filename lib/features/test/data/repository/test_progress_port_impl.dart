import 'package:injectable/injectable.dart';

import '../../../../core/ports/test_progress_port.dart';
import '../../../../core/ports/test_set_progress.dart';
import '../datasource/test_local_datasource.dart';

@Injectable(as: TestProgressPort)
class TestProgressPortImpl implements TestProgressPort {
  const TestProgressPortImpl(this._datasource);

  final TestLocalDatasource _datasource;

  @override
  Future<TestSetProgress> getProgress(String testSetId) async {
    final models = await _datasource.getTests(testSetId);
    var completed = 0;
    for (final model in models) {
      if (model.toEntity().isCompleted) completed++;
    }
    return TestSetProgress(completed: completed, total: models.length);
  }

  @override
  Future<Map<String, TestSetProgress>> getProgressBulk(
    List<String> testSetIds,
  ) async {
    final results = await Future.wait(testSetIds.map(getProgress));
    return {
      for (var i = 0; i < testSetIds.length; i++) testSetIds[i]: results[i],
    };
  }
}
