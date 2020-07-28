//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/screens/app/partials/horizontalbarchart.dart';
import 'package:collaborative_repitition/screens/app/settingsPage.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/task-tile.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../components/button.dart';
import '../../services/auth.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool checkedValue;

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
    // TODO: implement dispose
    super.dispose();
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('Ian Ronk', 5),
      new OrdinalSales('Theo Roseveldt', 25),
      new OrdinalSales('Ronald Reagan', 100),
      new OrdinalSales('George Bush', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        domainFn: (OrdinalSales sales, _) => sales.year.length < 11 ? sales.year : sales.year.substring(0, 8) + "...",
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return SingleChildScrollView(
      child: FutureBuilder(
        future: streams.getCompleteUser(user.uid),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.done) {
            tasks = snapshot.data.tasks;

            return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 120, top: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hi, " + snapshot.data.name + "!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white)),
                                  Text("These are today's tasks", style: TextStyle(fontSize: 14, color: Colors.white))
                                ],
                              )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: EdgeInsets.only(top: 40, right: 15),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Align(
                                          alignment: Alignment.center,
                                          heightFactor: 0.5,
                                          widthFactor: 1,
                                          child: Image(image: FirebaseImage('gs://collaborative-repetition.appspot.com/' + snapshot.data.profile_picture.toString()))),
                                    ),
                                  ),
                                )
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0, top: 55),
                              child: IconButton(
                                icon: Icon(Icons.settings, color: Colors.white, size: 28),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SettingsPage(snapshot.data))
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          border: Border(
                          ),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 10),
                      child: Text("Progess", style: TextStyle(fontSize: 24, color: Colors.grey)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: new LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 40,
                        lineHeight: 20.0,
                        percent: 0.5,
                        center: Text(
                          "50.0%",
                          style: new TextStyle(fontSize: 12.0),
                        ),
//                        trailing: Icon(Icons.mood, size: 40),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
//                      height: MediaQuery.of(context).size.height- 550,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("My Tasks", style: TextStyle(fontSize: 24, color: Colors.grey)),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.tasks.length,
                              itemBuilder: (context, index) {
                                print(snapshot.data.tasks);
                                if (snapshot.data.tasks[index].title != "") {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Container(
                                      width: double.infinity,
                                      child: EmoIcon(tasks[index], user.uid, snapshot.data.groups[0], this, snapshot.data.personal_history, tasks.length),
                                    ),
                                  );
                                }
                                else {
                                  return SizedBox();
                                }
                              }
                          ),
                        ],
                      ),
                    ),
//                    Padding(
//                      padding: EdgeInsets.only(left: 20),
//                      child: Text("Tomorrow", style: TextStyle(fontSize: 24, color: Colors.grey)),
//                    ),
//                    ListView.builder(
//                        padding: EdgeInsets.only(top: 10),
//                        shrinkWrap: true,
//                        physics: NeverScrollableScrollPhysics(),
//                        itemCount: snapshot.data.tasks.length,
//                        itemBuilder: (context, index) {
//                          print(snapshot.data.tasks);
//                          if (snapshot.data.tasks[index].title != "") {
//                            return Container(
//                              width: double.infinity,
//                              child: EmoIcon(tasks[index], user.uid, snapshot.data.groups[0], this, snapshot.data.personal_history, tasks.length),
//                            );
//                          }
//                          else {
//                            return SizedBox();
//                          }
//                        }
//                    ),
                  ],
                )
            );
          } else {
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
    );
  }
}

