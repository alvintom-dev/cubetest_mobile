import 'package:bloc_test/bloc_test.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/core/ports/test_progress_port.dart';
import 'package:cubetest_mobile/core/ports/test_set_progress.dart';
import 'package:cubetest_mobile/features/test_set/domain/entities/test_set.dart';
import 'package:cubetest_mobile/features/test_set/domain/repository/test_set_repository.dart';
import 'package:cubetest_mobile/features/test_set/domain/usecases/delete_test_set_usecase.dart';
import 'package:cubetest_mobile/features/test_set/domain/usecases/get_test_set_usecase.dart';
import 'package:cubetest_mobile/features/test_set/presentation/blocs/test_set_detail_cubit/test_set_detail_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestSetRepository extends Mock implements TestSetRepository {}

class MockTestProgressPort extends Mock implements TestProgressPort {}

class FakeDeleteTestSetUsecaseParam extends Fake
    implements DeleteTestSetUsecaseParam {}

void main() {
  late MockTestSetRepository repository;
  late MockTestProgressPort progressPort;
  late GetTestSetUsecase getTestSet;
  late DeleteTestSetUsecase deleteTestSet;

  final now = DateTime(2026, 1, 1);
  final testSet = TestSet(
    id: '1',
    siteId: 'site-1',
    appointDate: now,
    requiredStrength: 25.0,
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(FakeDeleteTestSetUsecaseParam());
  });

  setUp(() {
    repository = MockTestSetRepository();
    progressPort = MockTestProgressPort();
    getTestSet = GetTestSetUsecase(repository);
    deleteTestSet = DeleteTestSetUsecase(repository);
  });

  blocTest<TestSetDetailCubit, TestSetDetailState>(
    'emits [Loading, Loaded] with progress on success',
    build: () {
      when(() => repository.getTestSet(id: any(named: 'id')))
          .thenAnswer((_) async => Right(testSet));
      when(() => progressPort.getProgress('1')).thenAnswer(
        (_) async => const TestSetProgress(completed: 2, total: 3),
      );
      return TestSetDetailCubit(getTestSet, deleteTestSet, progressPort);
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      const TestSetDetailLoading(),
      TestSetDetailLoaded(
        testSet,
        const TestSetProgress(completed: 2, total: 3),
      ),
    ],
  );

  blocTest<TestSetDetailCubit, TestSetDetailState>(
    'falls back to empty progress when progress port throws',
    build: () {
      when(() => repository.getTestSet(id: any(named: 'id')))
          .thenAnswer((_) async => Right(testSet));
      when(() => progressPort.getProgress('1')).thenThrow(Exception('boom'));
      return TestSetDetailCubit(getTestSet, deleteTestSet, progressPort);
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      const TestSetDetailLoading(),
      TestSetDetailLoaded(testSet, TestSetProgress.empty),
    ],
  );

  blocTest<TestSetDetailCubit, TestSetDetailState>(
    'emits [Loading, Error] on failure',
    build: () {
      when(() => repository.getTestSet(id: any(named: 'id')))
          .thenAnswer((_) async => const Left(CacheFailure('boom')));
      return TestSetDetailCubit(getTestSet, deleteTestSet, progressPort);
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      const TestSetDetailLoading(),
      isA<TestSetDetailError>(),
    ],
    verify: (_) {
      verifyNever(() => progressPort.getProgress(any()));
    },
  );

  blocTest<TestSetDetailCubit, TestSetDetailState>(
    'emits [Deleted] after successful soft delete',
    build: () {
      when(() => repository.deleteTestSet(param: any(named: 'param')))
          .thenAnswer((_) async => const Right(true));
      return TestSetDetailCubit(getTestSet, deleteTestSet, progressPort);
    },
    act: (cubit) => cubit.softDelete('1'),
    expect: () => [
      const TestSetDetailDeleted(),
    ],
  );
}
