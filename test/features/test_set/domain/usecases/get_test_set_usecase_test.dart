import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test_set/domain/entities/test_set.dart';
import 'package:cubetest_mobile/features/test_set/domain/repository/test_set_repository.dart';
import 'package:cubetest_mobile/features/test_set/domain/usecases/get_test_set_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestSetRepository extends Mock implements TestSetRepository {}

void main() {
  late MockTestSetRepository repository;
  late GetTestSetUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final testSet = TestSet(
    id: '1',
    siteId: 'site-1',
    appointDate: now,
    requiredStrength: 25.0,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    repository = MockTestSetRepository();
    usecase = GetTestSetUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(result,
        const Left<Failure, TestSet>(InternalAppError('Params cannot be null')));
  });

  test('returns ValidationFailure when id is empty', () async {
    final result = await usecase(const GetTestSetUsecaseParam(id: ''));
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
  });

  test('returns test set on success', () async {
    when(() => repository.getTestSet(id: any(named: 'id')))
        .thenAnswer((_) async => Right(testSet));

    final result = await usecase(const GetTestSetUsecaseParam(id: '1'));

    expect(result, Right<Failure, TestSet>(testSet));
  });
}
