import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/test_set.dart';
import '../../../domain/usecases/create_test_set_usecase.dart';
import '../../../domain/usecases/update_test_set_usecase.dart';

part 'test_set_form_state.dart';

@injectable
class TestSetFormCubit extends Cubit<TestSetFormState> {
  TestSetFormCubit(this._createTestSetUsecase, this._updateTestSetUsecase)
      : super(const TestSetFormInitial());

  final CreateTestSetUsecase _createTestSetUsecase;
  final UpdateTestSetUsecase _updateTestSetUsecase;

  Future<void> submitCreate(CreateTestSetUsecaseParam param) async {
    emit(const TestSetFormSubmitting());
    final result = await _createTestSetUsecase(param);
    _emitResult(result);
  }

  Future<void> submitUpdate(UpdateTestSetUsecaseParam param) async {
    emit(const TestSetFormSubmitting());
    final result = await _updateTestSetUsecase(param);
    _emitResult(result);
  }

  void _emitResult(dynamic result) {
    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(TestSetFormValidationError(
              failure.message ?? 'Validation failed'));
        } else if (failure is Failure) {
          emit(TestSetFormError(failure.toString()));
        } else {
          emit(TestSetFormError(failure.toString()));
        }
      },
      (testSet) => emit(TestSetFormSuccess(testSet as TestSet)),
    );
  }
}
