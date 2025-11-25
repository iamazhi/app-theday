import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/anniversary_model.dart';
import '../services/date_calculator.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(initializationSettings);
  }

  Future<void> scheduleAnniversaryReminder(AnniversaryModel item) async {
    if (!item.reminder.enabled) return;

    final calc = DateCalculator(item);
    if (calc.daysUntil < 0) return;
    final reminderDate = _buildReminderDate(calc, item);

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'anniversary_channel',
        '纪念日提醒',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.zonedSchedule(
      item.id.hashCode,
      item.title,
      '今天是 ${item.title}',
      reminderDate,
      details,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancelReminder(String id) async {
    await _plugin.cancel(id.hashCode);
  }

  tz.TZDateTime _buildReminderDate(DateCalculator calc, AnniversaryModel item) {
    final location = tz.local;
    final target = calc.daysUntil;
    final reminderDay = DateTime.now().add(Duration(days: target - item.reminder.daysBefore));
    final sanitized = reminderDay.isBefore(DateTime.now()) ? DateTime.now() : reminderDay;

    return tz.TZDateTime(
      location,
      sanitized.year,
      sanitized.month,
      sanitized.day,
      item.reminder.hour,
      item.reminder.minute,
    );
  }
}

