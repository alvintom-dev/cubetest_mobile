import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/ports/test_progress_port.dart';
import '../../../../../core/ports/test_set_progress.dart';
import '../../../domain/entities/test_set.dart';
import '../../../domain/usecases/delete_test_set_usecase.dart';
import '../../../domain/usecases/get_test_set_usecase.dart';

part 'test_set_detail_state.dart';

@injectable
class TestSetDetailCubit extends Cubit<TestSetDetailState> {
  TestSetDetailCubit(
    this._getTestSetUsecase,
    this._deleteTestSetUsecase,
    this._testProgressPort,
  ) : super(const TestSetDetailInitial());

  final GetTestSetUsecase _getTestSetUsecase;
  final DeleteTestSetUsecase _deleteTestSetUsecase;
  final TestProgressPort _testProgressPort;

  Future<void> load(String id) async {
    emit(const TestSetDetailLoading());
    final result = await _getTestSetUsecase(GetTestSetUsecaseParam(id: id));
    await result.fold(
      (failure) async => emit(TestSetDetailError(failure.toString())),
      (testSet) async {
        var progress = TestSetProgress.empty;
        try {
          progress = await _testProgressPort.getProgress(testSet.id);
        } catch (_) {
          // fall back to empty progress; do not block rendering
        }
        emit(TestSetDetailLoaded(testSet, progress));
      },
    );
  }

  Future<void> softDelete(String id) async {
    final result = await _deleteTestSetUsecase(
      DeleteTestSetUsecaseParam(id: id, isPermanentDelete: false),
    );
    result.fold(
      (failure) => emit(TestSetDetailError(failure.toString())),
      (_) => emit(const TestSetDetailDeleted()),
    );
  }
}
