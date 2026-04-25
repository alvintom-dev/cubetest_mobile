import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/create_site_usecase.dart';
import '../../domain/usecases/delete_site_usecase.dart';
import '../../domain/usecases/update_site_usecase.dart';
import '../entities/site.dart';

abstract class SiteRepository {
  Future<Either<Failure, Site>> createSite({required CreateSiteUsecaseParam param});

  Future<Either<Failure, List<Site>>> getSites();

  Future<Either<Failure, List<Site>>> getArchivedSites();

  Future<Either<Failure, Site>> getSite({required String id});

  Future<Either<Failure, Site>> updateSite({required UpdateSiteUsecaseParam param});

  Future<Either<Failure, bool>> deleteSite({required DeleteSiteUsecaseParam param});
}
