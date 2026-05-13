import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz_data.initializeTimeZones();

    final timezone = await FlutterTimezone.getLocalTimezone();
    final location = tz.getLocation(timezone);
    tz.setLocalLocation(location);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
    );

    await _notifications.initialize(initializationSettings);

    await _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> scheduleDailyReminder({
    int hour = 20,
    int minute = 0,
  }) async {
    await _notifications.zonedSchedule(
      1,
      'Time for a gentle check-in',
      'Take a quiet moment to log how you feel today.',
      _nextReminderTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_mood_reminder',
          'Daily Mood Reminder',
          channelDescription: 'Daily reminder to log your mood in MindBloom',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextReminderTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime;
  }

  static Future<void> cancelDailyReminder() async {
    await _notifications.cancel(1);
  }

  static Future<void> showTestNotification() async {
    await _notifications.show(
      99,
      'MindBloom test notification',
      'If you see this, notifications are working.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_notification',
          'Test Notification',
          channelDescription: 'Used for testing notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}