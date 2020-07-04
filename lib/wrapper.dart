import 'package:collaborative_repitition/create_group.dart';
import 'package:collaborative_repitition/homepage.dart';
import 'package:collaborative_repitition/loginpage.dart';
import 'package:collaborative_repitition/main.dart';
import 'package:collaborative_repitition/onboarding-legacy.dart';
import 'package:collaborative_repitition/selectprofpic.dart';
import 'package:collaborative_repitition/signuppage.dart';
import 'package:collaborative_repitition/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'select-group.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

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
