import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/notification/domain/repository/notification_repository.dart';
import 'package:cubetest_mobile/features/notification/domain/usecases/should_sync_notifications_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  late MockNotificationRepository repository;
  late ShouldSyncNotificationsUsecase usecase;

  setUp(() {
    repository = MockNotificationRepository();
    usecase = ShouldSyncNotificationsUsecase(repository);
  });

  test('returns repository result on success', () async {
    when(() => repository.shouldSync())
        .thenAnswer((_) async => const Right(true));

    final result = await usecase();

    expect(result, const Right<Failure, bool>(true));
    verify(() => repository.shouldSync()).called(1);
  });

  test('propagates repository failure', () async {
    when(() => repository.shouldSync())
        .thenAnswer((_) async => const Left(CacheFailure('db fail')));

    final result = await usecase();

    expect(result, const Left<Failure, bool>(CacheFailure('db fail')));
  });
}
