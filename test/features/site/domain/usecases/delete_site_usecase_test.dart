import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/site/domain/repository/site_repository.dart';
import 'package:cubetest_mobile/features/site/domain/usecases/delete_site_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSiteRepository extends Mock implements SiteRepository {}

class FakeDeleteSiteUsecaseParam extends Fake implements DeleteSiteUsecaseParam {}

void main() {
  late MockSiteRepository repository;
  late DeleteSiteUsecase usecase;

  setUpAll(() {
    registerFallbackValue(FakeDeleteSiteUsecaseParam());
  });

  setUp(() {
    repository = MockSiteRepository();
    usecase = DeleteSiteUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(result, const Left<Failure, bool>(InternalAppError('Params cannot be null')));
  });

  test('returns ValidationFailure when id is empty', () async {
    final result = await usecase(
      const DeleteSiteUsecaseParam(id: '', isPermanentDelete: false),
    );
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
  });

  test('returns true on soft delete success', () async {
    when(() => repository.deleteSite(param: any(named: 'param')))
        .thenAnswer((_) async => const Right(true));

    final result = await usecase(
      const DeleteSiteUsecaseParam(id: '1', isPermanentDelete: false),
    );

    expect(result, const Right<Failure, bool>(true));
    verify(() => repository.deleteSite(param: any(named: 'param'))).called(1);
  });

  test('returns true on permanent delete success', () async {
    when(() => repository.deleteSite(param: any(named: 'param')))
        .thenAnswer((_) async => const Right(true));

    final result = await usecase(
      const DeleteSiteUsecaseParam(id: '1', isPermanentDelete: true),
    );

    expect(result, const Right<Failure, bool>(true));
  });

  test('propagates failure', () async {
    when(() => repository.deleteSite(param: any(named: 'param')))
        .thenAnswer((_) async => const Left(CacheFailure('boom')));

    final result = await usecase(
      const DeleteSiteUsecaseParam(id: '1', isPermanentDelete: false),
    );

    expect(result, const Left<Failure, bool>(CacheFailure('boom')));
  });
}
