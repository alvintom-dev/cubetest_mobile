abstract class TestSetTestCoordinator {
  Future<void> autoCreateTestsForTestSet({
    required String testSetId,
    required DateTime concretingDate,
  });

  Future<void> cascadeDeleteTestsForTestSet({required String testSetId});
}
