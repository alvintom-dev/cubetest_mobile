import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/site.dart';
import '../repository/site_repository.dart';

@injectable
class CreateSiteUsecase extends UseCase<Either<Failure, Site>, CreateSiteUsecaseParam> {
  const CreateSiteUsecase(this.repository);

  final SiteRepository repository;

  @override
  Future<Either<Failure, Site>> call(CreateSiteUsecaseParam? params) async {
    if (params == null) {
      return const Left(InternalAppError('Params cannot be null'));
    }

    if (params.name.trim().isEmpty) {
      return const Left(ValidationFailure('Site name is required'));
    }

    return repository.createSite(param: params);
  }
}

class CreateSiteUsecaseParam extends Equatable {
  const CreateSiteUsecaseParam({
    required this.name,
    this.location,
    this.description,
    this.status = SiteStatus.open,
  });

  final String name;
  final String? location;
  final String? description;
  final SiteStatus status;

  @override
  List<Object?> get props => [name, location, description, status];
}
