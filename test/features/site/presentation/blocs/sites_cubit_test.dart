import 'package:bloc_test/bloc_test.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/site/domain/entities/site.dart';
import 'package:cubetest_mobile/features/site/domain/repository/site_repository.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/get_sites_usecase.dart';
import 'package:cubetest_mobile/features/site/presentation/blocs/sites_cubit/sites_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

void main() {
  late MockSiteRepository repository;
  late GetSitesUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final sites = [
    Site(id: '1', name: 'A', createdAt: now, updatedAt: now),
  ];

  setUp(() {
    repository = MockSiteRepository();
    usecase = GetSitesUsecase(repository);
  });

  blocTest<SitesCubit, SitesState>(
    'emits [Loading, LoadedData] when repository returns non-empty list',
    build: () {
      when(() => repository.getSites()).thenAnswer((_) async => Right(sites));
      return SitesCubit(usecase);
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [
      const SitesLoading(),
      SitesLoadedData(sites),
    ],
  );

  blocTest<SitesCubit, SitesState>(
    'emits [Loading, LoadedNoData] when repository returns empty list',
    build: () {
      when(() => repository.getSites()).thenAnswer((_) async => const Right([]));
      return SitesCubit(usecase);
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [
      const SitesLoading(),
      const SitesLoadedNoData(),
    ],
  );

  blocTest<SitesCubit, SitesState>(
    'emits [Loading, Error] when repository fails',
    build: () {
      when(() => repository.getSites())
          .thenAnswer((_) async => const Left(CacheFailure('boom')));
      return SitesCubit(usecase);
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [
      const SitesLoading(),
      isA<SitesError>(),
    ],
  );
}
