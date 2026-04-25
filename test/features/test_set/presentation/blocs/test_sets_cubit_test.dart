import 'package:bloc_test/bloc_test.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/core/ports/test_progress_port.dart';
import 'package:cubetest_mobile/core/ports/test_set_progress.dart';
import 'package:cubetest_mobile/features/test_set/domain/entities/test_set.dart';
import 'package:cubetest_mobile/features/test_set/domain/repository/test_set_repository.dart';
import 'package:cubetest_mobile/features/test_set/domain/usecases/get_test_sets_usecase.dart';
import 'package:cubetest_mobile/features/test_set/presentation/blocs/test_sets_cubit/test_sets_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestSetRepository extends Mock implements TestSetRepository {}

class MockTestProgressPort extends Mock implements TestProgressPort {}

void main() {
  late MockTestSetRepository repository;
  late MockTestProgressPort progressPort;
  late GetTestSetsUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final items = [
    TestSet(
      id: '1',
      siteId: 'site-1',
      appointDate: now,
      requiredStrength: 25.0,
      createdAt: now,
      updatedAt: now,
    ),
    TestSet(
      id: '2',
      siteId: 'site-1',
      appointDate: now,
      requiredStrength: 25.0,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    repository = MockTestSetRepository();
    progressPort = MockTestProgressPort();
    usecase = GetTestSetsUsecase(repository);
  });

  blocTest<TestSetsCubit, TestSetsState>(
    'emits [Loading, LoadedData] with progressBySetId when repository returns non-empty list',
    build: () {
      when(() => repository.getTestSets(
            siteId: any(named: 'siteId'),
            isDeleted: any(named: 'isDeleted'),
          )).thenAnswer((_) async => Right(items));
      when(() => progressPort.getProgressBulk(any())).thenAnswer(
        (_) async => {
          '1': const TestSetProgress(completed: 2, total: 3),
          '2': const TestSetProgress(completed: 0, total: 3),
        },
      );
      return TestSetsCubit(usecase, progressPort);
    },
    act: (cubit) => cubit.fetch('site-1'),
    expect: () => [
      const TestSetsLoading(),
      TestSetsLoadedData(items, const {
        '1': TestSetProgress(completed: 2, total: 3),
        '2': TestSetProgress(completed: 0, total: 3),
      }),
    ],
  );

  blocTest<TestSetsCubit, TestSetsState>(
    'degrades to empty progressBySetId when progress port throws',
    build: () {
      when(() => repository.getTestSets(
            siteId: any(named: 'siteId'),
            isDeleted: any(named: 'isDeleted'),
          )).thenAnswer((_) async => Right(items));
      when(() => progressPort.getProgressBulk(any()))
          .thenThrow(Exception('boom'));
      return TestSetsCubit(usecase, progressPort);
    },
    act: (cubit) => cubit.fetch('site-1'),
    expect: () => [
      const TestSetsLoading(),
      TestSetsLoadedData(items, const {}),
    ],
  );

  blocTest<TestSetsCubit, TestSetsState>(
    'emits [Loading, LoadedNoData] when repository returns empty list',
    build: () {
      when(() => repository.getTestSets(
            siteId: any(named: 'siteId'),
            isDeleted: any(named: 'isDeleted'),
          )).thenAnswer((_) async => const Right([]));
      return TestSetsCubit(usecase, progressPort);
    },
    act: (cubit) => cubit.fetch('site-1'),
    expect: () => [
      const TestSetsLoading(),
      const TestSetsLoadedNoData(),
    ],
    verify: (_) {
      verifyNever(() => progressPort.getProgressBulk(any()));
    },
  );

  blocTest<TestSetsCubit, TestSetsState>(
    'emits [Loading, Error] when repository fails',
    build: () {
      when(() => repository.getTestSets(
            siteId: any(named: 'siteId'),
            isDeleted: any(named: 'isDeleted'),
          )).thenAnswer((_) async => const Left(CacheFailure('boom')));
      return TestSetsCubit(usecase, progressPort);
    },
    act: (cubit) => cubit.fetch('site-1'),
    expect: () => [
      const TestSetsLoading(),
      isA<TestSetsError>(),
    ],
  );
}
