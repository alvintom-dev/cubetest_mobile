import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/cube_result_set.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/get_cube_result_sets_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

void main() {
  late MockTestRepository repository;
  late GetCubeResultSetsUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final results = [
    CubeResultSet(
      id: 'r1',
      testId: 't1',
      strength1: 25,
      strength2: 26,
      strength3: 27,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    repository = MockTestRepository();
    usecase = GetCubeResultSetsUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final out = await usecase(null);
    expect(
      out,
      const Left<Failure, List<CubeResultSet>>(
          InternalAppError('Params cannot be null')),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when testId is empty', () async {
    final out =
        await usecase(const GetCubeResultSetsUsecaseParam(testId: '   '));
    out.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('returns results on success', () async {
    when(() => repository.getCubeResultSets(testId: any(named: 'testId')))
        .thenAnswer((_) async => Right(results));

    final out =
        await usecase(const GetCubeResultSetsUsecaseParam(testId: 't1'));

    expect(out, Right<Failure, List<CubeResultSet>>(results));
  });

  test('propagates repository failure', () async {
    when(() => repository.getCubeResultSets(testId: any(named: 'testId')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final out =
        await usecase(const GetCubeResultSetsUsecaseParam(testId: 't1'));

    expect(
      out,
      const Left<Failure, List<CubeResultSet>>(CacheFailure('boom')),
    );
  });
}
