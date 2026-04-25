import 'package:bloc_test/bloc_test.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/test.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/get_tests_usecase.dart';
import 'package:cubetest_mobile/features/test/presentation/blocs/tests_cubit/tests_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

void main() {
  late MockTestRepository repository;
  late GetTestsUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final items = [
    Test(
      id: '1',
      testSetId: 'ts-1',
      type: TestType.day7,
      dueDate: now,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    repository = MockTestRepository();
    usecase = GetTestsUsecase(repository);
  });

  blocTest<TestsCubit, TestsState>(
    'emits [Loading, LoadedData] when repository returns non-empty list',
    build: () {
      when(() => repository.getTests(testSetId: any(named: 'testSetId')))
          .thenAnswer((_) async => Right(items));
      return TestsCubit(usecase);
    },
    act: (cubit) => cubit.fetch('ts-1'),
    expect: () => [
      const TestsLoading(),
      TestsLoadedData(items),
    ],
  );

  blocTest<TestsCubit, TestsState>(
    'emits [Loading, LoadedNoData] when repository returns empty list',
    build: () {
      when(() => repository.getTests(testSetId: any(named: 'testSetId')))
          .thenAnswer((_) async => const Right([]));
      return TestsCubit(usecase);
    },
    act: (cubit) => cubit.fetch('ts-1'),
    expect: () => [
      const TestsLoading(),
      const TestsLoadedNoData(),
    ],
  );

  blocTest<TestsCubit, TestsState>(
    'emits [Loading, Error] when repository fails',
    build: () {
      when(() => repository.getTests(testSetId: any(named: 'testSetId')))
          .thenAnswer((_) async => const Left(CacheFailure('boom')));
      return TestsCubit(usecase);
    },
    act: (cubit) => cubit.fetch('ts-1'),
    expect: () => [
      const TestsLoading(),
      isA<TestsError>(),
    ],
  );
}
