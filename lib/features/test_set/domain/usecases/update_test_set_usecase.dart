import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/test_set.dart';
import '../repository/test_set_repository.dart';

@injectable
class UpdateTestSetUsecase
    extends UseCase<Either<Failure, TestSet>, UpdateTestSetUsecaseParam> {
  const UpdateTestSetUsecase(this.repository);

  final TestSetRepository repository;

  @override
  Future<Either<Failure, TestSet>> call(
      UpdateTestSetUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Test set id is required'));
    }
    if (params.requiredStrength <= 0) {
      return const Left(
          ValidationFailure('Required strength must be greater than 0'));
    }
    return repository.updateTestSet(param: params);
  }
}

class UpdateTestSetUsecaseParam extends Equatable {
  const UpdateTestSetUsecaseParam({
    required this.id,
    required this.appointDate,
    required this.requiredStrength,
    required this.status,
    this.name,
    this.description,
  });

  final String id;
  final DateTime appointDate;
  final double requiredStrength;
  final TestSetStatus status;
  final String? name;
  final String? description;

  @override
  List<Object?> get props =>
      [id, appointDate, requiredStrength, status, name, description];
}
