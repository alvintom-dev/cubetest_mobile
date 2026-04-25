import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test_set/domain/repository/test_set_repository.dart';
import 'package:cubetest_mobile/features/test_set/domain/usecases/delete_test_set_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestSetRepository extends Mock implements TestSetRepository {}

class FakeDeleteTestSetUsecaseParam extends Fake
    implements DeleteTestSetUsecaseParam {}

void main() {
  late MockTestSetRepository repository;
  late DeleteTestSetUsecase usecase;

  setUpAll(() {
    registerFallbackValue(FakeDeleteTestSetUsecaseParam());
  });

  setUp(() {
    repository = MockTestSetRepository();
    usecase = DeleteTestSetUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(result,
        const Left<Failure, bool>(InternalAppError('Params cannot be null')));
  });

  test('returns ValidationFailure when id is empty', () async {
    final result = await usecase(
      const DeleteTestSetUsecaseParam(id: '', isPermanentDelete: false),
    );
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
  });

  test('returns true on soft delete success', () async {
    when(() => repository.deleteTestSet(param: any(named: 'param')))
        .thenAnswer((_) async => const Right(true));

    final result = await usecase(
      const DeleteTestSetUsecaseParam(id: '1', isPermanentDelete: false),
    );

    expect(result, const Right<Failure, bool>(true));
  });

  test('returns true on permanent delete success', () async {
    when(() => repository.deleteTestSet(param: any(named: 'param')))
        .thenAnswer((_) async => const Right(true));

    final result = await usecase(
      const DeleteTestSetUsecaseParam(id: '1', isPermanentDelete: true),
    );

    expect(result, const Right<Failure, bool>(true));
  });

  test('propagates failure', () async {
    when(() => repository.deleteTestSet(param: any(named: 'param')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(
      const DeleteTestSetUsecaseParam(id: '1', isPermanentDelete: false),
    );

    expect(result, const Left<Failure, bool>(CacheFailure('boom')));
  });
}
