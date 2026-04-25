abstract class UpcomingTestsQuery {
  Future<List<DateTime>> findUpcomingDueDates({required DateTime today});
}
