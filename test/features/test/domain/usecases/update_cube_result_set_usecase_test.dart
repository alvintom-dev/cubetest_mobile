import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/cube_result_set.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/update_cube_result_set_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

class FakeUpdateCubeResultSetUsecaseParam extends Fake
    implements UpdateCubeResultSetUsecaseParam {}

void main() {
  late MockTestRepository repository;
  late UpdateCubeResultSetUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final result = CubeResultSet(
    id: 'r1',
    testId: 't1',
    strength1: 30,
    strength2: 31,
    strength3: 32,
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(FakeUpdateCubeResultSetUsecaseParam());
  });

  setUp(() {
    repository = MockTestRepository();
    usecase = UpdateCubeResultSetUsecase(repository);
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

  test('returns ValidationFailure when id is empty', () async {
    final out = await usecase(const UpdateCubeResultSetUsecaseParam(
      id: '   ',
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

  test('returns ValidationFailure when any strength <= 0', () async {
    final out = await usecase(const UpdateCubeResultSetUsecaseParam(
      id: 'r1',
      strength1: 25,
      strength2: 26,
      strength3: 0,
    ));
    out.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('delegates to repository on success', () async {
    when(() => repository.updateCubeResultSet(param: any(named: 'param')))
        .thenAnswer((_) async => Right(result));

    final out = await usecase(const UpdateCubeResultSetUsecaseParam(
      id: 'r1',
      strength1: 30,
      strength2: 31,
      strength3: 32,
    ));

    expect(out, Right<Failure, CubeResultSet>(result));
  });

  test('propagates repository failure', () async {
    when(() => repository.updateCubeResultSet(param: any(named: 'param')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final out = await usecase(const UpdateCubeResultSetUsecaseParam(
      id: 'r1',
      strength1: 30,
      strength2: 31,
      strength3: 32,
    ));

    expect(out, const Left<Failure, CubeResultSet>(CacheFailure('boom')));
  });
}
