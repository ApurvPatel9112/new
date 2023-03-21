import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class notificationService {
  static const String groupKey = 'com.android.example.WORK_EMAIL';
  static const String groupChannelId = 'grouped channel id';
  static const String groupChannelName = 'grouped channel name';
  static const String groupChannelDescription = 'grouped channel description';

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('remind');

    InitializationSettings(android: initializationSettingsAndroid);
  }

  Future<void> clearAllNoification() async {
    await notificationsPlugin.cancelAll();
  }

  notificationDetails() {
    const MediaStyleInformation mediaStyleInformation = MediaStyleInformation();

    AndroidNotificationDetails firstNotificationAndroidSpecifics =
        AndroidNotificationDetails(
            groupChannelId, groupChannelName, groupChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('notification'),
            enableVibration: true,
            enableLights: true,
            groupKey: groupKey,
            setAsGroupSummary: true,
            styleInformation: mediaStyleInformation);

    return NotificationDetails(android: firstNotificationAndroidSpecifics);
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        payload: 'Custom_Sound', id, title, body, await notificationDetails());
  }

  Future scheduleNotification(
      {int? id,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id!,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        payload: payLoad,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future showNotificationEveryDay(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        scheduledNotificationDateTime,
        tz.local,
      ),
      await notificationDetails(),
      androidAllowWhileIdle: true,
      payload: payLoad,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future showNotificationEveryWeek(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        scheduledNotificationDateTime,
        tz.local,
      ),
      await notificationDetails(),
      androidAllowWhileIdle: true,
      payload: payLoad,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future showNotificationEveryMonth(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        scheduledNotificationDateTime,
        tz.local,
      ),
      await notificationDetails(),
      androidAllowWhileIdle: true,
      payload: payLoad,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  Future showNotificationEveryYear(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        scheduledNotificationDateTime,
        tz.local,
      ),
      await notificationDetails(),
      androidAllowWhileIdle: true,
      payload: payLoad,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
