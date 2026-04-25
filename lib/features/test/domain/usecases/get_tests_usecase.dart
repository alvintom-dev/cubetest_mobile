import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/test.dart';
import '../repository/test_repository.dart';

@injectable
class GetTestsUsecase
    extends UseCase<Either<Failure, List<Test>>, GetTestsUsecaseParam> {
  const GetTestsUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, List<Test>>> call(
    GetTestsUsecaseParam? params,
  ) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.testSetId.trim().isEmpty) {
      return const Left(ValidationFailure('Test set id is required'));
    }
    return repository.getTests(testSetId: params.testSetId);
  }
}

class GetTestsUsecaseParam extends Equatable {
  const GetTestsUsecaseParam({required this.testSetId});

  final String testSetId;

  @override
  List<Object?> get props => [testSetId];
}
