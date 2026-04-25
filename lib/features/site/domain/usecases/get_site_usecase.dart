import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/site.dart';
import '../repository/site_repository.dart';

@injectable
class GetSiteUsecase extends UseCase<Either<Failure, Site>, GetSiteUsecaseParam> {
  const GetSiteUsecase(this.repository);

  final SiteRepository repository;

  @override
  Future<Either<Failure, Site>> call(GetSiteUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Site id is required'));
    }
    return repository.getSite(id: params.id);
  }
}

class GetSiteUsecaseParam extends Equatable {
  const GetSiteUsecaseParam({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
