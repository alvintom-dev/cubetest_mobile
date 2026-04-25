import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/site/domain/entities/site.dart';
import 'package:cubetest_mobile/features/site/domain/repository/site_repository.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/get_site_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

void main() {
  late MockSiteRepository repository;
  late GetSiteUsecase usecase;

  setUp(() {
    repository = MockSiteRepository();
    usecase = GetSiteUsecase(repository);
  });

  final now = DateTime(2026, 1, 1);
  final site = Site(id: '1', name: 'A', createdAt: now, updatedAt: now);

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(result, const Left<Failure, Site>(InternalAppError('Params cannot be null')));
  });

  test('returns ValidationFailure when id is empty', () async {
    final result = await usecase(const GetSiteUsecaseParam(id: ''));
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('returns site on success', () async {
    when(() => repository.getSite(id: any(named: 'id')))
        .thenAnswer((_) async => Right(site));

    final result = await usecase(const GetSiteUsecaseParam(id: '1'));

    expect(result, Right<Failure, Site>(site));
    verify(() => repository.getSite(id: '1')).called(1);
  });

  test('propagates failure', () async {
    when(() => repository.getSite(id: any(named: 'id')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(const GetSiteUsecaseParam(id: '1'));

    expect(result, const Left<Failure, Site>(CacheFailure('boom')));
  });
}
