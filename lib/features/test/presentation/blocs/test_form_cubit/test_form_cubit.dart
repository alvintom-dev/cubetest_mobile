import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/test.dart';
import '../../../domain/usecases/create_test_usecase.dart';

part 'test_form_state.dart';

@injectable
class TestFormCubit extends Cubit<TestFormState> {
  TestFormCubit(this._createTestUsecase) : super(const TestFormInitial());

  final CreateTestUsecase _createTestUsecase;

  Future<void> submitCreate(CreateTestUsecaseParam param) async {
    emit(const TestFormSubmitting());
    final result = await _createTestUsecase(param);
    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(TestFormValidationError(
              failure.message ?? 'Validation failed'));
        } else {
          emit(TestFormError(failure.toString()));
        }
      },
      (test) => emit(TestFormSuccess(test)),
    );
  }
}
