import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/test.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/create_test_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

class FakeCreateTestUsecaseParam extends Fake
    implements CreateTestUsecaseParam {}

void main() {
  late MockTestRepository repository;
  late CreateTestUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final sample = Test(
    id: '1',
    testSetId: 'ts-1',
    type: TestType.day7,
    dueDate: now.add(const Duration(days: 7)),
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateTestUsecaseParam());
  });

  setUp(() {
    repository = MockTestRepository();
    usecase = CreateTestUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(
      result,
      const Left<Failure, Test>(InternalAppError('Params cannot be null')),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when testSetId is empty', () async {
    final result = await usecase(CreateTestUsecaseParam(
      testSetId: '   ',
      type: TestType.day7,
      dueDate: now,
    ));
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('delegates to repository on success', () async {
    when(() => repository.createTest(param: any(named: 'param')))
        .thenAnswer((_) async => Right(sample));

    final result = await usecase(CreateTestUsecaseParam(
      testSetId: 'ts-1',
      type: TestType.day7,
      dueDate: now,
    ));

    expect(result, Right<Failure, Test>(sample));
    verify(() => repository.createTest(param: any(named: 'param'))).called(1);
  });

  test('propagates repository failure', () async {
    when(() => repository.createTest(param: any(named: 'param')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(CreateTestUsecaseParam(
      testSetId: 'ts-1',
      type: TestType.day7,
      dueDate: now,
    ));

    expect(result, const Left<Failure, Test>(CacheFailure('boom')));
  });
}
