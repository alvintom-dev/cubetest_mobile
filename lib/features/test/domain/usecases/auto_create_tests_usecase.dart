import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/test.dart';
import '../repository/test_repository.dart';

@injectable
class AutoCreateTestsUsecase
    extends UseCase<Either<Failure, List<Test>>, AutoCreateTestsUsecaseParam> {
  const AutoCreateTestsUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, List<Test>>> call(
    AutoCreateTestsUsecaseParam? params,
  ) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.testSetId.trim().isEmpty) {
      return const Left(ValidationFailure('Test set id is required'));
    }
    return repository.autoCreateTestsForTestSet(
      testSetId: params.testSetId,
      concretingDate: params.concretingDate,
    );
  }
}

class AutoCreateTestsUsecaseParam extends Equatable {
  const AutoCreateTestsUsecaseParam({
    required this.testSetId,
    required this.concretingDate,
  });

  final String testSetId;
  final DateTime concretingDate;

  @override
  List<Object?> get props => [testSetId, concretingDate];
}
