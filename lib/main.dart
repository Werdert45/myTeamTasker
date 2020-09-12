import 'package:collaborative_repitition/notifications_lib/functions/notification_functions.dart';
import 'package:collaborative_repitition/notifications_lib/store/AppState.dart';
import 'package:collaborative_repitition/notifications_lib/store/store.dart';
import 'package:collaborative_repitition/notifications_lib/utils/notificationHelper.dart';
import 'package:collaborative_repitition/screens/app/taskmanagerpage.dart';
import 'package:collaborative_repitition/screens/authentication/create_group.dart';
import 'package:collaborative_repitition/screens/authentication/select-group.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/screens/wrapper.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:collaborative_repitition/theme_changer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'models/user.dart';
import 'services/auth.dart';

//pages
import 'screens/app/homepage.dart';
import 'screens/authentication/loginpage.dart';
import 'screens/authentication/signuppage.dart';

final df = new DateFormat('dd-MM-yyyy hh:mm a');

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;
Store<AppState> store;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStore();
  store = getStore();

  notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  await initNotifications(flutterLocalNotificationsPlugin);
  requestIOSPermissions(flutterLocalNotificationsPlugin);

  var theme = await getDarkModeSetting();

  runApp(MyApp(store, theme ?? false));
}


class MyApp extends StatelessWidget {
  final Store<AppState> store;
  final bool theme;
  MyApp(this.store, this.theme);



  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      child: ThemeBuilder(
        defaultBrightness: theme ? Brightness.dark : Brightness.light,
        builder: (context, _brightness) {
          return StreamProvider<User>.value(
              value: AuthService().user,
              child: new MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Wrapper(),
                theme: ThemeData(
                    primarySwatch: Colors.teal,
                    brightness: _brightness
                ),
                routes: <String, WidgetBuilder>{
                  '/landingpage': (BuildContext context) => new MyApp(store, theme),
                  '/signup': (BuildContext context) => new SignupPage(),
                  '/login': (BuildContext context) => new LoginPage(),
                  '/creategroup': (BuildContext context) => new CreateGroupPage(),
                  '/selectgroup': (BuildContext context) => new SelectGroupPage(),
                  '/homepage': (BuildContext context) => new HomePage(),
                  '/taskmanager': (context) => new TaskManagerPage(),
                },
              )
          );
        },
      ),
      store: store,
    );
  }
}
