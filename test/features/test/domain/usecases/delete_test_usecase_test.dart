import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/delete_test_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

void main() {
  late MockTestRepository repository;
  late DeleteTestUsecase usecase;

  setUp(() {
    repository = MockTestRepository();
    usecase = DeleteTestUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(
      result,
      const Left<Failure, bool>(InternalAppError('Params cannot be null')),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when id is empty', () async {
    final result = await usecase(const DeleteTestUsecaseParam(id: '   '));
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('returns true on success', () async {
    when(() => repository.deleteTest(id: any(named: 'id')))
        .thenAnswer((_) async => const Right(true));

    final result = await usecase(const DeleteTestUsecaseParam(id: '1'));

    expect(result, const Right<Failure, bool>(true));
  });

  test('propagates repository failure', () async {
    when(() => repository.deleteTest(id: any(named: 'id')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(const DeleteTestUsecaseParam(id: '1'));

    expect(result, const Left<Failure, bool>(CacheFailure('boom')));
  });
}
