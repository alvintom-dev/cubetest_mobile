import 'package:bloc_test/bloc_test.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/site/domain/entities/site.dart';
import 'package:cubetest_mobile/features/site/domain/repository/site_repository.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/delete_site_usecase.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/get_archived_sites_usecase.dart';
import 'package:cubetest_mobile/features/site/presentation/blocs/sites_archive_cubit/sites_archive_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

class FakeDeleteSiteUsecaseParam extends Fake implements DeleteSiteUsecaseParam {}

void main() {
  late MockSiteRepository repository;
  late GetArchivedSitesUsecase getArchived;
  late DeleteSiteUsecase deleteSite;

  final now = DateTime(2026, 1, 1);
  final sites = [
    Site(
      id: '1',
      name: 'A',
      createdAt: now,
      updatedAt: now,
      isDeleted: true,
      deletedAt: now,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeDeleteSiteUsecaseParam());
  });

  setUp(() {
    repository = MockSiteRepository();
    getArchived = GetArchivedSitesUsecase(repository);
    deleteSite = DeleteSiteUsecase(repository);
  });

  blocTest<SitesArchiveCubit, SitesArchiveState>(
    'emits [Loading, LoadedData] when archive has items',
    build: () {
      when(() => repository.getArchivedSites())
          .thenAnswer((_) async => Right(sites));
      return SitesArchiveCubit(getArchived, deleteSite);
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [
      const SitesArchiveLoading(),
      SitesArchiveLoadedData(sites),
    ],
  );

  blocTest<SitesArchiveCubit, SitesArchiveState>(
    'emits [Loading, LoadedNoData] when archive is empty',
    build: () {
      when(() => repository.getArchivedSites())
          .thenAnswer((_) async => const Right([]));
      return SitesArchiveCubit(getArchived, deleteSite);
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [
      const SitesArchiveLoading(),
      const SitesArchiveLoadedNoData(),
    ],
  );

  blocTest<SitesArchiveCubit, SitesArchiveState>(
    'emits [Loading, Error] when fetch fails',
    build: () {
      when(() => repository.getArchivedSites())
          .thenAnswer((_) async => const Left(CacheFailure('boom')));
      return SitesArchiveCubit(getArchived, deleteSite);
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [
      const SitesArchiveLoading(),
      isA<SitesArchiveError>(),
    ],
  );
}
