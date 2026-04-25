import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test_set/domain/entities/test_set.dart';
import 'package:cubetest_mobile/features/test_set/domain/repository/test_set_repository.dart';
import 'package:cubetest_mobile/features/test_set/domain/usecases/create_test_set_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestSetRepository extends Mock implements TestSetRepository {}

class FakeCreateTestSetUsecaseParam extends Fake
    implements CreateTestSetUsecaseParam {}

void main() {
  late MockTestSetRepository repository;
  late CreateTestSetUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final testSet = TestSet(
    id: 'abc',
    siteId: 'site-1',
    appointDate: now,
    requiredStrength: 25.0,
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateTestSetUsecaseParam());
  });

  setUp(() {
    repository = MockTestSetRepository();
    usecase = CreateTestSetUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(result,
        const Left<Failure, TestSet>(InternalAppError('Params cannot be null')));
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when siteId is empty', () async {
    final result = await usecase(CreateTestSetUsecaseParam(
      siteId: '   ',
      appointDate: now,
      requiredStrength: 25.0,
    ));
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when requiredStrength <= 0', () async {
    final result = await usecase(CreateTestSetUsecaseParam(
      siteId: 'site-1',
      appointDate: now,
      requiredStrength: 0,
    ));
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('delegates to repository on success', () async {
    when(() => repository.createTestSet(param: any(named: 'param')))
        .thenAnswer((_) async => Right(testSet));

    final result = await usecase(CreateTestSetUsecaseParam(
      siteId: 'site-1',
      appointDate: now,
      requiredStrength: 25.0,
    ));

    expect(result, Right<Failure, TestSet>(testSet));
    verify(() => repository.createTestSet(param: any(named: 'param'))).called(1);
  });

  test('propagates repository failure', () async {
    when(() => repository.createTestSet(param: any(named: 'param')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(CreateTestSetUsecaseParam(
      siteId: 'site-1',
      appointDate: now,
      requiredStrength: 25.0,
    ));

    expect(result, const Left<Failure, TestSet>(CacheFailure('boom')));
  });
}
