import 'package:bloc_test/bloc_test.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/site/domain/entities/site.dart';
import 'package:cubetest_mobile/features/site/domain/repository/site_repository.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/delete_site_usecase.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/get_site_usecase.dart';
import 'package:cubetest_mobile/features/site/presentation/blocs/site_detail_cubit/site_detail_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

class FakeDeleteSiteUsecaseParam extends Fake implements DeleteSiteUsecaseParam {}

void main() {
  late MockSiteRepository repository;
  late GetSiteUsecase getSite;
  late DeleteSiteUsecase deleteSite;

  final now = DateTime(2026, 1, 1);
  final site = Site(id: '1', name: 'A', createdAt: now, updatedAt: now);

  setUpAll(() {
    registerFallbackValue(FakeDeleteSiteUsecaseParam());
  });

  setUp(() {
    repository = MockSiteRepository();
    getSite = GetSiteUsecase(repository);
    deleteSite = DeleteSiteUsecase(repository);
  });

  blocTest<SiteDetailCubit, SiteDetailState>(
    'emits [Loading, Loaded] on success',
    build: () {
      when(() => repository.getSite(id: any(named: 'id')))
          .thenAnswer((_) async => Right(site));
      return SiteDetailCubit(getSite, deleteSite);
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      const SiteDetailLoading(),
      SiteDetailLoaded(site),
    ],
  );

  blocTest<SiteDetailCubit, SiteDetailState>(
    'emits [Loading, Error] on failure',
    build: () {
      when(() => repository.getSite(id: any(named: 'id')))
          .thenAnswer((_) async => const Left(CacheFailure('boom')));
      return SiteDetailCubit(getSite, deleteSite);
    },
    act: (cubit) => cubit.load('1'),
    expect: () => [
      const SiteDetailLoading(),
      isA<SiteDetailError>(),
    ],
  );

  blocTest<SiteDetailCubit, SiteDetailState>(
    'emits [Deleted] after successful soft delete',
    build: () {
      when(() => repository.deleteSite(param: any(named: 'param')))
          .thenAnswer((_) async => const Right(true));
      return SiteDetailCubit(getSite, deleteSite);
    },
    act: (cubit) => cubit.softDelete('1'),
    expect: () => [
      const SiteDetailDeleted(),
    ],
  );
}
