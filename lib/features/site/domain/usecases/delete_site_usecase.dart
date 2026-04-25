import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/site_repository.dart';

@injectable
class DeleteSiteUsecase extends UseCase<Either<Failure, bool>, DeleteSiteUsecaseParam> {
  const DeleteSiteUsecase(this.repository);

  final SiteRepository repository;

  @override
  Future<Either<Failure, bool>> call(DeleteSiteUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Site id is required'));
    }
    return repository.deleteSite(param: params);
  }
}

class DeleteSiteUsecaseParam extends Equatable {
  const DeleteSiteUsecaseParam({
    required this.id,
    required this.isPermanentDelete,
  });

  final String id;
  final bool isPermanentDelete;

  @override
  List<Object?> get props => [id, isPermanentDelete];
}
