import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/test.dart';
import '../../../domain/usecases/get_tests_usecase.dart';

part 'tests_state.dart';

@injectable
class TestsCubit extends Cubit<TestsState> {
  TestsCubit(this._getTestsUsecase) : super(const TestsInitial());

  final GetTestsUsecase _getTestsUsecase;

  Future<void> fetch(String testSetId) async {
    emit(const TestsLoading());
    final result =
        await _getTestsUsecase(GetTestsUsecaseParam(testSetId: testSetId));
    result.fold(
      (failure) => emit(TestsError(failure.toString())),
      (items) {
        if (items.isEmpty) {
          emit(const TestsLoadedNoData());
        } else {
          emit(TestsLoadedData(items));
        }
      },
    );
  }
}
