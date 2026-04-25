import 'package:bloc_test/bloc_test.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test_set/domain/entities/test_set.dart';
import 'package:cubetest_mobile/features/test_set/domain/repository/test_set_repository.dart';
import 'package:cubetest_mobile/features/test_set/domain/usecases/create_test_set_usecase.dart';
import 'package:cubetest_mobile/features/test_set/domain/usecases/update_test_set_usecase.dart';
import 'package:cubetest_mobile/features/test_set/presentation/blocs/test_set_form_cubit/test_set_form_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestSetRepository extends Mock implements TestSetRepository {}

class FakeCreateTestSetUsecaseParam extends Fake
    implements CreateTestSetUsecaseParam {}

class FakeUpdateTestSetUsecaseParam extends Fake
    implements UpdateTestSetUsecaseParam {}

void main() {
  late MockTestSetRepository repository;
  late CreateTestSetUsecase createTestSet;
  late UpdateTestSetUsecase updateTestSet;

  final now = DateTime(2026, 1, 1);
  final testSet = TestSet(
    id: '1',
    siteId: 'site-1',
    appointDate: now,
    requiredStrength: 25.0,
    createdAt: now,
    updatedAt: now,
  );

  final createParam = CreateTestSetUsecaseParam(
    siteId: 'site-1',
    appointDate: now,
    requiredStrength: 25.0,
  );
  final emptySiteCreateParam = CreateTestSetUsecaseParam(
    siteId: '',
    appointDate: now,
    requiredStrength: 25.0,
  );
  final updateParam = UpdateTestSetUsecaseParam(
    id: '1',
    appointDate: now,
    requiredStrength: 25.0,
    status: TestSetStatus.active,
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateTestSetUsecaseParam());
    registerFallbackValue(FakeUpdateTestSetUsecaseParam());
  });

  setUp(() {
    repository = MockTestSetRepository();
    createTestSet = CreateTestSetUsecase(repository);
    updateTestSet = UpdateTestSetUsecase(repository);
  });

  blocTest<TestSetFormCubit, TestSetFormState>(
    'create: emits [Submitting, Success] when repository succeeds',
    build: () {
      when(() => repository.createTestSet(param: any(named: 'param')))
          .thenAnswer((_) async => Right(testSet));
      return TestSetFormCubit(createTestSet, updateTestSet);
    },
    act: (cubit) => cubit.submitCreate(createParam),
    expect: () => [
      const TestSetFormSubmitting(),
      TestSetFormSuccess(testSet),
    ],
  );

  blocTest<TestSetFormCubit, TestSetFormState>(
    'create: emits [Submitting, ValidationError] when siteId is empty',
    build: () => TestSetFormCubit(createTestSet, updateTestSet),
    act: (cubit) => cubit.submitCreate(emptySiteCreateParam),
    expect: () => [
      const TestSetFormSubmitting(),
      isA<TestSetFormValidationError>(),
    ],
  );

  blocTest<TestSetFormCubit, TestSetFormState>(
    'create: emits [Submitting, Error] when repository fails',
    build: () {
      when(() => repository.createTestSet(param: any(named: 'param')))
          .thenAnswer((_) async => const Left(CacheFailure('boom')));
      return TestSetFormCubit(createTestSet, updateTestSet);
    },
    act: (cubit) => cubit.submitCreate(createParam),
    expect: () => [
      const TestSetFormSubmitting(),
      isA<TestSetFormError>(),
    ],
  );

  blocTest<TestSetFormCubit, TestSetFormState>(
    'update: emits [Submitting, Success] on success',
    build: () {
      when(() => repository.updateTestSet(param: any(named: 'param')))
          .thenAnswer((_) async => Right(testSet));
      return TestSetFormCubit(createTestSet, updateTestSet);
    },
    act: (cubit) => cubit.submitUpdate(updateParam),
    expect: () => [
      const TestSetFormSubmitting(),
      TestSetFormSuccess(testSet),
    ],
  );
}
