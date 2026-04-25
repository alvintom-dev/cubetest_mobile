import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cube_result_set.dart';
import '../repository/test_repository.dart';

@injectable
class CreateCubeResultSetUsecase
    extends UseCase<Either<Failure, CubeResultSet>,
        CreateCubeResultSetUsecaseParam> {
  const CreateCubeResultSetUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, CubeResultSet>> call(
    CreateCubeResultSetUsecaseParam? params,
  ) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.testId.trim().isEmpty) {
      return const Left(ValidationFailure('Test id is required'));
    }
    final strengthError = validateCubeStrengths(
      params.strength1,
      params.strength2,
      params.strength3,
    );
    if (strengthError != null) return Left(ValidationFailure(strengthError));
    final loadError =
        validateCubeLoads(params.load1, params.load2, params.load3);
    if (loadError != null) return Left(ValidationFailure(loadError));
    return repository.createCubeResultSet(param: params);
  }
}

String? validateCubeStrengths(double s1, double s2, double s3) {
  if (s1 <= 0 || s2 <= 0 || s3 <= 0) {
    return 'All three strengths must be greater than 0';
  }
  return null;
}

String? validateCubeLoads(double? l1, double? l2, double? l3) {
  for (final value in [l1, l2, l3]) {
    if (value != null && value <= 0) {
      return 'Loads must be greater than 0 when provided';
    }
  }
  return null;
}

class CreateCubeResultSetUsecaseParam extends Equatable {
  const CreateCubeResultSetUsecaseParam({
    required this.testId,
    this.load1,
    this.load2,
    this.load3,
    required this.strength1,
    required this.strength2,
    required this.strength3,
    this.notes,
  });

  final String testId;
  final double? load1;
  final double? load2;
  final double? load3;
  final double strength1;
  final double strength2;
  final double strength3;
  final String? notes;

  @override
  List<Object?> get props => [
        testId,
        load1,
        load2,
        load3,
        strength1,
        strength2,
        strength3,
        notes,
      ];
}
