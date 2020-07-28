import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/screens/app/partials/groupsettings.dart';
import 'package:collaborative_repitition/screens/app/partials/usersettings.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/usermanagement.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool checkedValue;
  var picture;
  bool showGroupPage = false;

  final AuthService _auth = AuthService();
  final Streams streams = Streams();
  final DatabaseService database = DatabaseService();

  var tasks = [];

  void initState() {
    super.initState();
    checkedValue = false;
    tasks = [];
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return SingleChildScrollView(
      child: FutureBuilder(
        future: streams.getCompleteUser(user.uid),
        builder: (context, snapshot) {
          tasks = snapshot.data.tasks;

          return Container(
              child: Stack(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10, top: 30),
                              child: IconButton(
                                icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30),
                                onPressed: () async {
                                  await _auth.signOut();
                                  Navigator.pushReplacementNamed(context, '/landingpage');
                                },
                              ),
                            )
                        )
                      ],
                    ),
                    height: MediaQuery.of(context).size.height / 5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border(
                        ),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              child: Stack(
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(75),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Align(
                                              alignment: Alignment.center,
                                              heightFactor: 0.5,
                                              widthFactor: 1,
                                              child: Image(image: FirebaseImage('gs://collaborative-repetition.appspot.com/' + snapshot.data.profile_picture.toString()))),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        icon: Icon(Icons.add_circle, size: 40),
                                        onPressed: () {
                                        },
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showGroupPage = false;
                                      });
                                    },
                                      child: !showGroupPage ? Text("User", style: TextStyle(fontSize: 17)) : Text("User", style: TextStyle(fontSize: 16, color: Colors.grey))
                                  ),
                                  SizedBox(width: 30),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showGroupPage = true;
                                        });
                                      },
                                      child: showGroupPage ? Text("Groups", style: TextStyle(fontSize: 17)) : Text("Groups", style: TextStyle(fontSize: 16, color: Colors.grey))
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: showGroupPage ? GroupSettings(snapshot.data.groups) : UserSettings(snapshot.data.name, snapshot.data.email)
                            )
                          ],
                        )
                    ),
                  )
                ],
              )
          );
        },
      ),
    );
  }
}