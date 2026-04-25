import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/notification/domain/repository/notification_repository.dart';
import 'package:cubetest_mobile/features/notification/domain/usecases/sync_notifications_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository repository;
  late SyncNotificationsUsecase usecase;

  setUp(() {
    repository = MockNotificationRepository();
    usecase = SyncNotificationsUsecase(repository);
  });

  test('delegates to repository on success', () async {
    when(() => repository.syncNotifications())
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase();

    expect(result, const Right<Failure, Unit>(unit));
    verify(() => repository.syncNotifications()).called(1);
  });

  test('propagates repository failure', () async {
    when(() => repository.syncNotifications())
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase();

    expect(result, const Left<Failure, Unit>(CacheFailure('boom')));
  });
}
