import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/test.dart';
import '../repository/test_repository.dart';

@injectable
class UpdateTestStatusUsecase
    extends UseCase<Either<Failure, Test>, UpdateTestStatusUsecaseParam> {
  const UpdateTestStatusUsecase(this.repository);

  final TestRepository repository;

  @override
  Future<Either<Failure, Test>> call(
    UpdateTestStatusUsecaseParam? params,
  ) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Test id is required'));
    }
    return repository.updateTestStatus(param: params);
  }
}

class UpdateTestStatusUsecaseParam extends Equatable {
  const UpdateTestStatusUsecaseParam({
    required this.id,
    required this.status,
    this.remark,
  });

  final String id;
  final TestStatus status;
  final String? remark;

  @override
  List<Object?> get props => [id, status, remark];
}
