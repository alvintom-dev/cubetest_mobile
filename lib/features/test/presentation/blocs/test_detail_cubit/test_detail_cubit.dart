import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/cube_result_set.dart';
import '../../../domain/entities/test.dart';
import '../../../domain/usecases/create_cube_result_set_usecase.dart';
import '../../../domain/usecases/delete_cube_result_set_usecase.dart';
import '../../../domain/usecases/delete_test_usecase.dart';
import '../../../domain/usecases/get_cube_result_sets_usecase.dart';
import '../../../domain/usecases/get_test_usecase.dart';
import '../../../domain/usecases/update_cube_result_set_usecase.dart';
import '../../../domain/usecases/update_test_status_usecase.dart';

part 'test_detail_state.dart';

@injectable
class TestDetailCubit extends Cubit<TestDetailState> {
  TestDetailCubit(
    this._getTestUsecase,
    this._getResultsUsecase,
    this._updateStatusUsecase,
    this._deleteTestUsecase,
    this._createResultUsecase,
    this._updateResultUsecase,
    this._deleteResultUsecase,
  ) : super(const TestDetailInitial());

  final GetTestUsecase _getTestUsecase;
  final GetCubeResultSetsUsecase _getResultsUsecase;
  final UpdateTestStatusUsecase _updateStatusUsecase;
  final DeleteTestUsecase _deleteTestUsecase;
  final CreateCubeResultSetUsecase _createResultUsecase;
  final UpdateCubeResultSetUsecase _updateResultUsecase;
  final DeleteCubeResultSetUsecase _deleteResultUsecase;

  Future<void> load(String id) async {
    emit(const TestDetailLoading());
    final testResult = await _getTestUsecase(GetTestUsecaseParam(id: id));
    await testResult.fold(
      (failure) async => emit(TestDetailError(failure.toString())),
      (test) async {
        final resultsResult = await _getResultsUsecase(
          GetCubeResultSetsUsecaseParam(testId: id),
        );
        resultsResult.fold(
          (failure) => emit(TestDetailError(failure.toString())),
          (results) =>
              emit(TestDetailLoaded(test: test, cubeResultSets: results)),
        );
      },
    );
  }

  Future<void> updateStatus(UpdateTestStatusUsecaseParam param) async {
    final current = state;
    if (current is! TestDetailLoaded) return;
    final result = await _updateStatusUsecase(param);
    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(TestDetailActionError(
            test: current.test,
            cubeResultSets: current.cubeResultSets,
            message: failure.message ?? 'Validation failed',
          ));
          emit(TestDetailLoaded(
            test: current.test,
            cubeResultSets: current.cubeResultSets,
          ));
        } else {
          emit(TestDetailError(failure.toString()));
        }
      },
      (test) => emit(TestDetailLoaded(
        test: test,
        cubeResultSets: current.cubeResultSets,
      )),
    );
  }

  Future<void> deleteTest() async {
    final current = state;
    if (current is! TestDetailLoaded) return;
    final result = await _deleteTestUsecase(
      DeleteTestUsecaseParam(id: current.test.id),
    );
    result.fold(
      (failure) => emit(TestDetailError(failure.toString())),
      (_) => emit(const TestDetailDeleted()),
    );
  }

  Future<void> addCubeResultSet(CreateCubeResultSetUsecaseParam param) async {
    final current = state;
    if (current is! TestDetailLoaded) return;
    final result = await _createResultUsecase(param);
    await result.fold(
      (failure) async => _emitActionFailure(current, failure),
      (_) async => load(current.test.id),
    );
  }

  Future<void> updateCubeResultSet(
    UpdateCubeResultSetUsecaseParam param,
  ) async {
    final current = state;
    if (current is! TestDetailLoaded) return;
    final result = await _updateResultUsecase(param);
    await result.fold(
      (failure) async => _emitActionFailure(current, failure),
      (_) async => load(current.test.id),
    );
  }

  Future<void> deleteCubeResultSet(String id) async {
    final current = state;
    if (current is! TestDetailLoaded) return;
    final result = await _deleteResultUsecase(
      DeleteCubeResultSetUsecaseParam(id: id),
    );
    await result.fold(
      (failure) async => _emitActionFailure(current, failure),
      (_) async => load(current.test.id),
    );
  }

  void _emitActionFailure(TestDetailLoaded current, Failure failure) {
    final message = failure is ValidationFailure
        ? (failure.message ?? 'Validation failed')
        : failure.toString();
    emit(TestDetailActionError(
      test: current.test,
      cubeResultSets: current.cubeResultSets,
      message: message,
    ));
    emit(TestDetailLoaded(
      test: current.test,
      cubeResultSets: current.cubeResultSets,
    ));
  }
}
