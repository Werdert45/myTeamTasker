//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/task-tile.dart';
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
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 30, bottom: 10),
                              child: Text("Hi, " + snapshot.data.name + "!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                                padding: EdgeInsets.only(left: 30, top: 70),
                                child: Text("These are today's tasks", style: TextStyle(fontSize: 14, color: Colors.white))
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
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
                          )
                        ],
                      ),
                      height: MediaQuery.of(context).size.height / 4.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          border: Border(
                          ),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
//                    height: 800,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 3.5,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    child: Column(
//                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Today", style: TextStyle(fontSize: 18)),
                                        SizedBox(height: 10),
                                        Text("5 out of 10", style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3.5,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    child: Column(
//                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Next day", style: TextStyle(fontSize: 18)),
                                        SizedBox(height: 10),
                                        Text("5 Tasks", style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3.5,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                    child: Column(
//                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Groups", style: TextStyle(fontSize: 18)),
                                        SizedBox(height: 10),
                                        Text("10 out of 15", style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Your Tasks", style: TextStyle(fontSize: 24, color: Colors.grey)),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.tasks.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data.tasks[index].title != "") {
                                  return Container(
                                    width: double.infinity,
                                    child: EmoIcon(tasks[index], user.uid, snapshot.data.groups[0], this, snapshot.data.personal_history, tasks.length),
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
