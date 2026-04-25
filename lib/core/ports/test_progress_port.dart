import 'test_set_progress.dart';

abstract class TestProgressPort {
  Future<TestSetProgress> getProgress(String testSetId);

  Future<Map<String, TestSetProgress>> getProgressBulk(
    List<String> testSetIds,
  );
}
