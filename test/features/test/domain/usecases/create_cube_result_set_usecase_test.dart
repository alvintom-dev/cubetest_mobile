import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/cube_result_set.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/create_cube_result_set_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

class FakeCreateCubeResultSetUsecaseParam extends Fake
    implements CreateCubeResultSetUsecaseParam {}

void main() {
  late MockTestRepository repository;
  late CreateCubeResultSetUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final result = CubeResultSet(
    id: 'r1',
    testId: 't1',
    strength1: 25,
    strength2: 26,
    strength3: 27,
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateCubeResultSetUsecaseParam());
  });

  setUp(() {
    repository = MockTestRepository();
    usecase = CreateCubeResultSetUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final out = await usecase(null);
    expect(
      out,
      const Left<Failure, CubeResultSet>(
          InternalAppError('Params cannot be null')),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when testId is empty', () async {
    final out = await usecase(const CreateCubeResultSetUsecaseParam(
      testId: '   ',
      strength1: 25,
      strength2: 26,
      strength3: 27,
    ));
    out.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when any strength is <= 0', () async {
    final out = await usecase(const CreateCubeResultSetUsecaseParam(
      testId: 't1',
      strength1: 25,
      strength2: 0,
      strength3: 27,
    ));
    out.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when a provided load is <= 0', () async {
    final out = await usecase(const CreateCubeResultSetUsecaseParam(
      testId: 't1',
      strength1: 25,
      strength2: 26,
      strength3: 27,
      load1: 0,
    ));
    out.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('delegates to repository on success', () async {
    when(() => repository.createCubeResultSet(param: any(named: 'param')))
        .thenAnswer((_) async => Right(result));

    final out = await usecase(const CreateCubeResultSetUsecaseParam(
      testId: 't1',
      strength1: 25,
      strength2: 26,
      strength3: 27,
    ));

    expect(out, Right<Failure, CubeResultSet>(result));
  });

  test('propagates repository failure', () async {
    when(() => repository.createCubeResultSet(param: any(named: 'param')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final out = await usecase(const CreateCubeResultSetUsecaseParam(
      testId: 't1',
      strength1: 25,
      strength2: 26,
      strength3: 27,
    ));

    expect(out, const Left<Failure, CubeResultSet>(CacheFailure('boom')));
  });
}
