// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cubetest_mobile/core/clock/clock.dart' as _i359;
import 'package:cubetest_mobile/core/clock/system_clock.dart' as _i1001;
import 'package:cubetest_mobile/core/ports/notification_sync_trigger.dart'
    as _i264;
import 'package:cubetest_mobile/core/ports/site_test_set_counter.dart' as _i194;
import 'package:cubetest_mobile/core/ports/test_progress_port.dart' as _i300;
import 'package:cubetest_mobile/core/ports/test_set_test_coordinator.dart'
    as _i424;
import 'package:cubetest_mobile/core/ports/upcoming_tests_query.dart' as _i760;
import 'package:cubetest_mobile/features/notification/data/datasource/notification_local_datasource.dart'
    as _i954;
import 'package:cubetest_mobile/features/notification/data/repository/notification_repository_impl.dart'
    as _i304;
import 'package:cubetest_mobile/features/notification/data/repository/notification_sync_trigger_impl.dart'
    as _i362;
import 'package:cubetest_mobile/features/notification/domain/repository/notification_repository.dart'
    as _i644;
import 'package:cubetest_mobile/features/notification/domain/usecases/should_sync_notifications_usecase.dart'
    as _i674;
import 'package:cubetest_mobile/features/notification/domain/usecases/sync_notifications_usecase.dart'
    as _i420;
import 'package:cubetest_mobile/features/site/data/datasource/site_local_datasource.dart'
    as _i69;
import 'package:cubetest_mobile/features/site/data/repository/site_repository_impl.dart'
    as _i370;
import 'package:cubetest_mobile/features/site/domain/repository/site_repository.dart'
    as _i684;
import 'package:cubetest_mobile/features/site/domain/usecases/create_site_usecase.dart'
    as _i179;
import 'package:cubetest_mobile/features/site/domain/usecases/delete_site_usecase.dart'
    as _i45;
import 'package:cubetest_mobile/features/site/domain/usecases/get_archived_sites_usecase.dart'
    as _i38;
import 'package:cubetest_mobile/features/site/domain/usecases/get_site_usecase.dart'
    as _i649;
import 'package:cubetest_mobile/features/site/domain/usecases/get_sites_usecase.dart'
    as _i857;
import 'package:cubetest_mobile/features/site/domain/usecases/update_site_usecase.dart'
    as _i672;
import 'package:cubetest_mobile/features/site/presentation/blocs/site_detail_cubit/site_detail_cubit.dart'
    as _i616;
import 'package:cubetest_mobile/features/site/presentation/blocs/site_form_cubit/site_form_cubit.dart'
    as _i231;
import 'package:cubetest_mobile/features/site/presentation/blocs/sites_archive_cubit/sites_archive_cubit.dart'
    as _i344;
import 'package:cubetest_mobile/features/site/presentation/blocs/sites_cubit/sites_cubit.dart'
    as _i934;
import 'package:cubetest_mobile/features/test/data/datasource/test_local_datasource.dart'
    as _i967;
import 'package:cubetest_mobile/features/test/data/repository/test_progress_port_impl.dart'
    as _i854;
import 'package:cubetest_mobile/features/test/data/repository/test_repository_impl.dart'
    as _i325;
import 'package:cubetest_mobile/features/test/data/repository/test_set_test_coordinator_impl.dart'
    as _i560;
import 'package:cubetest_mobile/features/test/data/repository/upcoming_tests_query_impl.dart'
    as _i253;
import 'package:cubetest_mobile/features/test/domain/repository/test_repository.dart'
    as _i889;
import 'package:cubetest_mobile/features/test/domain/usecases/auto_create_tests_usecase.dart'
    as _i12;
import 'package:cubetest_mobile/features/test/domain/usecases/create_cube_result_set_usecase.dart'
    as _i5;
import 'package:cubetest_mobile/features/test/domain/usecases/create_test_usecase.dart'
    as _i268;
import 'package:cubetest_mobile/features/test/domain/usecases/delete_cube_result_set_usecase.dart'
    as _i1031;
import 'package:cubetest_mobile/features/test/domain/usecases/delete_test_usecase.dart'
    as _i50;
import 'package:cubetest_mobile/features/test/domain/usecases/delete_tests_by_test_set_usecase.dart'
    as _i517;
import 'package:cubetest_mobile/features/test/domain/usecases/get_cube_result_sets_usecase.dart'
    as _i548;
import 'package:cubetest_mobile/features/test/domain/usecases/get_test_usecase.dart'
    as _i394;
import 'package:cubetest_mobile/features/test/domain/usecases/get_tests_usecase.dart'
    as _i1073;
import 'package:cubetest_mobile/features/test/domain/usecases/update_cube_result_set_usecase.dart'
    as _i528;
import 'package:cubetest_mobile/features/test/domain/usecases/update_test_status_usecase.dart'
    as _i5;
import 'package:cubetest_mobile/features/test/presentation/blocs/test_detail_cubit/test_detail_cubit.dart'
    as _i450;
import 'package:cubetest_mobile/features/test/presentation/blocs/test_form_cubit/test_form_cubit.dart'
    as _i1010;
import 'package:cubetest_mobile/features/test/presentation/blocs/tests_cubit/tests_cubit.dart'
    as _i364;
import 'package:cubetest_mobile/features/test_set/data/datasource/test_set_local_datasource.dart'
    as _i169;
import 'package:cubetest_mobile/features/test_set/data/repository/site_test_set_counter_impl.dart'
    as _i151;
import 'package:cubetest_mobile/features/test_set/data/repository/test_set_repository_impl.dart'
    as _i762;
import 'package:cubetest_mobile/features/test_set/domain/repository/test_set_repository.dart'
    as _i287;
import 'package:cubetest_mobile/features/test_set/domain/usecases/create_test_set_usecase.dart'
    as _i309;
import 'package:cubetest_mobile/features/test_set/domain/usecases/delete_test_set_usecase.dart'
    as _i35;
import 'package:cubetest_mobile/features/test_set/domain/usecases/get_test_set_usecase.dart'
    as _i872;
import 'package:cubetest_mobile/features/test_set/domain/usecases/get_test_sets_usecase.dart'
    as _i871;
import 'package:cubetest_mobile/features/test_set/domain/usecases/update_test_set_usecase.dart'
    as _i242;
import 'package:cubetest_mobile/features/test_set/presentation/blocs/test_set_detail_cubit/test_set_detail_cubit.dart'
    as _i380;
import 'package:cubetest_mobile/features/test_set/presentation/blocs/test_set_form_cubit/test_set_form_cubit.dart'
    as _i380;
import 'package:cubetest_mobile/features/test_set/presentation/blocs/test_sets_cubit/test_sets_cubit.dart'
    as _i556;
import 'package:cubetest_mobile/services/notification/local_notification_service.dart'
    as _i826;
import 'package:cubetest_mobile/services/preferences/preferences_service.dart'
    as _i996;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sqflite/sqflite.dart' as _i779;
import 'package:uuid/uuid.dart' as _i706;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i826.LocalNotificationService>(
      () => _i826.LocalNotificationService(),
    );
    gh.lazySingleton<_i996.PreferencesService>(
      () => const _i996.PreferencesService(),
    );
    gh.lazySingleton<_i359.Clock>(() => const _i1001.SystemClock());
    gh.factory<_i954.NotificationLocalDatasource>(
      () => _i954.NotificationLocalDatasource(gh<_i779.Database>()),
    );
    gh.factory<_i69.SiteLocalDatasource>(
      () => _i69.SiteLocalDatasource(gh<_i779.Database>()),
    );
    gh.factory<_i967.TestLocalDatasource>(
      () => _i967.TestLocalDatasource(gh<_i779.Database>()),
    );
    gh.factory<_i169.TestSetLocalDatasource>(
      () => _i169.TestSetLocalDatasource(gh<_i779.Database>()),
    );
    gh.factory<_i194.SiteTestSetCounter>(
      () => _i151.SiteTestSetCounterImpl(gh<_i169.TestSetLocalDatasource>()),
    );
    gh.factory<_i760.UpcomingTestsQuery>(
      () => _i253.UpcomingTestsQueryImpl(gh<_i967.TestLocalDatasource>()),
    );
    gh.factory<_i684.SiteRepository>(
      () => _i370.SiteRepositoryImpl(
        gh<_i69.SiteLocalDatasource>(),
        gh<_i706.Uuid>(),
        gh<_i194.SiteTestSetCounter>(),
      ),
    );
    gh.factory<_i644.NotificationRepository>(
      () => _i304.NotificationRepositoryImpl(
        gh<_i954.NotificationLocalDatasource>(),
        gh<_i760.UpcomingTestsQuery>(),
        gh<_i826.LocalNotificationService>(),
        gh<_i996.PreferencesService>(),
        gh<_i359.Clock>(),
      ),
    );
    gh.factory<_i300.TestProgressPort>(
      () => _i854.TestProgressPortImpl(gh<_i967.TestLocalDatasource>()),
    );
    gh.factory<_i179.CreateSiteUsecase>(
      () => _i179.CreateSiteUsecase(gh<_i684.SiteRepository>()),
    );
    gh.factory<_i45.DeleteSiteUsecase>(
      () => _i45.DeleteSiteUsecase(gh<_i684.SiteRepository>()),
    );
    gh.factory<_i38.GetArchivedSitesUsecase>(
      () => _i38.GetArchivedSitesUsecase(gh<_i684.SiteRepository>()),
    );
    gh.factory<_i649.GetSiteUsecase>(
      () => _i649.GetSiteUsecase(gh<_i684.SiteRepository>()),
    );
    gh.factory<_i857.GetSitesUsecase>(
      () => _i857.GetSitesUsecase(gh<_i684.SiteRepository>()),
    );
    gh.factory<_i672.UpdateSiteUsecase>(
      () => _i672.UpdateSiteUsecase(gh<_i684.SiteRepository>()),
    );
    gh.factory<_i616.SiteDetailCubit>(
      () => _i616.SiteDetailCubit(
        gh<_i649.GetSiteUsecase>(),
        gh<_i45.DeleteSiteUsecase>(),
      ),
    );
    gh.factory<_i674.ShouldSyncNotificationsUsecase>(
      () => _i674.ShouldSyncNotificationsUsecase(
        gh<_i644.NotificationRepository>(),
      ),
    );
    gh.factory<_i420.SyncNotificationsUsecase>(
      () => _i420.SyncNotificationsUsecase(gh<_i644.NotificationRepository>()),
    );
    gh.factory<_i344.SitesArchiveCubit>(
      () => _i344.SitesArchiveCubit(
        gh<_i38.GetArchivedSitesUsecase>(),
        gh<_i45.DeleteSiteUsecase>(),
      ),
    );
    gh.factory<_i231.SiteFormCubit>(
      () => _i231.SiteFormCubit(
        gh<_i179.CreateSiteUsecase>(),
        gh<_i672.UpdateSiteUsecase>(),
      ),
    );
    gh.factory<_i934.SitesCubit>(
      () => _i934.SitesCubit(gh<_i857.GetSitesUsecase>()),
    );
    gh.factory<_i264.NotificationSyncTrigger>(
      () => _i362.NotificationSyncTriggerImpl(
        gh<_i420.SyncNotificationsUsecase>(),
      ),
    );
    gh.factory<_i889.TestRepository>(
      () => _i325.TestRepositoryImpl(
        gh<_i967.TestLocalDatasource>(),
        gh<_i706.Uuid>(),
        gh<_i264.NotificationSyncTrigger>(),
      ),
    );
    gh.factory<_i424.TestSetTestCoordinator>(
      () => _i560.TestSetTestCoordinatorImpl(gh<_i889.TestRepository>()),
    );
    gh.factory<_i12.AutoCreateTestsUsecase>(
      () => _i12.AutoCreateTestsUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i5.CreateCubeResultSetUsecase>(
      () => _i5.CreateCubeResultSetUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i268.CreateTestUsecase>(
      () => _i268.CreateTestUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i1031.DeleteCubeResultSetUsecase>(
      () => _i1031.DeleteCubeResultSetUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i50.DeleteTestUsecase>(
      () => _i50.DeleteTestUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i517.DeleteTestsByTestSetUsecase>(
      () => _i517.DeleteTestsByTestSetUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i548.GetCubeResultSetsUsecase>(
      () => _i548.GetCubeResultSetsUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i394.GetTestUsecase>(
      () => _i394.GetTestUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i1073.GetTestsUsecase>(
      () => _i1073.GetTestsUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i528.UpdateCubeResultSetUsecase>(
      () => _i528.UpdateCubeResultSetUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i5.UpdateTestStatusUsecase>(
      () => _i5.UpdateTestStatusUsecase(gh<_i889.TestRepository>()),
    );
    gh.factory<_i1010.TestFormCubit>(
      () => _i1010.TestFormCubit(gh<_i268.CreateTestUsecase>()),
    );
    gh.factory<_i364.TestsCubit>(
      () => _i364.TestsCubit(gh<_i1073.GetTestsUsecase>()),
    );
    gh.factory<_i287.TestSetRepository>(
      () => _i762.TestSetRepositoryImpl(
        gh<_i169.TestSetLocalDatasource>(),
        gh<_i706.Uuid>(),
        gh<_i424.TestSetTestCoordinator>(),
        gh<_i264.NotificationSyncTrigger>(),
      ),
    );
    gh.factory<_i450.TestDetailCubit>(
      () => _i450.TestDetailCubit(
        gh<_i394.GetTestUsecase>(),
        gh<_i548.GetCubeResultSetsUsecase>(),
        gh<_i5.UpdateTestStatusUsecase>(),
        gh<_i50.DeleteTestUsecase>(),
        gh<_i5.CreateCubeResultSetUsecase>(),
        gh<_i528.UpdateCubeResultSetUsecase>(),
        gh<_i1031.DeleteCubeResultSetUsecase>(),
      ),
    );
    gh.factory<_i309.CreateTestSetUsecase>(
      () => _i309.CreateTestSetUsecase(gh<_i287.TestSetRepository>()),
    );
    gh.factory<_i35.DeleteTestSetUsecase>(
      () => _i35.DeleteTestSetUsecase(gh<_i287.TestSetRepository>()),
    );
    gh.factory<_i872.GetTestSetUsecase>(
      () => _i872.GetTestSetUsecase(gh<_i287.TestSetRepository>()),
    );
    gh.factory<_i871.GetTestSetsUsecase>(
      () => _i871.GetTestSetsUsecase(gh<_i287.TestSetRepository>()),
    );
    gh.factory<_i242.UpdateTestSetUsecase>(
      () => _i242.UpdateTestSetUsecase(gh<_i287.TestSetRepository>()),
    );
    gh.factory<_i556.TestSetsCubit>(
      () => _i556.TestSetsCubit(
        gh<_i871.GetTestSetsUsecase>(),
        gh<_i300.TestProgressPort>(),
      ),
    );
    gh.factory<_i380.TestSetFormCubit>(
      () => _i380.TestSetFormCubit(
        gh<_i309.CreateTestSetUsecase>(),
        gh<_i242.UpdateTestSetUsecase>(),
      ),
    );
    gh.factory<_i380.TestSetDetailCubit>(
      () => _i380.TestSetDetailCubit(
        gh<_i872.GetTestSetUsecase>(),
        gh<_i35.DeleteTestSetUsecase>(),
        gh<_i300.TestProgressPort>(),
      ),
    );
    return this;
  }
}
