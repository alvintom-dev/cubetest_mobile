import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/site/domain/entities/site.dart';
import 'package:cubetest_mobile/features/site/domain/repository/site_repository.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/update_site_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

class FakeUpdateSiteUsecaseParam extends Fake implements UpdateSiteUsecaseParam {}

void main() {
  late MockSiteRepository repository;
  late UpdateSiteUsecase usecase;

  setUpAll(() {
    registerFallbackValue(FakeUpdateSiteUsecaseParam());
  });

  setUp(() {
    repository = MockSiteRepository();
    usecase = UpdateSiteUsecase(repository);
  });

  final now = DateTime(2026, 1, 1);
  final site = Site(id: '1', name: 'A', createdAt: now, updatedAt: now);

  const validParam = UpdateSiteUsecaseParam(
    id: '1',
    name: 'New name',
    status: SiteStatus.open,
  );

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(result, const Left<Failure, Site>(InternalAppError('Params cannot be null')));
  });

  test('returns ValidationFailure when id is empty', () async {
    final result = await usecase(const UpdateSiteUsecaseParam(
      id: '',
      name: 'x',
      status: SiteStatus.open,
    ));
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
  });

  test('returns ValidationFailure when name is empty', () async {
    final result = await usecase(const UpdateSiteUsecaseParam(
      id: '1',
      name: '  ',
      status: SiteStatus.open,
    ));
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
  });

  test('returns updated site on success', () async {
    when(() => repository.updateSite(param: any(named: 'param')))
        .thenAnswer((_) async => Right(site));

    final result = await usecase(validParam);

    expect(result, Right<Failure, Site>(site));
    verify(() => repository.updateSite(param: any(named: 'param'))).called(1);
  });

  test('propagates failure', () async {
    when(() => repository.updateSite(param: any(named: 'param')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(validParam);

    expect(result, const Left<Failure, Site>(CacheFailure('boom')));
  });
}
