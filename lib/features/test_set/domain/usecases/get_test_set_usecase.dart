import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/test_set.dart';
import '../repository/test_set_repository.dart';

@injectable
class GetTestSetUsecase
    extends UseCase<Either<Failure, TestSet>, GetTestSetUsecaseParam> {
  const GetTestSetUsecase(this.repository);

  final TestSetRepository repository;

  @override
  Future<Either<Failure, TestSet>> call(GetTestSetUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Test set id is required'));
    }
    return repository.getTestSet(id: params.id);
  }
}

class GetTestSetUsecaseParam extends Equatable {
  const GetTestSetUsecaseParam({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
