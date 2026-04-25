import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cube_result_set.dart';
import '../repository/test_repository.dart';

@injectable
class GetCubeResultSetsUsecase
    extends UseCase<Either<Failure, List<CubeResultSet>>,
        GetCubeResultSetsUsecaseParam> {
  const GetCubeResultSetsUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, List<CubeResultSet>>> call(
    GetCubeResultSetsUsecaseParam? params,
  ) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.testId.trim().isEmpty) {
      return const Left(ValidationFailure('Test id is required'));
    }
    return repository.getCubeResultSets(testId: params.testId);
  }
}

class GetCubeResultSetsUsecaseParam extends Equatable {
  const GetCubeResultSetsUsecaseParam({required this.testId});

  final String testId;

  @override
  List<Object?> get props => [testId];
}
