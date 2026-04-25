import 'package:bloc_test/bloc_test.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/cube_result_set.dart';
import 'package:cubetest_mobile/features/test/domain/entities/test.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/create_cube_result_set_usecase.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/delete_cube_result_set_usecase.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/delete_test_usecase.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/get_cube_result_sets_usecase.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/get_test_usecase.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/update_cube_result_set_usecase.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/update_test_status_usecase.dart';
import 'package:cubetest_mobile/features/test/presentation/blocs/test_detail_cubit/test_detail_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

class FakeUpdateTestStatusUsecaseParam extends Fake
    implements UpdateTestStatusUsecaseParam {}

class FakeDeleteTestUsecaseParam extends Fake
    implements DeleteTestUsecaseParam {}

void main() {
  late MockTestRepository repository;
  late GetTestUsecase getTest;
  late GetCubeResultSetsUsecase getResults;
  late UpdateTestStatusUsecase updateStatus;
  late DeleteTestUsecase deleteTest;
  late CreateCubeResultSetUsecase createResult;
  late UpdateCubeResultSetUsecase updateResult;
  late DeleteCubeResultSetUsecase deleteResult;

  final now = DateTime(2026, 1, 1);
  final sample = Test(
    id: '1',
    testSetId: 'ts-1',
    type: TestType.day7,
    dueDate: now,
    createdAt: now,
    updatedAt: now,
  );
  final results = <CubeResultSet>[];

  setUpAll(() {
    registerFallbackValue(FakeUpdateTestStatusUsecaseParam());
    registerFallbackValue(FakeDeleteTestUsecaseParam());
  });

  setUp(() {
    repository = MockTestRepository();
    getTest = GetTestUsecase(repository);
    getResults = GetCubeResultSetsUsecase(repository);
    updateStatus = UpdateTestStatusUsecase(repository);
    deleteTest = DeleteTestUsecase(repository);
    createResult = CreateCubeResultSetUsecase(repository);
    updateResult = UpdateCubeResultSetUsecase(repository);
    deleteResult = DeleteCubeResultSetUsecase(repository);
  });

  TestDetailCubit buildCubit() => TestDetailCubit(
        getTest,
        getResults,
        updateStatus,
        deleteTest,
        createResult,
        updateResult,
        deleteResult,
      );

  blocTest<TestDetailCubit, TestDetailState>(
    'load emits [Loading, Loaded] on success',
    build: () {
      when(() => repository.getTest(id: any(named: 'id')))
          .thenAnswer((_) async => Right(sample));
      when(() => repository.getCubeResultSets(
            testId: any(named: 'testId'),
          )).thenAnswer((_) async => Right(results));
      return buildCubit();
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      const TestDetailLoading(),
      TestDetailLoaded(test: sample, cubeResultSets: results),
    ],
  );

  blocTest<TestDetailCubit, TestDetailState>(
    'load emits [Loading, Error] when getTest fails',
    build: () {
      when(() => repository.getTest(id: any(named: 'id')))
          .thenAnswer((_) async => const Left(CacheFailure('boom')));
      return buildCubit();
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      const TestDetailLoading(),
      isA<TestDetailError>(),
    ],
  );

  blocTest<TestDetailCubit, TestDetailState>(
    'deleteTest emits [Deleted] on success',
    build: () {
      when(() => repository.getTest(id: any(named: 'id')))
          .thenAnswer((_) async => Right(sample));
      when(() => repository.getCubeResultSets(
            testId: any(named: 'testId'),
          )).thenAnswer((_) async => Right(results));
      when(() => repository.deleteTest(id: any(named: 'id')))
          .thenAnswer((_) async => const Right(true));
      return buildCubit();
    },
    act: (cubit) async {
      await cubit.load('1');
      await cubit.deleteTest();
    },
    expect: () => [
      const TestDetailLoading(),
      TestDetailLoaded(test: sample, cubeResultSets: results),
      const TestDetailDeleted(),
    ],
  );
}
