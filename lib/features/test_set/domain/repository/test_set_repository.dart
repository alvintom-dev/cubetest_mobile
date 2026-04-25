import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/create_test_set_usecase.dart';
import '../../domain/usecases/delete_test_set_usecase.dart';
import '../../domain/usecases/update_test_set_usecase.dart';
import '../entities/test_set.dart';

abstract class TestSetRepository {
  Future<Either<Failure, TestSet>> createTestSet({
    required CreateTestSetUsecaseParam param,
  });

  Future<Either<Failure, List<TestSet>>> getTestSets({
    String? siteId,
    bool? isDeleted,
  });

  Future<Either<Failure, TestSet>> getTestSet({required String id});

  Future<Either<Failure, TestSet>> updateTestSet({
    required UpdateTestSetUsecaseParam param,
  });

  Future<Either<Failure, bool>> deleteTestSet({
    required DeleteTestSetUsecaseParam param,
  });
}
