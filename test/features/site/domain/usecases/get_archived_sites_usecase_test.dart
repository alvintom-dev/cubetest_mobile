import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/site/domain/entities/site.dart';
import 'package:cubetest_mobile/features/site/domain/repository/site_repository.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/get_archived_sites_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

void main() {
  late MockSiteRepository repository;
  late GetArchivedSitesUsecase usecase;

  setUp(() {
    repository = MockSiteRepository();
    usecase = GetArchivedSitesUsecase(repository);
  });

  final now = DateTime(2026, 1, 1);
  final sites = [
    Site(
      id: '1',
      name: 'Site A',
      createdAt: now,
      updatedAt: now,
      isDeleted: true,
      deletedAt: now,
    ),
  ];

  test('returns archived sites on success', () async {
    when(() => repository.getArchivedSites())
        .thenAnswer((_) async => Right(sites));

    final result = await usecase();

    expect(result, Right<Failure, List<Site>>(sites));
    verify(() => repository.getArchivedSites()).called(1);
  });

  test('propagates failure', () async {
    when(() => repository.getArchivedSites())
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase();

    expect(result, const Left<Failure, List<Site>>(CacheFailure('boom')));
  });
}
