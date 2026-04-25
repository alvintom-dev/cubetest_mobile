import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/test_set.dart';
import '../repository/test_set_repository.dart';

@injectable
class CreateTestSetUsecase
    extends UseCase<Either<Failure, TestSet>, CreateTestSetUsecaseParam> {
  const CreateTestSetUsecase(this.repository);

  final TestSetRepository repository;

  @override
  Future<Either<Failure, TestSet>> call(
      CreateTestSetUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.siteId.trim().isEmpty) {
      return const Left(ValidationFailure('Site id is required'));
    }
    if (params.requiredStrength <= 0) {
      return const Left(
          ValidationFailure('Required strength must be greater than 0'));
    }
    return repository.createTestSet(param: params);
  }
}

class CreateTestSetUsecaseParam extends Equatable {
  const CreateTestSetUsecaseParam({
    required this.siteId,
    required this.appointDate,
    required this.requiredStrength,
    this.name,
    this.description,
  });

  final String siteId;
  final DateTime appointDate;
  final double requiredStrength;
  final String? name;
  final String? description;

  @override
  List<Object?> get props =>
      [siteId, appointDate, requiredStrength, name, description];
}
