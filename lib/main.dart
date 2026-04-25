import 'package:flutter/material.dart';

import 'app.dart';
import 'config/di.dart';
import 'features/notification/domain/usecases/should_sync_notifications_usecase.dart';
import 'features/notification/domain/usecases/sync_notifications_usecase.dart';
import 'services/notification/local_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt<LocalNotificationService>().initialize();
  final shouldSyncResult = await getIt<ShouldSyncNotificationsUsecase>()();
  await shouldSyncResult.fold(
    (_) async {},
    (doSync) async {
      if (doSync) {
        await getIt<SyncNotificationsUsecase>()();
      }
    },
  );
  runApp(const CubeTestApp());
}
