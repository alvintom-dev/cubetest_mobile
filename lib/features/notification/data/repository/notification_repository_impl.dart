import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/clock/clock.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/ports/upcoming_tests_query.dart';
import '../../../../services/notification/local_notification_service.dart';
import '../../../../services/preferences/preferences_service.dart';
import '../../domain/repository/notification_repository.dart';
import '../datasource/notification_local_datasource.dart';
import '../models/schedule_data_model.dart';

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(
    this._datasource,
    this._upcomingTestsQuery,
    this._notificationService,
    this._preferencesService,
    this._clock,
  );

  final NotificationLocalDatasource _datasource;
  final UpcomingTestsQuery _upcomingTestsQuery;
  final LocalNotificationService _notificationService;
  final PreferencesService _preferencesService;
  final Clock _clock;

  static const int _triggerHour = 8;

  @override
  Future<Either<Failure, Unit>> syncNotifications() async {
    try {
      final now = _clock.now();
      final today = _dateOnly(now);

      final dueDates =
          await _upcomingTestsQuery.findUpcomingDueDates(today: today);

      final grouped = <DateTime, int>{};
      for (final d in dueDates) {
        final key = _dateOnly(d);
        if (key.isBefore(today)) continue;
        grouped[key] = (grouped[key] ?? 0) + 1;
      }

      final existingList = await _datasource.getAll();
      final existingByDate = <DateTime, ScheduleDataModel>{
        for (final m in existingList) m.toEntity().triggerDate: m,
      };

      for (final entry in existingByDate.entries) {
        if (grouped.containsKey(entry.key)) continue;
        await _notificationService.cancel(entry.value.id);
        await _datasource.delete(entry.value.id);
      }

      for (final entry in grouped.entries) {
        final date = entry.key;
        final count = entry.value;
        final id = _computeNotificationId(date);
        final existing = existingByDate[date];

        if (existing == null) {
          final scheduled = await _trySchedule(
            id: id,
            triggerDate: date,
            count: count,
            now: now,
            today: today,
          );
          if (scheduled) {
            await _datasource.insert(
              ScheduleDataModel(
                id: id,
                triggerDate: _formatDate(date),
                testCount: count,
              ),
            );
          }
        } else if (existing.testCount != count) {
          await _notificationService.cancel(id);
          final scheduled = await _trySchedule(
            id: id,
            triggerDate: date,
            count: count,
            now: now,
            today: today,
          );
          if (scheduled) {
            await _datasource.update(
              ScheduleDataModel(
                id: id,
                triggerDate: _formatDate(date),
                testCount: count,
              ),
            );
          }
        }
      }

      await _preferencesService.setLastSyncAt(now);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> shouldSync() async {
    try {
      final lastSync = await _preferencesService.getLastSyncAt();
      final schedule = await _datasource.getAll();
      final now = _clock.now();
      final result = lastSync == null ||
          now.difference(lastSync) > const Duration(hours: 12) ||
          schedule.isEmpty;
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<bool> _trySchedule({
    required int id,
    required DateTime triggerDate,
    required int count,
    required DateTime now,
    required DateTime today,
  }) async {
    final triggerAt = DateTime(
      triggerDate.year,
      triggerDate.month,
      triggerDate.day,
      _triggerHour,
    );
    if (triggerDate.isAtSameMomentAs(today) && !now.isBefore(triggerAt)) {
      return false;
    }
    final dateLabel = _formatDate(triggerDate);
    final body = count == 1
        ? 'You have 1 cube test due on $dateLabel'
        : 'You have $count cube tests due on $dateLabel';
    await _notificationService.schedule(
      id: id,
      triggerAt: triggerAt,
      title: 'Cube Test Due',
      body: body,
    );
    return true;
  }

  static DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  static int _computeNotificationId(DateTime date) =>
      date.year * 10000 + date.month * 100 + date.day;

  static String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
