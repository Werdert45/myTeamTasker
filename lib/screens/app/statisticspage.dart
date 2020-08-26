import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:collaborative_repitition/components/syncingComponents.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/screens/app/partials/group_stats.dart';
import 'package:collaborative_repitition/screens/app/partials/user_stats.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/connectionFunctions.dart';
import 'package:collaborative_repitition/services/functions/saveTaskFunctions.dart';
import 'package:collaborative_repitition/services/usermanagement.dart';
import 'package:collaborative_repitition/components/task-tile.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => new _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool checkedValue;
  var _controller;
  var name;
  var picture;

  final AuthService _auth = AuthService();
  final Streams streams = Streams();
  final DatabaseService database = DatabaseService();

  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;


  var tasks = [];

  void initState() {
    super.initState();
    checkedValue = false;

    tasks = [];

    // Connection check
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: connected(_source) ? streams.getCompleteUser(user.uid) : readGeneralInfoFromStorage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              tasks = snapshot.data.tasks;

              _controller = new TextEditingController(text: snapshot.data.name);

              return Container(
                  child: Stack(
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30, bottom: 10, top: 30),
                                child: Text("Statistics", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                        height: MediaQuery.of(context).size.height / 6,
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
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height / 8),
                                DefaultTabController(
                                  length: 2,
                                  initialIndex: 0,
                                  child: Column(
                                    children: [
                                      TabBar(

                                        tabs: [
                                          Tab(icon: Icon(Icons.account_circle, color: Colors.black)),
                                          Tab(icon: Icon(Icons.group, color: Colors.black))
                                        ],
                                      ),
                                      Container(
                                        height: MediaQuery.of(context).size.height * 0.7,
//                                      color: Colors.red,
                                        child: TabBarView(
                                          children: [
                                            UserStatPage(snapshot.data.personal_history),
                                            GroupStatPage(snapshot.data.group_history, snapshot.data.groups)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            )
                        ),
                      ),
                      checkConnectivity(_source, context, true),
                    ],
                  )
              );
            }
            else {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

