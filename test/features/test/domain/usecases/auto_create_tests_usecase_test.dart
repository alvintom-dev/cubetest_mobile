import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/test.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/auto_create_tests_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

void main() {
  late MockTestRepository repository;
  late AutoCreateTestsUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final tests = [
    Test(
      id: '1',
      testSetId: 'ts-1',
      type: TestType.day7,
      dueDate: now.add(const Duration(days: 7)),
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    repository = MockTestRepository();
    usecase = AutoCreateTestsUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(result, const Left<Failure, List<Test>>(InternalAppError('Params cannot be null')));
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when testSetId is empty', () async {
    final result = await usecase(AutoCreateTestsUsecaseParam(testSetId: '   ', concretingDate: now));
    result.fold((failure) => expect(failure, isA<ValidationFailure>()), (_) => fail('expected Left'));
    verifyZeroInteractions(repository);
  });

  test('delegates to repository on success', () async {
    when(
      () => repository.autoCreateTestsForTestSet(
        testSetId: any(named: 'testSetId'),
        concretingDate: any(named: 'concretingDate'),
      ),
    ).thenAnswer((_) async => Right(tests));

    final result = await usecase(AutoCreateTestsUsecaseParam(testSetId: 'ts-1', concretingDate: now));

    expect(result, Right<Failure, List<Test>>(tests));
    verify(() => repository.autoCreateTestsForTestSet(testSetId: 'ts-1', concretingDate: now)).called(1);
  });

  test('propagates repository failure', () async {
    when(
      () => repository.autoCreateTestsForTestSet(
        testSetId: any(named: 'testSetId'),
        concretingDate: any(named: 'concretingDate'),
      ),
    ).thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(AutoCreateTestsUsecaseParam(testSetId: 'ts-1', concretingDate: now));

    expect(result, const Left<Failure, List<Test>>(CacheFailure('boom')));
  });
}
