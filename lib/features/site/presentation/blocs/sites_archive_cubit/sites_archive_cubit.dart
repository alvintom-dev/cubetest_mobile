import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/site.dart';
import '../../../domain/usecases/delete_site_usecase.dart';
import '../../../domain/usecases/get_archived_sites_usecase.dart';

part 'sites_archive_state.dart';

@injectable
class SitesArchiveCubit extends Cubit<SitesArchiveState> {
  SitesArchiveCubit(this._getArchivedSitesUsecase, this._deleteSiteUsecase)
      : super(const SitesArchiveInitial());

  final GetArchivedSitesUsecase _getArchivedSitesUsecase;
  final DeleteSiteUsecase _deleteSiteUsecase;

  Future<void> fetch() async {
    emit(const SitesArchiveLoading());
    final result = await _getArchivedSitesUsecase();
    result.fold(
      (failure) => emit(SitesArchiveError(failure.toString())),
      (sites) {
        if (sites.isEmpty) {
          emit(const SitesArchiveLoadedNoData());
        } else {
          emit(SitesArchiveLoadedData(sites));
        }
      },
    );
  }

  Future<void> permanentDelete(String id) async {
    final result = await _deleteSiteUsecase(
      DeleteSiteUsecaseParam(id: id, isPermanentDelete: true),
    );
    await result.fold(
      (failure) async => emit(SitesArchiveError(failure.toString())),
      (_) async => fetch(),
    );
  }
}
