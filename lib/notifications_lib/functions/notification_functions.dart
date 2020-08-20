import 'package:collaborative_repitition/main.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Get the list of all notifications
Future<List> getPendingNotifications() async {
  List<PendingNotificationRequest> p =
  await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  return p;
}


/// Remove a notification from the notification list
Future<void> cancelSpecificNotification(id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}


/// Remove all notifications (disable)
Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}


/// Add a notification (day, time, title, body)
Future<void> addNotification(int id, int day, Time time, String title, String body) async {

  var days = [Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday];

  var androidChannelSpecifics = AndroidNotificationDetails(
    'CHANNEL_ID ' + id.toString(),
    'CHANNEL_NAME ' + id.toString(),
    "CHANNEL_DESCRIPTION " + id.toString(),
    importance: Importance.Max,
    priority: Priority.High,
  );
  var iosChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics =
  NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
  await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
    id,
    title,
    body, //null
    days[day],
    time,
    platformChannelSpecifics,
    payload: 'Time to finish the task',
  );
}


// The plan is now that the notifications will be set every time the user logs in
// They are first flushed (disabled) and then for every login, for every task the notification is inserted


/// Set notifications when starting up the app
Future<void> setNotifications(List tasks) async {
  // 0. Set basic variables
  var day = DateTime.now().weekday - 1;
  var current_day = DateTime.now();
  var counter = 0;


  // 1. Delete all notifications
  await cancelAllNotifications();

  // 2. Loop through all tasks to check if the task is repeated or single
  for (int i = 0; i < tasks.length; i++) {
    var task = tasks[i];

    if (task is repeated_task) {
      // Check which days are possible
      for (int j = day; j < task.days.length; j++) {
        if (task.days[j % 6]) {
          // Set the day that the alert has to go off

          Time alert_time = Time(10, 0, 0);

          // Set the time (alert time)
          if (task.alert_time != null) {
           var temp_time =  task.alert_time.split(":");

           alert_time = Time(int.parse(temp_time[0]), int.parse(temp_time[1]), 0);
          }

          // TODO Also add the icon as an attachment so the user has an idea of what the task is
          // 3. Add the notification
          addNotification(counter, day % 6, alert_time, task.title, "It is time to continue working on your tasks");
          counter += 1;
        }
      }
    }

    else {

      Time alert_time = Time(10,0,0);

      // Set the time (alert time)
      if (task.alert_time != null) {
        var temp_time = task.alert_time.split(":");

        alert_time = Time(int.parse(temp_time[0]), int.parse(temp_time[1]), 0);
      }

      var alert_day = DateTime.fromMillisecondsSinceEpoch(task.date).weekday;

      // 3. Add the notification
      addNotification(counter, alert_day, alert_time, task.title, "It is time to continue working on your tasks");
      counter += 1;
    }
  }
}


