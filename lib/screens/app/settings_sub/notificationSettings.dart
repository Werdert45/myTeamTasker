import 'dart:io';

import 'package:collaborative_repitition/notifications_lib/builder/RemindersListViewBuilder.dart';
import 'package:collaborative_repitition/notifications_lib/models/index.dart';
import 'package:collaborative_repitition/notifications_lib/store/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 12),
                  child: GestureDetector(
                    onTap: () {Navigator.pop(context);},
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("Notifications", style: TextStyle(fontSize: 24)),
                ),
              ),
              Positioned(
                top: 60,
                child: Container(
                  width: MediaQuery.of(context).size.width,
//                  height: MediaQuery.of(context).size.height - 80,
                  child: StoreConnector<AppState, List<Reminder>>(
                      converter: (store) =>
                      store.state.remindersState.reminders,
                      builder: (context, reminders) {

                        return RemindersList(reminders: reminders);
                      }),
                  height: Platform.isAndroid ? 420 : 550,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
