import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderProvider extends ChangeNotifier {
  bool _isReminderOn = false;
  bool get isReminderOn => _isReminderOn;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ReminderProvider() {
    _loadReminderSetting();
    _initNotifications();
  }

  Future<void> _loadReminderSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isReminderOn = prefs.getBool('daily_reminder') ?? false;
    notifyListeners();
  }

  Future<void> toggleReminder(bool value) async {
    _isReminderOn = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);

    if (value) {
      _scheduleDailyReminder();
    } else {
      _cancelReminder();
    }

    notifyListeners();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _scheduleDailyReminder() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminder',
          channelDescription: 'Reminder untuk makan siang',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    final now = DateTime.now();
    final scheduledTime = tz.TZDateTime.from(
      DateTime(now.year, now.month, now.day, 12, 43),
      tz.local,
    );

    await _notificationsPlugin.zonedSchedule(
      0,
      'Waktunya Makan Siang!',
      'Jangan lupa makan siang agar tetap sehat.',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _cancelReminder() async {
    await _notificationsPlugin.cancel(0);
  }

  Future<void> triggerTestNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'test_notification_channel',
          'Test Notification',
          channelDescription: 'Notifikasi ini hanya untuk pengujian',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      1,
      'Ini Notifikasi Test!',
      'Jika kamu melihat ini, berarti notifikasi bekerja!',
      notificationDetails,
    );
  }
}
