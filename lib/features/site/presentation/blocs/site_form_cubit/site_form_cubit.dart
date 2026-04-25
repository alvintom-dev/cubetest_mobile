import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/site.dart';
import '../../../domain/usecases/create_site_usecase.dart';
import '../../../domain/usecases/update_site_usecase.dart';

part 'site_form_state.dart';

@injectable
class SiteFormCubit extends Cubit<SiteFormState> {
  SiteFormCubit(this._createSiteUsecase, this._updateSiteUsecase)
      : super(const SiteFormInitial());

  final CreateSiteUsecase _createSiteUsecase;
  final UpdateSiteUsecase _updateSiteUsecase;

  Future<void> submitCreate(CreateSiteUsecaseParam param) async {
    emit(const SiteFormSubmitting());
    final result = await _createSiteUsecase(param);
    _emitResult(result);
  }

  Future<void> submitUpdate(UpdateSiteUsecaseParam param) async {
    emit(const SiteFormSubmitting());
    final result = await _updateSiteUsecase(param);
    _emitResult(result);
  }

  void _emitResult(dynamic result) {
    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(SiteFormValidationError(failure.message ?? 'Validation failed'));
        } else if (failure is Failure) {
          emit(SiteFormError(failure.toString()));
        } else {
          emit(SiteFormError(failure.toString()));
        }
      },
      (site) => emit(SiteFormSuccess(site as Site)),
    );
  }
}
