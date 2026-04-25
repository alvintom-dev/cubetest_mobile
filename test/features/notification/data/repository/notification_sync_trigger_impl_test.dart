import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/notification/data/repository/notification_sync_trigger_impl.dart';
import 'package:cubetest_mobile/features/notification/domain/usecases/sync_notifications_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSyncNotificationsUsecase extends Mock
    implements SyncNotificationsUsecase {}

void main() {
  late MockSyncNotificationsUsecase usecase;
  late NotificationSyncTriggerImpl trigger;

  setUp(() {
    usecase = MockSyncNotificationsUsecase();
    trigger = NotificationSyncTriggerImpl(usecase);
  });

  test('invokes the sync usecase', () async {
    when(() => usecase()).thenAnswer((_) async => const Right(unit));

    await trigger.syncNotifications();

    verify(() => usecase()).called(1);
  });

  test('swallows exceptions thrown by the usecase', () async {
    when(() => usecase()).thenThrow(Exception('boom'));

    await expectLater(trigger.syncNotifications(), completes);
  });

  test('does not throw when usecase returns a Left failure', () async {
    when(() => usecase())
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    await expectLater(trigger.syncNotifications(), completes);
  });
}
