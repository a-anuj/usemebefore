import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(settings);
    tz.initializeTimeZones(); // Crucial for zonedSchedule
  }

  static Future<void> scheduleReminders({
    required String title,
    required String body,
    required DateTime expiryDate,
    required int baseId,
  }) async {
    final List<Duration> intervals = [
      Duration(days: 90), // 3 months
      Duration(days: 60), // 2 months
      Duration(days: 30), // 1 month
      Duration(days: 5),
      Duration(days: 3),
      Duration(days: 2),
    ];

    for (int i = 0; i < intervals.length; i++) {
      final scheduledDate = expiryDate.subtract(intervals[i]);
      if (scheduledDate.isAfter(DateTime.now())) {
        await _notifications.zonedSchedule(
          baseId + i,
          title,
          "$body in ${intervals[i].inDays} days!",
          tz.TZDateTime.from(scheduledDate, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'item_channel',
              'Item Expiry Alerts',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }
  }
}
