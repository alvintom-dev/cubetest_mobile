import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/ports/notification_sync_trigger.dart';
import '../../../../core/ports/test_set_test_coordinator.dart';
import '../../domain/entities/test_set.dart';
import '../../domain/repository/test_set_repository.dart';
import '../../domain/usecases/create_test_set_usecase.dart';
import '../../domain/usecases/delete_test_set_usecase.dart';
import '../../domain/usecases/update_test_set_usecase.dart';
import '../datasource/test_set_local_datasource.dart';
import '../models/test_set_model.dart';

@Injectable(as: TestSetRepository)
class TestSetRepositoryImpl implements TestSetRepository {
  const TestSetRepositoryImpl(
    this._localDatasource,
    this._uuid,
    this._testCoordinator,
    this._notificationSyncTrigger,
  );

  final TestSetLocalDatasource _localDatasource;
  final Uuid _uuid;
  final TestSetTestCoordinator _testCoordinator;
  final NotificationSyncTrigger _notificationSyncTrigger;

  @override
  Future<Either<Failure, TestSet>> createTestSet({
    required CreateTestSetUsecaseParam param,
  }) async {
    try {
      final now = DateTime.now();
      final model = TestSetModel(
        id: _uuid.v4(),
        siteId: param.siteId,
        appointDate: param.appointDate.toIso8601String(),
        name: param.name,
        description: param.description,
        requiredStrength: param.requiredStrength,
        status: TestSetStatus.active.name,
        createdAt: now.toIso8601String(),
        updatedAt: now.toIso8601String(),
        deletedAt: null,
        isDeleted: false,
      );
      final saved = await _localDatasource.create(model);
      await _testCoordinator.autoCreateTestsForTestSet(
        testSetId: saved.id,
        concretingDate: param.appointDate,
      );
      await _notificationSyncTrigger.syncNotifications();
      return Right(saved.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TestSet>>> getTestSets({
    String? siteId,
    bool? isDeleted,
  }) async {
    try {
      final models = await _localDatasource.getAll(
        siteId: siteId,
        isDeleted: isDeleted ?? false,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TestSet>> getTestSet({required String id}) async {
    try {
      final model = await _localDatasource.getById(id);
      if (model == null) {
        return const Left(CacheFailure('Test set not found'));
      }
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TestSet>> updateTestSet({
    required UpdateTestSetUsecaseParam param,
  }) async {
    try {
      final existing = await _localDatasource.getById(param.id);
      if (existing == null) {
        return const Left(CacheFailure('Test set not found'));
      }
      // TODO: implement status-transition validation prompts (spec §6)
      // once Test feature exists.
      final updated = TestSetModel(
        id: existing.id,
        siteId: existing.siteId,
        appointDate: param.appointDate.toIso8601String(),
        name: param.name,
        description: param.description,
        requiredStrength: param.requiredStrength,
        status: param.status.name,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        deletedAt: existing.deletedAt,
        isDeleted: existing.isDeleted,
      );
      final saved = await _localDatasource.update(updated);
      await _notificationSyncTrigger.syncNotifications();
      return Right(saved.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTestSet({
    required DeleteTestSetUsecaseParam param,
  }) async {
    try {
      if (param.isPermanentDelete) {
        await _localDatasource.hardDelete(param.id);
        await _testCoordinator.cascadeDeleteTestsForTestSet(
          testSetId: param.id,
        );
      } else {
        await _localDatasource.softDelete(
          param.id,
          deletedAtIso: DateTime.now().toIso8601String(),
        );
      }
      await _notificationSyncTrigger.syncNotifications();
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
