import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/test_repository.dart';

@injectable
class DeleteTestUsecase
    extends UseCase<Either<Failure, bool>, DeleteTestUsecaseParam> {
  const DeleteTestUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, bool>> call(DeleteTestUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Test id is required'));
    }
    return repository.deleteTest(id: params.id);
  }
}

class DeleteTestUsecaseParam extends Equatable {
  const DeleteTestUsecaseParam({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
