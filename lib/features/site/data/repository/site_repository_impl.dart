import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/ports/site_test_set_counter.dart';
import '../../domain/entities/site.dart';
import '../../domain/repository/site_repository.dart';
import '../../domain/usecases/create_site_usecase.dart';
import '../../domain/usecases/delete_site_usecase.dart';
import '../../domain/usecases/update_site_usecase.dart';
import '../datasource/site_local_datasource.dart';
import '../models/site_model.dart';

@Injectable(as: SiteRepository)
class SiteRepositoryImpl implements SiteRepository {
  const SiteRepositoryImpl(this._localDatasource, this._uuid, this._counter);

  final SiteLocalDatasource _localDatasource;
  final Uuid _uuid;
  final SiteTestSetCounter _counter;

  @override
  Future<Either<Failure, Site>> createSite({
    required CreateSiteUsecaseParam param,
  }) async {
    try {
      final now = DateTime.now();
      final model = SiteModel(
        id: _uuid.v4(),
        name: param.name.trim(),
        location: param.location,
        description: param.description,
        status: param.status.name,
        createdAt: now.toIso8601String(),
        updatedAt: now.toIso8601String(),
        deletedAt: null,
        isDeleted: false,
      );
      final saved = await _localDatasource.create(model);
      return Right(await _toEntityWithTestSets(saved));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Site>>> getSites() async {
    try {
      final models = await _localDatasource.getAll();
      final sites = await Future.wait(models.map(_toEntityWithTestSets));
      return Right(sites);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Site>>> getArchivedSites() async {
    try {
      final models = await _localDatasource.getArchived();
      final sites = await Future.wait(models.map(_toEntityWithTestSets));
      return Right(sites);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Site>> getSite({required String id}) async {
    try {
      final model = await _localDatasource.getById(id);
      if (model == null) {
        return const Left(CacheFailure('Site not found'));
      }
      return Right(await _toEntityWithTestSets(model));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Site>> updateSite({
    required UpdateSiteUsecaseParam param,
  }) async {
    try {
      final existing = await _localDatasource.getById(param.id);
      if (existing == null) {
        return const Left(CacheFailure('Site not found'));
      }
      final updated = SiteModel(
        id: existing.id,
        name: param.name.trim(),
        location: param.location,
        description: param.description,
        status: param.status.name,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        deletedAt: existing.deletedAt,
        isDeleted: existing.isDeleted,
      );
      final saved = await _localDatasource.update(updated);
      return Right(await _toEntityWithTestSets(saved));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSite({
    required DeleteSiteUsecaseParam param,
  }) async {
    try {
      if (param.isPermanentDelete) {
        await _localDatasource.hardDelete(param.id);
      } else {
        await _localDatasource.softDelete(
          param.id,
          deletedAtIso: DateTime.now().toIso8601String(),
        );
      }
      // TODO: cascade-delete related test sets & tests when those features are implemented.
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<Site> _toEntityWithTestSets(SiteModel model) async {
    final count = await _counter.countActiveForSite(model.id);
    return model.toEntity().copyWith(testSets: count);
  }
}
