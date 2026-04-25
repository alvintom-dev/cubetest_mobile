import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/ports/test_progress_port.dart';
import '../../../../../core/ports/test_set_progress.dart';
import '../../../domain/entities/test_set.dart';
import '../../../domain/usecases/get_test_sets_usecase.dart';

part 'test_sets_state.dart';

@injectable
class TestSetsCubit extends Cubit<TestSetsState> {
  TestSetsCubit(this._getTestSetsUsecase, this._testProgressPort)
      : super(const TestSetsInitial());

  final GetTestSetsUsecase _getTestSetsUsecase;
  final TestProgressPort _testProgressPort;

  Future<void> fetch(String siteId) async {
    emit(const TestSetsLoading());
    final result = await _getTestSetsUsecase(
      GetTestSetsUsecaseParam(siteId: siteId, isDeleted: false),
    );
    await result.fold(
      (failure) async => emit(TestSetsError(failure.toString())),
      (items) async {
        if (items.isEmpty) {
          emit(const TestSetsLoadedNoData());
          return;
        }
        Map<String, TestSetProgress> progressBySetId;
        try {
          progressBySetId = await _testProgressPort.getProgressBulk(
            items.map((e) => e.id).toList(),
          );
        } catch (_) {
          progressBySetId = const {};
        }
        emit(TestSetsLoadedData(items, progressBySetId));
      },
    );
  }
}
