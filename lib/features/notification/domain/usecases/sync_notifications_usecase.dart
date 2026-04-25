import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/notification_repository.dart';

@injectable
class SyncNotificationsUsecase
    extends NoParamsUseCase<Either<Failure, Unit>> {
  const SyncNotificationsUsecase(this.repository);

  final NotificationRepository repository;

  @override
  Future<Either<Failure, Unit>> call() => repository.syncNotifications();
}
