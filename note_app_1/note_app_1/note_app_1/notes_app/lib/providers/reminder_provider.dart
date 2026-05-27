import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import '../database/app_database.dart';
import '../models/reminder_model.dart';
import '../main.dart';

class ReminderProvider extends ChangeNotifier {
  final AppDatabase _db = AppDatabase();

  List<ReminderModel> _reminders = [];
  bool _loading = false;
  bool _tzInitialized = false;

  List<ReminderModel> get reminders => _reminders;
  bool get loading => _loading;

  List<ReminderModel> get upcomingReminders =>
      _reminders.where((r) => r.dateTime.isAfter(DateTime.now())).toList();

  Future<void> _ensureTz() async {
    if (!_tzInitialized) {
      tz_data.initializeTimeZones();
      _tzInitialized = true;
    }
  }

  Future<void> loadReminders() async {
    _loading = true;
    notifyListeners();
    _reminders = await _db.getUpcomingReminders();
    _loading = false;
    notifyListeners();
  }

  Future<void> addReminder(ReminderModel reminder) async {
    await _db.insertReminder(reminder);
    await _scheduleNotification(reminder);
    await loadReminders();
  }

  Future<void> removeReminderByNote(String noteId) async {
    final existing = _reminders.where((r) => r.noteId == noteId);
    for (final r in existing) {
      final notifId = r.noteId.hashCode.abs() % 100000;
      await flutterLocalNotificationsPlugin.cancel(notifId);
    }
    await _db.deleteReminderByNoteId(noteId);
    await loadReminders();
  }

  Future<void> _scheduleNotification(ReminderModel reminder) async {
    await _ensureTz();

    final scheduledDate = reminder.dateTime;
    if (scheduledDate.isBefore(DateTime.now())) return;

    final notifId = reminder.noteId.hashCode.abs() % 100000;

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'reminders_channel',
      'Note Reminders',
      channelDescription: 'Notifications for note reminders',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notifDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notifId,
      '⏰ ${reminder.noteTitle}',
      'Your reminder is here!',
      tzScheduled,
      notifDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}