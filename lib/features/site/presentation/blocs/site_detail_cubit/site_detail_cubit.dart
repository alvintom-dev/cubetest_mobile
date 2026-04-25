import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/site.dart';
import '../../../domain/usecases/delete_site_usecase.dart';
import '../../../domain/usecases/get_site_usecase.dart';

part 'site_detail_state.dart';

@injectable
class SiteDetailCubit extends Cubit<SiteDetailState> {
  SiteDetailCubit(this._getSiteUsecase, this._deleteSiteUsecase)
      : super(const SiteDetailInitial());

  final GetSiteUsecase _getSiteUsecase;
  final DeleteSiteUsecase _deleteSiteUsecase;

  Future<void> load(String id) async {
    emit(const SiteDetailLoading());
    final result = await _getSiteUsecase(GetSiteUsecaseParam(id: id));
    result.fold(
      (failure) => emit(SiteDetailError(failure.toString())),
      (site) => emit(SiteDetailLoaded(site)),
    );
  }

  Future<void> softDelete(String id) async {
    final result = await _deleteSiteUsecase(
      DeleteSiteUsecaseParam(id: id, isPermanentDelete: false),
    );
    result.fold(
      (failure) => emit(SiteDetailError(failure.toString())),
      (_) => emit(const SiteDetailDeleted()),
    );
  }
}
