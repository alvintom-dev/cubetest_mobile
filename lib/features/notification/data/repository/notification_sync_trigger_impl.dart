import 'package:injectable/injectable.dart';

import '../../../../core/ports/notification_sync_trigger.dart';
import '../../domain/usecases/sync_notifications_usecase.dart';

@Injectable(as: NotificationSyncTrigger)
class NotificationSyncTriggerImpl implements NotificationSyncTrigger {
  const NotificationSyncTriggerImpl(this._usecase);

  final SyncNotificationsUsecase _usecase;

  @override
  Future<void> syncNotifications() async {
    try {
      await _usecase();
    } catch (_) {
      // Swallow: notification sync failures must not block test writes.
      // The spec mandates retry on next sync.
    }
  }
}
