import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/test.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/get_tests_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

void main() {
  late MockTestRepository repository;
  late GetTestsUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final tests = [
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

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(
      result,
      const Left<Failure, List<Test>>(
          InternalAppError('Params cannot be null')),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when testSetId is empty', () async {
    final result =
        await usecase(const GetTestsUsecaseParam(testSetId: '   '));
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('returns list from repository on success', () async {
    when(() => repository.getTests(testSetId: any(named: 'testSetId')))
        .thenAnswer((_) async => Right(tests));

    final result =
        await usecase(const GetTestsUsecaseParam(testSetId: 'ts-1'));

    expect(result, Right<Failure, List<Test>>(tests));
    verify(() => repository.getTests(testSetId: 'ts-1')).called(1);
  });

  test('propagates repository failure', () async {
    when(() => repository.getTests(testSetId: any(named: 'testSetId')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result =
        await usecase(const GetTestsUsecaseParam(testSetId: 'ts-1'));

    expect(result, const Left<Failure, List<Test>>(CacheFailure('boom')));
  });
}
