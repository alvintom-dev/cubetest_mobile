import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/cube_result_set.dart';
import '../entities/test.dart';
import '../usecases/create_cube_result_set_usecase.dart';
import '../usecases/create_test_usecase.dart';
import '../usecases/update_cube_result_set_usecase.dart';
import '../usecases/update_test_status_usecase.dart';

abstract class TestRepository {
  Future<Either<Failure, List<Test>>> autoCreateTestsForTestSet({
    required String testSetId,
    required DateTime concretingDate,
  });

  Future<Either<Failure, Test>> createTest({
    required CreateTestUsecaseParam param,
  });

  Future<Either<Failure, List<Test>>> getTests({required String testSetId});

  Future<Either<Failure, Test>> getTest({required String id});

  Future<Either<Failure, Test>> updateTestStatus({
    required UpdateTestStatusUsecaseParam param,
  });

  Future<Either<Failure, bool>> deleteTest({required String id});

  Future<Either<Failure, bool>> deleteTestsByTestSet({
    required String testSetId,
  });

  Future<Either<Failure, List<CubeResultSet>>> getCubeResultSets({
    required String testId,
  });

  Future<Either<Failure, CubeResultSet>> createCubeResultSet({
    required CreateCubeResultSetUsecaseParam param,
  });

  Future<Either<Failure, CubeResultSet>> updateCubeResultSet({
    required UpdateCubeResultSetUsecaseParam param,
  });

  Future<Either<Failure, bool>> deleteCubeResultSet({required String id});
}
