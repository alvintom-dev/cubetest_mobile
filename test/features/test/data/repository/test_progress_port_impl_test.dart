import 'package:cubetest_mobile/core/ports/test_set_progress.dart';
import 'package:cubetest_mobile/features/test/data/datasource/test_local_datasource.dart';
import 'package:cubetest_mobile/features/test/data/models/test_model.dart';
import 'package:cubetest_mobile/features/test/data/repository/test_progress_port_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestLocalDatasource extends Mock implements TestLocalDatasource {}

void main() {
  late MockTestLocalDatasource datasource;
  late TestProgressPortImpl port;

  final now = DateTime(2026, 1, 1).toIso8601String();

  TestModel model(String id, String status) => TestModel(
        id: id,
        testSetId: 'ts-1',
        type: 'day7',
        dueDate: now,
        status: status,
        createdAt: now,
        updatedAt: now,
      );

  setUp(() {
    datasource = MockTestLocalDatasource();
    port = TestProgressPortImpl(datasource);
  });

  group('getProgress', () {
    test('returns 0/0 when the test set has no tests', () async {
      when(() => datasource.getTests('ts-1')).thenAnswer((_) async => []);

      final result = await port.getProgress('ts-1');

      expect(result, const TestSetProgress(completed: 0, total: 0));
      expect(result.display, '0/0');
    });

    test('counts passed, failed, and skipped as completed', () async {
      when(() => datasource.getTests('ts-1')).thenAnswer((_) async => [
            model('1', 'passed'),
            model('2', 'failed'),
            model('3', 'skipped'),
          ]);

      final result = await port.getProgress('ts-1');

      expect(result, const TestSetProgress(completed: 3, total: 3));
    });

    test('does not count pending as completed', () async {
      when(() => datasource.getTests('ts-1')).thenAnswer((_) async => [
            model('1', 'pending'),
            model('2', 'pending'),
            model('3', 'pending'),
          ]);

      final result = await port.getProgress('ts-1');

      expect(result, const TestSetProgress(completed: 0, total: 3));
    });

    test('handles a mix of statuses', () async {
      when(() => datasource.getTests('ts-1')).thenAnswer((_) async => [
            model('1', 'passed'),
            model('2', 'pending'),
            model('3', 'failed'),
            model('4', 'pending'),
            model('5', 'skipped'),
          ]);

      final result = await port.getProgress('ts-1');

      expect(result, const TestSetProgress(completed: 3, total: 5));
      expect(result.display, '3/5');
    });
  });

  group('getProgressBulk', () {
    test('returns a map keyed by test set id', () async {
      when(() => datasource.getTests('ts-1')).thenAnswer((_) async => [
            model('1', 'passed'),
            model('2', 'pending'),
          ]);
      when(() => datasource.getTests('ts-2')).thenAnswer((_) async => [
            model('3', 'passed'),
            model('4', 'failed'),
            model('5', 'skipped'),
          ]);
      when(() => datasource.getTests('ts-3')).thenAnswer((_) async => []);

      final result = await port.getProgressBulk(['ts-1', 'ts-2', 'ts-3']);

      expect(result, {
        'ts-1': const TestSetProgress(completed: 1, total: 2),
        'ts-2': const TestSetProgress(completed: 3, total: 3),
        'ts-3': const TestSetProgress(completed: 0, total: 0),
      });
    });

    test('returns an empty map when given no ids', () async {
      final result = await port.getProgressBulk(const []);
      expect(result, isEmpty);
      verifyNever(() => datasource.getTests(any()));
    });
  });
}
