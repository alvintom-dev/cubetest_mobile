import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/test.dart';
import '../repository/test_repository.dart';

@injectable
class CreateTestUsecase
    extends UseCase<Either<Failure, Test>, CreateTestUsecaseParam> {
  const CreateTestUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, Test>> call(CreateTestUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.testSetId.trim().isEmpty) {
      return const Left(ValidationFailure('Test set id is required'));
    }
    return repository.createTest(param: params);
  }
}

class CreateTestUsecaseParam extends Equatable {
  const CreateTestUsecaseParam({
    required this.testSetId,
    required this.type,
    required this.dueDate,
  });

  final String testSetId;
  final TestType type;
  final DateTime dueDate;

  @override
  List<Object?> get props => [testSetId, type, dueDate];
}
