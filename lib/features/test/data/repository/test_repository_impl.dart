import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/ports/notification_sync_trigger.dart';
import '../../domain/entities/cube_result_set.dart';
import '../../domain/entities/test.dart';
import '../../domain/repository/test_repository.dart';
import '../../domain/usecases/create_cube_result_set_usecase.dart';
import '../../domain/usecases/create_test_usecase.dart';
import '../../domain/usecases/update_cube_result_set_usecase.dart';
import '../../domain/usecases/update_test_status_usecase.dart';
import '../datasource/test_local_datasource.dart';
import '../models/cube_result_set_model.dart';
import '../models/test_model.dart';

@Injectable(as: TestRepository)
class TestRepositoryImpl implements TestRepository {
  const TestRepositoryImpl(
    this._datasource,
    this._uuid,
    this._notificationSyncTrigger,
  );

  final TestLocalDatasource _datasource;
  final Uuid _uuid;
  final NotificationSyncTrigger _notificationSyncTrigger;

  @override
  Future<Either<Failure, List<Test>>> autoCreateTestsForTestSet({
    required String testSetId,
    required DateTime concretingDate,
  }) async {
    try {
      final now = DateTime.now();
      final created = <TestModel>[];
      for (final type in TestType.values) {
        final existing = await _datasource.findByTestSetAndType(
          testSetId: testSetId,
          type: type.name,
        );
        if (existing != null) continue;
        final model = TestModel(
          id: _uuid.v4(),
          testSetId: testSetId,
          type: type.name,
          dueDate: concretingDate
              .add(Duration(days: type.days))
              .toIso8601String(),
          status: TestStatus.pending.name,
          remark: null,
          completedAt: null,
          createdAt: now.toIso8601String(),
          updatedAt: now.toIso8601String(),
        );
        created.add(await _datasource.createTest(model));
      }
      return Right(created.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Test>> createTest({
    required CreateTestUsecaseParam param,
  }) async {
    try {
      final duplicate = await _datasource.findByTestSetAndType(
        testSetId: param.testSetId,
        type: param.type.name,
      );
      if (duplicate != null) {
        return Left(ValidationFailure(
            '${_typeLabel(param.type)} already exists for this test set'));
      }
      final now = DateTime.now();
      final model = TestModel(
        id: _uuid.v4(),
        testSetId: param.testSetId,
        type: param.type.name,
        dueDate: param.dueDate.toIso8601String(),
        status: TestStatus.pending.name,
        remark: null,
        completedAt: null,
        createdAt: now.toIso8601String(),
        updatedAt: now.toIso8601String(),
      );
      final saved = await _datasource.createTest(model);
      await _notificationSyncTrigger.syncNotifications();
      return Right(saved.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Test>>> getTests({
    required String testSetId,
  }) async {
    try {
      final models = await _datasource.getTests(testSetId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Test>> getTest({required String id}) async {
    try {
      final model = await _datasource.getTestById(id);
      if (model == null) {
        return const Left(CacheFailure('Test not found'));
      }
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Test>> updateTestStatus({
    required UpdateTestStatusUsecaseParam param,
  }) async {
    try {
      final existing = await _datasource.getTestById(param.id);
      if (existing == null) {
        return const Left(CacheFailure('Test not found'));
      }
      if (param.status == TestStatus.passed ||
          param.status == TestStatus.failed) {
        final results = await _datasource.getResults(param.id);
        if (results.isEmpty) {
          return const Left(ValidationFailure(
              'Cannot mark as passed/failed without at least one cube result set'));
        }
      }
      final now = DateTime.now();
      final isCompleted = param.status == TestStatus.passed ||
          param.status == TestStatus.failed ||
          param.status == TestStatus.skipped;
      final updated = TestModel(
        id: existing.id,
        testSetId: existing.testSetId,
        type: existing.type,
        dueDate: existing.dueDate,
        status: param.status.name,
        remark: param.remark ?? existing.remark,
        completedAt: isCompleted
            ? (existing.completedAt ?? now.toIso8601String())
            : null,
        createdAt: existing.createdAt,
        updatedAt: now.toIso8601String(),
      );
      final saved = await _datasource.updateTest(updated);
      return Right(saved.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTest({required String id}) async {
    try {
      await _datasource.deleteTest(id);
      await _notificationSyncTrigger.syncNotifications();
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTestsByTestSet({
    required String testSetId,
  }) async {
    try {
      await _datasource.deleteTestsByTestSet(testSetId);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CubeResultSet>>> getCubeResultSets({
    required String testId,
  }) async {
    try {
      final models = await _datasource.getResults(testId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CubeResultSet>> createCubeResultSet({
    required CreateCubeResultSetUsecaseParam param,
  }) async {
    try {
      final parent = await _datasource.getTestById(param.testId);
      if (parent == null) {
        return const Left(CacheFailure('Test not found'));
      }
      final now = DateTime.now();
      final model = CubeResultSetModel(
        id: _uuid.v4(),
        testId: param.testId,
        load1: param.load1,
        load2: param.load2,
        load3: param.load3,
        strength1: param.strength1,
        strength2: param.strength2,
        strength3: param.strength3,
        notes: param.notes,
        createdAt: now.toIso8601String(),
        updatedAt: now.toIso8601String(),
      );
      final saved = await _datasource.createResult(model);
      return Right(saved.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CubeResultSet>> updateCubeResultSet({
    required UpdateCubeResultSetUsecaseParam param,
  }) async {
    try {
      final existing = await _datasource.getResultById(param.id);
      if (existing == null) {
        return const Left(CacheFailure('Cube result set not found'));
      }
      final now = DateTime.now();
      final updated = CubeResultSetModel(
        id: existing.id,
        testId: existing.testId,
        load1: param.load1,
        load2: param.load2,
        load3: param.load3,
        strength1: param.strength1,
        strength2: param.strength2,
        strength3: param.strength3,
        notes: param.notes,
        createdAt: existing.createdAt,
        updatedAt: now.toIso8601String(),
      );
      final saved = await _datasource.updateResult(updated);
      return Right(saved.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCubeResultSet({
    required String id,
  }) async {
    try {
      await _datasource.deleteResult(id);
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  String _typeLabel(TestType type) {
    switch (type) {
      case TestType.day7:
        return '7-day test';
      case TestType.day14:
        return '14-day test';
      case TestType.day28:
        return '28-day test';
    }
  }
}
