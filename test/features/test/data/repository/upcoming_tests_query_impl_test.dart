import 'package:cubetest_mobile/features/test/data/datasource/test_local_datasource.dart';
import 'package:cubetest_mobile/features/test/data/repository/upcoming_tests_query_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestLocalDatasource extends Mock implements TestLocalDatasource {}

void main() {
  late MockTestLocalDatasource datasource;
  late UpcomingTestsQueryImpl query;

  setUp(() {
    datasource = MockTestLocalDatasource();
    query = UpcomingTestsQueryImpl(datasource);
  });

  test('passes today as ISO8601 (midnight) to datasource', () async {
    when(() => datasource.getDueDatesFromDate(any()))
        .thenAnswer((_) async => <String>[]);

    await query.findUpcomingDueDates(today: DateTime(2026, 4, 24, 10, 30));

    verify(() => datasource.getDueDatesFromDate(
        DateTime(2026, 4, 24).toIso8601String())).called(1);
  });

  test('parses returned strings into DateTimes preserving duplicates',
      () async {
    when(() => datasource.getDueDatesFromDate(any())).thenAnswer((_) async => [
          '2026-04-25T00:00:00.000',
          '2026-04-25T00:00:00.000',
          '2026-05-02T12:34:56.000',
        ]);

    final result =
        await query.findUpcomingDueDates(today: DateTime(2026, 4, 24));

    expect(result, [
      DateTime.parse('2026-04-25T00:00:00.000'),
      DateTime.parse('2026-04-25T00:00:00.000'),
      DateTime.parse('2026-05-02T12:34:56.000'),
    ]);
  });
}
