import 'package:bloc_test/bloc_test.dart';
import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/site/domain/entities/site.dart';
import 'package:cubetest_mobile/features/site/domain/repository/site_repository.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/create_site_usecase.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/update_site_usecase.dart';
import 'package:cubetest_mobile/features/site/presentation/blocs/site_form_cubit/site_form_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

class FakeCreateSiteUsecaseParam extends Fake implements CreateSiteUsecaseParam {}

class FakeUpdateSiteUsecaseParam extends Fake implements UpdateSiteUsecaseParam {}

void main() {
  late MockSiteRepository repository;
  late CreateSiteUsecase createSite;
  late UpdateSiteUsecase updateSite;

  final now = DateTime(2026, 1, 1);
  final site = Site(id: '1', name: 'A', createdAt: now, updatedAt: now);

  const createParam = CreateSiteUsecaseParam(name: 'A');
  const emptyCreateParam = CreateSiteUsecaseParam(name: '');
  const updateParam = UpdateSiteUsecaseParam(
    id: '1',
    name: 'A',
    status: SiteStatus.open,
  );

  setUpAll(() {
    registerFallbackValue(FakeCreateSiteUsecaseParam());
    registerFallbackValue(FakeUpdateSiteUsecaseParam());
  });

  setUp(() {
    repository = MockSiteRepository();
    createSite = CreateSiteUsecase(repository);
    updateSite = UpdateSiteUsecase(repository);
  });

  blocTest<SiteFormCubit, SiteFormState>(
    'create: emits [Submitting, Success] when repository succeeds',
    build: () {
      when(() => repository.createSite(param: any(named: 'param')))
          .thenAnswer((_) async => Right(site));
      return SiteFormCubit(createSite, updateSite);
    },
    act: (cubit) => cubit.submitCreate(createParam),
    expect: () => [
      const SiteFormSubmitting(),
      SiteFormSuccess(site),
    ],
  );

  blocTest<SiteFormCubit, SiteFormState>(
    'create: emits [Submitting, ValidationError] when name is empty',
    build: () => SiteFormCubit(createSite, updateSite),
    act: (cubit) => cubit.submitCreate(emptyCreateParam),
    expect: () => [
      const SiteFormSubmitting(),
      isA<SiteFormValidationError>(),
    ],
  );

  blocTest<SiteFormCubit, SiteFormState>(
    'create: emits [Submitting, Error] when repository fails',
    build: () {
      when(() => repository.createSite(param: any(named: 'param')))
          .thenAnswer((_) async => const Left(CacheFailure('boom')));
      return SiteFormCubit(createSite, updateSite);
    },
    act: (cubit) => cubit.submitCreate(createParam),
    expect: () => [
      const SiteFormSubmitting(),
      isA<SiteFormError>(),
    ],
  );

  blocTest<SiteFormCubit, SiteFormState>(
    'update: emits [Submitting, Success] on success',
    build: () {
      when(() => repository.updateSite(param: any(named: 'param')))
          .thenAnswer((_) async => Right(site));
      return SiteFormCubit(createSite, updateSite);
    },
    act: (cubit) => cubit.submitUpdate(updateParam),
    expect: () => [
      const SiteFormSubmitting(),
      SiteFormSuccess(site),
    ],
  );
}
