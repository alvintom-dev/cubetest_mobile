import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/test_repository.dart';

@injectable
class DeleteTestsByTestSetUsecase
    extends UseCase<Either<Failure, bool>, DeleteTestsByTestSetUsecaseParam> {
  const DeleteTestsByTestSetUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, bool>> call(
    DeleteTestsByTestSetUsecaseParam? params,
  ) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.testSetId.trim().isEmpty) {
      return const Left(ValidationFailure('Test set id is required'));
    }
    return repository.deleteTestsByTestSet(testSetId: params.testSetId);
  }
}

class DeleteTestsByTestSetUsecaseParam extends Equatable {
  const DeleteTestsByTestSetUsecaseParam({required this.testSetId});

  final String testSetId;

  @override
  List<Object?> get props => [testSetId];
}
