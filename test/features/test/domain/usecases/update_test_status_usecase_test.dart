import 'package:cubetest_mobile/core/error/failure.dart';
import 'package:cubetest_mobile/features/test/domain/entities/test.dart';
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart';
import 'package:cubetest_mobile/features/test/domain/usecases/update_test_status_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTestRepository extends Mock implements TestRepository {}

class FakeUpdateTestStatusUsecaseParam extends Fake
    implements UpdateTestStatusUsecaseParam {}

void main() {
  late MockTestRepository repository;
  late UpdateTestStatusUsecase usecase;

  final now = DateTime(2026, 1, 1);
  final sample = Test(
    id: '1',
    testSetId: 'ts-1',
    type: TestType.day7,
    dueDate: now,
    status: TestStatus.passed,
    createdAt: now,
    updatedAt: now,
  );

  setUpAll(() {
    registerFallbackValue(FakeUpdateTestStatusUsecaseParam());
  });

  setUp(() {
    repository = MockTestRepository();
    usecase = UpdateTestStatusUsecase(repository);
  });

  test('returns InternalAppError when params is null', () async {
    final result = await usecase(null);
    expect(
      result,
      const Left<Failure, Test>(InternalAppError('Params cannot be null')),
    );
    verifyZeroInteractions(repository);
  });

  test('returns ValidationFailure when id is empty', () async {
    final result = await usecase(const UpdateTestStatusUsecaseParam(
      id: '   ',
      status: TestStatus.passed,
    ));
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('expected Left'),
    );
    verifyZeroInteractions(repository);
  });

  test('delegates to repository on success', () async {
    when(() => repository.updateTestStatus(param: any(named: 'param')))
        .thenAnswer((_) async => Right(sample));

    final result = await usecase(const UpdateTestStatusUsecaseParam(
      id: '1',
      status: TestStatus.passed,
    ));

    expect(result, Right<Failure, Test>(sample));
  });

  test('propagates repository failure', () async {
    when(() => repository.updateTestStatus(param: any(named: 'param')))
        .thenAnswer((_) async => const Left(ValidationFailure('need result')));

    final result = await usecase(const UpdateTestStatusUsecaseParam(
      id: '1',
      status: TestStatus.passed,
    ));

    expect(
      result,
      const Left<Failure, Test>(ValidationFailure('need result')),
    );
  });
}
