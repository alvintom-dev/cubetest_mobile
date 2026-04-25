import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/site.dart';
import '../repository/site_repository.dart';

@injectable
class GetArchivedSitesUsecase extends NoParamsUseCase<Either<Failure, List<Site>>> {
  const GetArchivedSitesUsecase(this.repository);

  final SiteRepository repository;

  @override
  Future<Either<Failure, List<Site>>> call() => repository.getArchivedSites();
}
