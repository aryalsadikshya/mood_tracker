import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    // Local scheduled notifications are currently disabled on web.
    if (kIsWeb || _initialized) return;

    try {
      tz_data.initializeTimeZones();

      String timezone = await FlutterTimezone.getLocalTimezone();

      // Correct the older IANA alias sometimes returned for Nepal.
      if (timezone == 'Asia/Katmandu') {
        timezone = 'Asia/Kathmandu';
      }

      try {
        final location = tz.getLocation(timezone);
        tz.setLocalLocation(location);
      } catch (_) {
        // Safe fallback if the device returns an unknown timezone.
        tz.setLocalLocation(
          tz.getLocation('Asia/Kathmandu'),
        );
      }

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const iosSettings = DarwinInitializationSettings();

      const initializationSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initializationSettings,
      );

      await _requestPermission();

      _initialized = true;
    } catch (error, stackTrace) {
      debugPrint(
        'Notification initialization failed: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> _requestPermission() async {
    if (kIsWeb) return;

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
    if (kIsWeb) return;

    if (!_initialized) {
      await initialize();
    }

    if (!_initialized) return;

    try {
      // Prevent duplicate reminders with the same notification ID.
      await _notifications.cancel(1);

      await _notifications.zonedSchedule(
        1,
        'Time for a gentle check-in',
        'Take a quiet moment to reflect with MindBloom.',
        _nextReminderTime(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_mood_reminder',
            'Daily Mood Reminder',
            channelDescription: 'Daily reminder to reflect in MindBloom',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Daily reminder scheduling failed: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static tz.TZDateTime _nextReminderTime(
    int hour,
    int minute,
  ) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (!scheduledTime.isAfter(now)) {
      scheduledTime = scheduledTime.add(
        const Duration(days: 1),
      );
    }

    return scheduledTime;
  }

  static Future<void> cancelDailyReminder() async {
    if (kIsWeb) return;

    try {
      await _notifications.cancel(1);
    } catch (error, stackTrace) {
      debugPrint(
        'Daily reminder cancellation failed: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static Future<void> showTestNotification() async {
    if (kIsWeb) return;

    if (!_initialized) {
      await initialize();
    }

    if (!_initialized) return;

    try {
      await _notifications.show(
        99,
        'MindBloom',
        'Notifications are working.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_notification',
            'Test Notification',
            channelDescription: 'Used to test MindBloom notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Test notification failed: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
