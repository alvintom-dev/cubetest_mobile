import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test_set/domain/entities/test_set.dart';
import 'package:cubetest_mobile/features/test_set/domain/repository/test_set_repository.dart';
import 'package:cubetest_mobile/features/test_set/domain/usecases/get_test_sets_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestSetRepository extends Mock implements TestSetRepository {}

void main() {
  late MockTestSetRepository repository;
  late GetTestSetsUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final items = [
    TestSet(
      id: '1',
      siteId: 'site-1',
      appointDate: now,
      requiredStrength: 25.0,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  setUp(() {
    repository = MockTestSetRepository();
    usecase = GetTestSetsUsecase(repository);
  });

  test('returns list from repository on success (no params)', () async {
    when(() => repository.getTestSets(
          siteId: any(named: 'siteId'),
          isDeleted: any(named: 'isDeleted'),
        )).thenAnswer((_) async => Right(items));

    final result = await usecase(null);

    expect(result, Right<Failure, List<TestSet>>(items));
  });

  test('passes params through to repository', () async {
    when(() => repository.getTestSets(
          siteId: any(named: 'siteId'),
          isDeleted: any(named: 'isDeleted'),
        )).thenAnswer((_) async => Right(items));

    final result = await usecase(const GetTestSetsUsecaseParam(
      siteId: 'site-1',
      isDeleted: false,
    ));

    expect(result, Right<Failure, List<TestSet>>(items));
    verify(() => repository.getTestSets(siteId: 'site-1', isDeleted: false))
        .called(1);
  });

  test('propagates failure', () async {
    when(() => repository.getTestSets(
          siteId: any(named: 'siteId'),
          isDeleted: any(named: 'isDeleted'),
        )).thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(null);

    expect(result, const Left<Failure, List<TestSet>>(CacheFailure('boom')));
  });
}
