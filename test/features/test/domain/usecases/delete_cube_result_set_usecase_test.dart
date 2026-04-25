import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/delete_cube_result_set_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

void main() {
  late MockTestRepository repository;
  late DeleteCubeResultSetUsecase usecase;

  setUp(() {
    repository = MockTestRepository();
    usecase = DeleteCubeResultSetUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final out = await usecase(null);
    expect(
      out,
      const Left<Failure, bool>(InternalAppError('Params cannot be null')),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when id is empty', () async {
    final out =
        await usecase(const DeleteCubeResultSetUsecaseParam(id: '   '));
    out.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('returns true on success', () async {
    when(() => repository.deleteCubeResultSet(id: any(named: 'id')))
        .thenAnswer((_) async => const Right(true));

    final out =
        await usecase(const DeleteCubeResultSetUsecaseParam(id: 'r1'));

    expect(out, const Right<Failure, bool>(true));
  });

  test('propagates repository failure', () async {
    when(() => repository.deleteCubeResultSet(id: any(named: 'id')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final out =
        await usecase(const DeleteCubeResultSetUsecaseParam(id: 'r1'));

    expect(out, const Left<Failure, bool>(CacheFailure('boom')));
  });
}
