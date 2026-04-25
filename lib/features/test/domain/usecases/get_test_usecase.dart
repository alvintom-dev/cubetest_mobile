import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/test.dart';
import '../repository/test_repository.dart';

@injectable
class GetTestUsecase
    extends UseCase<Either<Failure, Test>, GetTestUsecaseParam> {
  const GetTestUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, Test>> call(GetTestUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Test id is required'));
    }
    return repository.getTest(id: params.id);
  }
}

class GetTestUsecaseParam extends Equatable {
  const GetTestUsecaseParam({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
