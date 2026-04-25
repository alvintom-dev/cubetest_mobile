import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/notification_repository.dart';

@injectable
class ShouldSyncNotificationsUsecase
    extends NoParamsUseCase<Either<Failure, bool>> {
  const ShouldSyncNotificationsUsecase(this.repository);

  final NotificationRepository repository;

  @override
  Future<Either<Failure, bool>> call() => repository.shouldSync();
}
