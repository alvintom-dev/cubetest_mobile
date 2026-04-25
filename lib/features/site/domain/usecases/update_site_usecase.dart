import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/site.dart';
import '../repository/site_repository.dart';

@injectable
class UpdateSiteUsecase extends UseCase<Either<Failure, Site>, UpdateSiteUsecaseParam> {
  const UpdateSiteUsecase(this.repository);

  final SiteRepository repository;

  @override
  Future<Either<Failure, Site>> call(UpdateSiteUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }
    if (params.id.trim().isEmpty) {
      return const Left(ValidationFailure('Site id is required'));
    }
    if (params.name.trim().isEmpty) {
      return const Left(ValidationFailure('Site name is required'));
    }
    return repository.updateSite(param: params);
  }
}

class UpdateSiteUsecaseParam extends Equatable {
  const UpdateSiteUsecaseParam({
    required this.id,
    required this.name,
    this.location,
    this.description,
    required this.status,
  });

  final String id;
  final String name;
  final String? location;
  final String? description;
  final SiteStatus status;

  @override
  List<Object?> get props => [id, name, location, description, status];
}
