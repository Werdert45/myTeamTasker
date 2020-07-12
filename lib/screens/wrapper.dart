import 'package:collaborative_repitition/screens/authentication/create_group.dart';
import 'package:collaborative_repitition/screens/app/homepage.dart';
import 'package:collaborative_repitition/screens/authentication/loginpage.dart';
import 'package:collaborative_repitition/main.dart';
import 'package:collaborative_repitition/screens/authentication/onboarding-legacy.dart';
import 'package:collaborative_repitition/screens/authentication/selectprofpic.dart';
import 'package:collaborative_repitition/screens/authentication/signuppage.dart';
import 'package:collaborative_repitition/screens/authentication/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication/select-group.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if (user == null) {
      return WelcomePage();
    }
    else {
      return HomePage();
    }
  }
}
