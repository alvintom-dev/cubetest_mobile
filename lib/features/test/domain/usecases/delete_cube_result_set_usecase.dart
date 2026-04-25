import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/test_repository.dart';

@injectable
class DeleteCubeResultSetUsecase
    extends UseCase<Either<Failure, bool>, DeleteCubeResultSetUsecaseParam> {
  const DeleteCubeResultSetUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, bool>> call(
    DeleteCubeResultSetUsecaseParam? params,
  ) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Cube result set id is required'));
    }
    return repository.deleteCubeResultSet(id: params.id);
  }
}

class DeleteCubeResultSetUsecaseParam extends Equatable {
  const DeleteCubeResultSetUsecaseParam({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
