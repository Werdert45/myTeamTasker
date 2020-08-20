import 'package:collaborative_repitition/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future getPendingNotificationCount() async {
  List<PendingNotificationRequest> p =
  await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  return p[0].id;
}

Future<void> cancelSpecificNotification(id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}