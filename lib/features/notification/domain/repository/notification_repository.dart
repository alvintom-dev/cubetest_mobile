import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class NotificationRepository {
  Future<Either<Failure, Unit>> syncNotifications();

  Future<Either<Failure, bool>> shouldSync();
}
