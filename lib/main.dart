import 'package:collaborative_repitition/create_group.dart';
import 'package:collaborative_repitition/select-group.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/user.dart';
import 'services/auth.dart';

//pages
import 'homepage.dart';
import 'loginpage.dart';
import 'signuppage.dart';
import 'selectprofpic.dart';

void main() => runApp(new MyApp());




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        theme: ThemeData(primarySwatch: Colors.teal),
        routes: <String, WidgetBuilder>{
          '/landingpage': (BuildContext context) => new MyApp(),
          '/signup': (BuildContext context) => new SignupPage(),
          '/login': (BuildContext context) => new LoginPage(),
//          '/selectpic': (BuildContext context) => new SelectprofilepicPage(name),
          '/creategroup': (BuildContext context) => new CreateGroupPage(),
          '/selectgroup': (BuildContext context) => new SelectGroupPage(),
          '/homepage': (BuildContext context) => new HomePage(),
        },
      )
    );
  }
}
