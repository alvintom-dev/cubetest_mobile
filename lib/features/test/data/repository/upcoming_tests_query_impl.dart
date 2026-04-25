import 'package:injectable/injectable.dart';

import '../../../../core/ports/upcoming_tests_query.dart';
import '../datasource/test_local_datasource.dart';

@Injectable(as: UpcomingTestsQuery)
class UpcomingTestsQueryImpl implements UpcomingTestsQuery {
  const UpcomingTestsQueryImpl(this._datasource);

  final TestLocalDatasource _datasource;

  @override
  Future<List<DateTime>> findUpcomingDueDates({
    required DateTime today,
  }) async {
    final todayIso = DateTime(today.year, today.month, today.day)
        .toIso8601String();
    final rawDates = await _datasource.getDueDatesFromDate(todayIso);
    return rawDates.map(DateTime.parse).toList();
  }
}
