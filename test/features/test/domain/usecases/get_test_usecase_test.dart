import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/test.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/get_test_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

void main() {
  late MockTestRepository repository;
  late GetTestUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final sample = Test(
    id: '1',
    testSetId: 'ts-1',
    type: TestType.day7,
    dueDate: now,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    repository = MockTestRepository();
    usecase = GetTestUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(
      result,
      const Left<Failure, Test>(InternalAppError('Params cannot be null')),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when id is empty', () async {
    final result = await usecase(const GetTestUsecaseParam(id: '   '));
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('returns test on success', () async {
    when(() => repository.getTest(id: any(named: 'id')))
        .thenAnswer((_) async => Right(sample));

    final result = await usecase(const GetTestUsecaseParam(id: '1'));

    expect(result, Right<Failure, Test>(sample));
  });

  test('propagates repository failure', () async {
    when(() => repository.getTest(id: any(named: 'id')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(const GetTestUsecaseParam(id: '1'));

    expect(result, const Left<Failure, Test>(CacheFailure('boom')));
  });
}
