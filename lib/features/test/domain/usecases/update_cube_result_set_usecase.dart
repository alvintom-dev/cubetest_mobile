import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cube_result_set.dart';
import '../repository/test_repository.dart';
import 'create_cube_result_set_usecase.dart';

@injectable
class UpdateCubeResultSetUsecase
    extends UseCase<Either<Failure, CubeResultSet>,
        UpdateCubeResultSetUsecaseParam> {
  const UpdateCubeResultSetUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, CubeResultSet>> call(
    UpdateCubeResultSetUsecaseParam? params,
  ) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Cube result set id is required'));
    }
    final strengthError = validateCubeStrengths(
      params.strength1,
      params.strength2,
      params.strength3,
    );
    if (strengthError != null) return Left(ValidationFailure(strengthError));
    final loadError = validateCubeLoads(
      params.load1,
      params.load2,
      params.load3,
    );
    if (loadError != null) return Left(ValidationFailure(loadError));
    return repository.updateCubeResultSet(param: params);
  }
}

class UpdateCubeResultSetUsecaseParam extends Equatable {
  const UpdateCubeResultSetUsecaseParam({
    required this.id,
    this.load1,
    this.load2,
    this.load3,
    required this.strength1,
    required this.strength2,
    required this.strength3,
    this.notes,
  });

  final String id;
  final double? load1;
  final double? load2;
  final double? load3;
  final double strength1;
  final double strength2;
  final double strength3;
  final String? notes;

  @override
  List<Object?> get props => [
        id,
        load1,
        load2,
        load3,
        strength1,
        strength2,
        strength3,
        notes,
      ];
}
