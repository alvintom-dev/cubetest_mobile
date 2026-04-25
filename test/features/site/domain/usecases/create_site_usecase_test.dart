import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/site/domain/entities/site.dart';
import 'package:cubetest_mobile/features/site/domain/repository/site_repository.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/create_site_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

class FakeCreateSiteUsecaseParam extends Fake implements CreateSiteUsecaseParam {}

void main() {
  late MockSiteRepository repository;
  late CreateSiteUsecase usecase;

  setUpAll(() {
    registerFallbackValue(FakeCreateSiteUsecaseParam());
  });

  setUp(() {
    repository = MockSiteRepository();
    usecase = CreateSiteUsecase(repository);
  });

  final now = DateTime(2026, 1, 1);
  final site = Site(
    id: 'abc',
    name: 'Site A',
    createdAt: now,
    updatedAt: now,
  );

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(result, const Left<Failure, Site>(InternalAppError('Params cannot be null')));
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when name is empty', () async {
    final result = await usecase(const CreateSiteUsecaseParam(name: '   '));
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('delegates to repository on success', () async {
    when(() => repository.createSite(param: any(named: 'param')))
        .thenAnswer((_) async => Right(site));

    final result = await usecase(const CreateSiteUsecaseParam(name: 'Site A'));

    expect(result, Right<Failure, Site>(site));
    verify(() => repository.createSite(param: any(named: 'param'))).called(1);
  });

  test('propagates repository failure', () async {
    when(() => repository.createSite(param: any(named: 'param')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(const CreateSiteUsecaseParam(name: 'Site A'));

    expect(result, const Left<Failure, Site>(CacheFailure('boom')));
  });
}
