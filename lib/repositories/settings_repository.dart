import 'package:shared_preferences/shared_preferences.dart';

import '../models/anniversary_model.dart';

class SettingsRepository {
  static const _hourKey = 'default_reminder_hour';
  static const _minuteKey = 'default_reminder_minute';
  static const _daysBeforeKey = 'default_reminder_days_before';

  Future<ReminderSetting> loadDefaultReminder() async {
    final prefs = await SharedPreferences.getInstance();
    return ReminderSetting(
      hour: prefs.getInt(_hourKey) ?? 9,
      minute: prefs.getInt(_minuteKey) ?? 0,
      daysBefore: prefs.getInt(_daysBeforeKey) ?? 0,
    );
  }

  Future<void> saveDefaultReminder(ReminderSetting setting) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, setting.hour);
    await prefs.setInt(_minuteKey, setting.minute);
    await prefs.setInt(_daysBeforeKey, setting.daysBefore);
  }
}

