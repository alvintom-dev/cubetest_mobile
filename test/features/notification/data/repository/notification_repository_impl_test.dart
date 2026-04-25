import 'package:cubetest_mobile/core/clock/clock.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/core/ports/upcoming_tests_query.dart';
import 'package:cubetest_mobile/features/notification/data/datasource/notification_local_datasource.dart';
import 'package:cubetest_mobile/features/notification/data/models/schedule_data_model.dart';
import 'package:cubetest_mobile/features/notification/data/repository/notification_repository_impl.dart';
import 'package:cubetest_mobile/services/notification/local_notification_service.dart';
import 'package:cubetest_mobile/services/preferences/preferences_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationLocalDatasource extends Mock
    implements NotificationLocalDatasource {}

class MockUpcomingTestsQuery extends Mock implements UpcomingTestsQuery {}

class MockLocalNotificationService extends Mock
    implements LocalNotificationService {}

class MockPreferencesService extends Mock implements PreferencesService {}

class FakeClock implements Clock {
  FakeClock(this.value);
  DateTime value;
  @override
  DateTime now() => value;
}

class _FakeScheduleDataModel extends Fake implements ScheduleDataModel {}

void main() {
  late MockNotificationLocalDatasource datasource;
  late MockUpcomingTestsQuery upcomingTestsQuery;
  late MockLocalNotificationService notificationService;
  late MockPreferencesService preferencesService;
  late FakeClock clock;
  late NotificationRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(_FakeScheduleDataModel());
    registerFallbackValue(DateTime(2026));
  });

  setUp(() {
    datasource = MockNotificationLocalDatasource();
    upcomingTestsQuery = MockUpcomingTestsQuery();
    notificationService = MockLocalNotificationService();
    preferencesService = MockPreferencesService();
    // 2026-04-24 07:00 local — before 8am so today-same-day schedule is allowed.
    clock = FakeClock(DateTime(2026, 4, 24, 7));
    repository = NotificationRepositoryImpl(
      datasource,
      upcomingTestsQuery,
      notificationService,
      preferencesService,
      clock,
    );

    when(() => notificationService.schedule(
          id: any(named: 'id'),
          triggerAt: any(named: 'triggerAt'),
          title: any(named: 'title'),
          body: any(named: 'body'),
        )).thenAnswer((_) async {});
    when(() => notificationService.cancel(any())).thenAnswer((_) async {});
    when(() => datasource.insert(any())).thenAnswer((_) async {});
    when(() => datasource.update(any())).thenAnswer((_) async {});
    when(() => datasource.delete(any())).thenAnswer((_) async {});
    when(() => preferencesService.setLastSyncAt(any()))
        .thenAnswer((_) async {});
  });

  group('syncNotifications', () {
    test('no tests + no schedule: updates lastSyncAt and returns Right',
        () async {
      when(() => upcomingTestsQuery.findUpcomingDueDates(
          today: any(named: 'today'))).thenAnswer((_) async => []);
      when(() => datasource.getAll()).thenAnswer((_) async => []);

      final result = await repository.syncNotifications();

      expect(result, const Right<Failure, Unit>(unit));
      verifyNever(() => notificationService.schedule(
          id: any(named: 'id'),
          triggerAt: any(named: 'triggerAt'),
          title: any(named: 'title'),
          body: any(named: 'body')));
      verifyNever(() => notificationService.cancel(any()));
      verifyNever(() => datasource.insert(any()));
      verifyNever(() => datasource.update(any()));
      verifyNever(() => datasource.delete(any()));
      verify(() => preferencesService.setLastSyncAt(clock.value)).called(1);
    });

    test('CREATE: new due date → schedules and inserts scheduleData', () async {
      when(() => upcomingTestsQuery.findUpcomingDueDates(
          today: any(named: 'today'))).thenAnswer(
          (_) async => [DateTime(2026, 5, 1)]);
      when(() => datasource.getAll()).thenAnswer((_) async => []);

      final result = await repository.syncNotifications();

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => notificationService.schedule(
            id: 20260501,
            triggerAt: DateTime(2026, 5, 1, 8),
            title: 'Cube Test Due',
            body: 'You have 1 cube test due on 2026-05-01',
          )).called(1);
      final insertedCapture =
          verify(() => datasource.insert(captureAny())).captured;
      expect(insertedCapture.single,
          const ScheduleDataModel(
              id: 20260501, triggerDate: '2026-05-01', testCount: 1));
      verify(() => preferencesService.setLastSyncAt(clock.value)).called(1);
    });

    test('UPDATE: same date, different count → cancel + schedule + update',
        () async {
      when(() => upcomingTestsQuery.findUpcomingDueDates(
              today: any(named: 'today')))
          .thenAnswer((_) async => [DateTime(2026, 5, 1), DateTime(2026, 5, 1)]);
      when(() => datasource.getAll()).thenAnswer((_) async => [
            const ScheduleDataModel(
              id: 20260501,
              triggerDate: '2026-05-01',
              testCount: 1,
            ),
          ]);

      final result = await repository.syncNotifications();

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => notificationService.cancel(20260501)).called(1);
      verify(() => notificationService.schedule(
            id: 20260501,
            triggerAt: DateTime(2026, 5, 1, 8),
            title: 'Cube Test Due',
            body: 'You have 2 cube tests due on 2026-05-01',
          )).called(1);
      final updatedCapture =
          verify(() => datasource.update(captureAny())).captured;
      expect(
        updatedCapture.single,
        const ScheduleDataModel(
            id: 20260501, triggerDate: '2026-05-01', testCount: 2),
      );
      verifyNever(() => datasource.insert(any()));
      verifyNever(() => datasource.delete(any()));
    });

    test('DELETE: schedule entry without matching test → cancel + delete',
        () async {
      when(() => upcomingTestsQuery.findUpcomingDueDates(
          today: any(named: 'today'))).thenAnswer((_) async => []);
      when(() => datasource.getAll()).thenAnswer((_) async => [
            const ScheduleDataModel(
              id: 20260501,
              triggerDate: '2026-05-01',
              testCount: 1,
            ),
          ]);

      final result = await repository.syncNotifications();

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => notificationService.cancel(20260501)).called(1);
      verify(() => datasource.delete(20260501)).called(1);
      verifyNever(() => notificationService.schedule(
          id: any(named: 'id'),
          triggerAt: any(named: 'triggerAt'),
          title: any(named: 'title'),
          body: any(named: 'body')));
      verifyNever(() => datasource.insert(any()));
      verifyNever(() => datasource.update(any()));
    });

    test('NO CHANGE: matching date and count → no writes (lastSyncAt updated)',
        () async {
      when(() => upcomingTestsQuery.findUpcomingDueDates(
          today: any(named: 'today'))).thenAnswer(
          (_) async => [DateTime(2026, 5, 1)]);
      when(() => datasource.getAll()).thenAnswer((_) async => [
            const ScheduleDataModel(
              id: 20260501,
              triggerDate: '2026-05-01',
              testCount: 1,
            ),
          ]);

      final result = await repository.syncNotifications();

      expect(result, const Right<Failure, Unit>(unit));
      verifyNever(() => notificationService.schedule(
          id: any(named: 'id'),
          triggerAt: any(named: 'triggerAt'),
          title: any(named: 'title'),
          body: any(named: 'body')));
      verifyNever(() => notificationService.cancel(any()));
      verifyNever(() => datasource.insert(any()));
      verifyNever(() => datasource.update(any()));
      verifyNever(() => datasource.delete(any()));
      verify(() => preferencesService.setLastSyncAt(clock.value)).called(1);
    });

    test('multiple tests on same due date → one grouped notification', () async {
      when(() => upcomingTestsQuery.findUpcomingDueDates(
              today: any(named: 'today')))
          .thenAnswer((_) async => [
                DateTime(2026, 5, 1, 10),
                DateTime(2026, 5, 1, 15),
                DateTime(2026, 5, 1, 23, 59),
              ]);
      when(() => datasource.getAll()).thenAnswer((_) async => []);

      final result = await repository.syncNotifications();

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => notificationService.schedule(
            id: 20260501,
            triggerAt: DateTime(2026, 5, 1, 8),
            title: 'Cube Test Due',
            body: 'You have 3 cube tests due on 2026-05-01',
          )).called(1);
      verify(() => datasource.insert(const ScheduleDataModel(
          id: 20260501, triggerDate: '2026-05-01', testCount: 3))).called(1);
    });

    test('skip when dueDate==today and currentTime >= 8am', () async {
      clock.value = DateTime(2026, 4, 24, 9);
      when(() => upcomingTestsQuery.findUpcomingDueDates(
          today: any(named: 'today'))).thenAnswer(
          (_) async => [DateTime(2026, 4, 24)]);
      when(() => datasource.getAll()).thenAnswer((_) async => []);

      final result = await repository.syncNotifications();

      expect(result, const Right<Failure, Unit>(unit));
      verifyNever(() => notificationService.schedule(
          id: any(named: 'id'),
          triggerAt: any(named: 'triggerAt'),
          title: any(named: 'title'),
          body: any(named: 'body')));
      verifyNever(() => datasource.insert(any()));
      verify(() => preferencesService.setLastSyncAt(clock.value)).called(1);
    });

    test('schedule when dueDate==today and currentTime < 8am', () async {
      clock.value = DateTime(2026, 4, 24, 7, 30);
      when(() => upcomingTestsQuery.findUpcomingDueDates(
          today: any(named: 'today'))).thenAnswer(
          (_) async => [DateTime(2026, 4, 24)]);
      when(() => datasource.getAll()).thenAnswer((_) async => []);

      final result = await repository.syncNotifications();

      expect(result, const Right<Failure, Unit>(unit));
      verify(() => notificationService.schedule(
            id: 20260424,
            triggerAt: DateTime(2026, 4, 24, 8),
            title: 'Cube Test Due',
            body: 'You have 1 cube test due on 2026-04-24',
          )).called(1);
      verify(() => datasource.insert(const ScheduleDataModel(
          id: 20260424, triggerDate: '2026-04-24', testCount: 1))).called(1);
    });

    test(
        'schedule failure aborts sync: returns Left, lastSyncAt not updated, '
        'insert not called for failed row', () async {
      when(() => upcomingTestsQuery.findUpcomingDueDates(
              today: any(named: 'today')))
          .thenAnswer((_) async => [DateTime(2026, 5, 1)]);
      when(() => datasource.getAll()).thenAnswer((_) async => []);
      when(() => notificationService.schedule(
            id: any(named: 'id'),
            triggerAt: any(named: 'triggerAt'),
            title: any(named: 'title'),
            body: any(named: 'body'),
          )).thenThrow(Exception('schedule failed'));

      final result = await repository.syncNotifications();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('expected Left'),
      );
      verifyNever(() => datasource.insert(any()));
      verifyNever(() => preferencesService.setLastSyncAt(any()));
    });

    test('idempotency: second call with same inputs produces zero writes',
        () async {
      when(() => upcomingTestsQuery.findUpcomingDueDates(
          today: any(named: 'today'))).thenAnswer(
          (_) async => [DateTime(2026, 5, 1)]);
      // First call: empty schedule → CREATE path.
      // Second call: schedule matches current tests → NO CHANGE path.
      var getAllCalls = 0;
      when(() => datasource.getAll()).thenAnswer((_) async {
        getAllCalls++;
        if (getAllCalls == 1) return <ScheduleDataModel>[];
        return const [
          ScheduleDataModel(
              id: 20260501, triggerDate: '2026-05-01', testCount: 1),
        ];
      });

      final first = await repository.syncNotifications();
      expect(first, const Right<Failure, Unit>(unit));

      // Reset mock interactions to verify only the second call's effects.
      clearInteractions(notificationService);
      clearInteractions(datasource);
      clearInteractions(preferencesService);
      when(() => datasource.getAll()).thenAnswer((_) async => const [
            ScheduleDataModel(
                id: 20260501, triggerDate: '2026-05-01', testCount: 1),
          ]);

      final second = await repository.syncNotifications();
      expect(second, const Right<Failure, Unit>(unit));
      verifyNever(() => notificationService.schedule(
          id: any(named: 'id'),
          triggerAt: any(named: 'triggerAt'),
          title: any(named: 'title'),
          body: any(named: 'body')));
      verifyNever(() => notificationService.cancel(any()));
      verifyNever(() => datasource.insert(any()));
      verifyNever(() => datasource.update(any()));
      verifyNever(() => datasource.delete(any()));
    });
  });

  group('shouldSync', () {
    test('returns true when lastSyncAt is null', () async {
      when(() => preferencesService.getLastSyncAt())
          .thenAnswer((_) async => null);
      when(() => datasource.getAll()).thenAnswer((_) async => const [
            ScheduleDataModel(
                id: 20260501, triggerDate: '2026-05-01', testCount: 1),
          ]);

      final result = await repository.shouldSync();

      expect(result, const Right<Failure, bool>(true));
    });

    test('returns true when scheduleData is empty', () async {
      when(() => preferencesService.getLastSyncAt())
          .thenAnswer((_) async => clock.value.subtract(const Duration(hours: 1)));
      when(() => datasource.getAll()).thenAnswer((_) async => []);

      final result = await repository.shouldSync();

      expect(result, const Right<Failure, bool>(true));
    });

    test('returns true when lastSyncAt is older than 12 hours', () async {
      when(() => preferencesService.getLastSyncAt())
          .thenAnswer((_) async => clock.value.subtract(const Duration(hours: 13)));
      when(() => datasource.getAll()).thenAnswer((_) async => const [
            ScheduleDataModel(
                id: 20260501, triggerDate: '2026-05-01', testCount: 1),
          ]);

      final result = await repository.shouldSync();

      expect(result, const Right<Failure, bool>(true));
    });

    test('returns false when within 12h and schedule is non-empty', () async {
      when(() => preferencesService.getLastSyncAt())
          .thenAnswer((_) async => clock.value.subtract(const Duration(hours: 1)));
      when(() => datasource.getAll()).thenAnswer((_) async => const [
            ScheduleDataModel(
                id: 20260501, triggerDate: '2026-05-01', testCount: 1),
          ]);

      final result = await repository.shouldSync();

      expect(result, const Right<Failure, bool>(false));
    });

    test('wraps datasource exception as CacheFailure', () async {
      when(() => preferencesService.getLastSyncAt())
          .thenAnswer((_) async => null);
      when(() => datasource.getAll()).thenThrow(Exception('db boom'));

      final result = await repository.shouldSync();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('expected Left'),
      );
    });
  });
}
