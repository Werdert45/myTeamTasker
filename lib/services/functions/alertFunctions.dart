

import 'package:collaborative_repitition/main.dart';
import 'package:collaborative_repitition/notifications_lib/actions/actions.dart';
import 'package:collaborative_repitition/notifications_lib/builder/ReminderAlertBuilder.dart';
import 'package:collaborative_repitition/notifications_lib/store/store.dart';
import 'package:collaborative_repitition/notifications_lib/utils/notificationHelper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

//ReminderCustomItem(
//checkBoxValue: customReminder,
//iconName: custom,
//onChanged: (value) {
//setState(() {
//customReminder = value;
//});
//_configureCustomReminder(value);
//},
//showTimeDialog: () {
//_showTimeDialog(setState);
//},
//),


// SWITCH TO TURN ON NOTIFICATIONS (SET AS SHARED PRERERENCES
//Switch(
//value: notify,
//onChanged: (value) {
//if (!value) {
//turnOffNotification(flutterLocalNotificationsPlugin);
//}
//setState(() {
//notify = value;
//});
//},
//activeTrackColor: Colors.lightBlueAccent,
//activeColor: Colors.blueAccent,
//),

// ALL OF THE REMINDERS THAT ARE ACTIVE
//SizedBox(
//child: StoreConnector<AppState, List<Reminder>>(
//converter: (store) =>
//store.state.remindersState.reminders,
//builder: (context, reminders) {
//return RemindersList(reminders: reminders);
//}),
//height: Platform.isAndroid ? 420 : 550,
//),