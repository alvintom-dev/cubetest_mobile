import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/site.dart';
import '../../../domain/usecases/get_sites_usecase.dart';

part 'sites_state.dart';

@injectable
class SitesCubit extends Cubit<SitesState> {
  SitesCubit(this._getSitesUsecase) : super(const SitesInitial());

  final GetSitesUsecase _getSitesUsecase;

  Future<void> fetch() async {
    emit(const SitesLoading());
    final result = await _getSitesUsecase();
    result.fold(
      (failure) => emit(SitesError(failure.toString())),
      (sites) {
        if (sites.isEmpty) {
          emit(const SitesLoadedNoData());
        } else {
          emit(SitesLoadedData(sites));
        }
      },
    );
  }
}
