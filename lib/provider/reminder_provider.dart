import 'package:dicoding_restaurant_app/service/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderProvider with ChangeNotifier {
  static const String _reminderEnabledKey = 'reminder_enabled';
  bool _isReminderEnabled = false;
  final LocalNotificationService _notificationService =
      LocalNotificationService();

  bool get isReminderEnabled => _isReminderEnabled;

  ReminderProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isReminderEnabled = prefs.getBool(_reminderEnabledKey) ?? false;
    notifyListeners();

    if (_isReminderEnabled) {
      _scheduleNotification();
    }
  }

  Future<void> toggleReminder(bool value) async {
    _isReminderEnabled = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderEnabledKey, value);

    if (value) {
      await _scheduleNotification();
    } else {
      await _cancelNotification();
    }

    notifyListeners();
  }

  Future<void> _scheduleNotification() async {
    await _notificationService.configureLocalTimeZone();
    bool? permissionGranted = await _notificationService.requestPermissions();

    if (permissionGranted ?? false) {
      await _notificationService.scheduleDailyTenAMNotification(
        id: 1,
        channelId: "lunch_reminder",
        channelName: "Lunch Reminder",
      );
    }
  }

  Future<void> _cancelNotification() async {
    await _notificationService.cancelNotification(1);
  }

  Future<bool> checkNotificationStatus() async {
    final requests = await _notificationService.pendingNotificationRequests();
    return requests.any((request) => request.id == 1);
  }

  // Method to get all pending reminders
  Future<List<PendingNotificationRequest>> getPendingReminders() async {
    return await _notificationService.pendingNotificationRequests();
  }

  // Method to cancel a specific reminder
  Future<void> cancelSpecificReminder(int id) async {
    await _notificationService.cancelNotification(id);

    // If we canceled the lunch reminder, update the toggle state
    if (id == 1) {
      _isReminderEnabled = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_reminderEnabledKey, false);
      notifyListeners();
    }
  }

  // Method to schedule a new custom reminder
  Future<void> scheduleCustomReminder({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    await _notificationService.configureLocalTimeZone();
    bool? permissionGranted = await _notificationService.requestPermissions();

    if (permissionGranted ?? false) {
      final tz.TZDateTime scheduledDate = _calculateNextInstance(time);

      await _scheduleCustomNotification(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
      );
    }
  }

  tz.TZDateTime _calculateNextInstance(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> _scheduleCustomNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'custom_reminder_$id',
      'Custom Reminder',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    notifyListeners();
  }
}
