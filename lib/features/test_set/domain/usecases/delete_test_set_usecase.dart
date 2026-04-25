import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/test_set_repository.dart';

@injectable
class DeleteTestSetUsecase
    extends UseCase<Either<Failure, bool>, DeleteTestSetUsecaseParam> {
  const DeleteTestSetUsecase(this.repository);

  final TestSetRepository repository;

  @override
  Future<Either<Failure, bool>> call(DeleteTestSetUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Test set id is required'));
    }
    return repository.deleteTestSet(param: params);
  }
}

class DeleteTestSetUsecaseParam extends Equatable {
  const DeleteTestSetUsecaseParam({
    required this.id,
    required this.isPermanentDelete,
  });

  final String id;
  final bool isPermanentDelete;

  @override
  List<Object?> get props => [id, isPermanentDelete];
}
