import 'package:collaborative_repitition/main.dart';
import 'package:collaborative_repitition/notifications_lib/actions/actions.dart';
import 'package:collaborative_repitition/notifications_lib/builder/ReminderAlertBuilder.dart';
import 'package:collaborative_repitition/notifications_lib/store/store.dart';
import 'package:collaborative_repitition/notifications_lib/utils/notificationHelper.dart';

void _configureCustomReminder(bool value, customNotificationTime) {
  if (customNotificationTime != null) {
    if (value) {
      var now = new DateTime.now();
      var notificationTime = new DateTime(now.year, now.month, now.day,
          customNotificationTime.hour, customNotificationTime.minute);

      getStore().dispatch(SetReminderAction(
          time: notificationTime.toIso8601String(),
          name: custom));

      scheduleNotification(
          flutterLocalNotificationsPlugin, '4', custom, notificationTime);
    } else {
      getStore().dispatch(RemoveReminderAction(custom));
      turnOffNotificationById(flutterLocalNotificationsPlugin, 4);
    }
  }
}