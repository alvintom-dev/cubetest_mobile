import 'package:bloc_test/bloc_test.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/test.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/create_test_usecase.dart';
import 'package:cubetest_mobile/features/test/presentation/blocs/test_form_cubit/test_form_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

class FakeCreateTestUsecaseParam extends Fake
    implements CreateTestUsecaseParam {}

void main() {
  late MockTestRepository repository;
  late CreateTestUsecase createTest;

  final now = DateTime(2026, 1, 1);
  final sample = Test(
    id: '1',
    testSetId: 'ts-1',
    type: TestType.day7,
    dueDate: now,
    createdAt: now,
    updatedAt: now,
  );

  final createParam = CreateTestUsecaseParam(
    testSetId: 'ts-1',
    type: TestType.day7,
    dueDate: now,
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateTestUsecaseParam());
  });

  setUp(() {
    repository = MockTestRepository();
    createTest = CreateTestUsecase(repository);
  });

  blocTest<TestFormCubit, TestFormState>(
    'emits [Submitting, Success] on repository success',
    build: () {
      when(() => repository.createTest(param: any(named: 'param')))
          .thenAnswer((_) async => Right(sample));
      return TestFormCubit(createTest);
    },
    act: (cubit) => cubit.submitCreate(createParam),
    expect: () => [
      const TestFormSubmitting(),
      TestFormSuccess(sample),
    ],
  );

  blocTest<TestFormCubit, TestFormState>(
    'emits [Submitting, ValidationError] when duplicate type exists',
    build: () {
      when(() => repository.createTest(param: any(named: 'param')))
          .thenAnswer(
              (_) async => const Left(ValidationFailure('7-day already')));
      return TestFormCubit(createTest);
    },
    act: (cubit) => cubit.submitCreate(createParam),
    expect: () => [
      const TestFormSubmitting(),
      isA<TestFormValidationError>(),
    ],
  );

  blocTest<TestFormCubit, TestFormState>(
    'emits [Submitting, Error] on repository failure',
    build: () {
      when(() => repository.createTest(param: any(named: 'param')))
          .thenAnswer((_) async => const Left(CacheFailure('boom')));
      return TestFormCubit(createTest);
    },
    act: (cubit) => cubit.submitCreate(createParam),
    expect: () => [
      const TestFormSubmitting(),
      isA<TestFormError>(),
    ],
  );
}
