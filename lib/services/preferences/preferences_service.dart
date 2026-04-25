import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kLastSyncKey = 'notification_last_sync_at';

@lazySingleton
class PreferencesService {
  const PreferencesService();

  Future<DateTime?> getLastSyncAt() async {
    final prefs = await SharedPreferences.getInstance();
    final iso = prefs.getString(kLastSyncKey);
    if (iso == null) return null;
    return DateTime.tryParse(iso);
  }

  Future<void> setLastSyncAt(DateTime value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kLastSyncKey, value.toIso8601String());
  }
}
