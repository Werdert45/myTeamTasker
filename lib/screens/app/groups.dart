import 'package:collaborative_repitition/components/active-task-tile.dart';
import 'package:collaborative_repitition/components/task-tile.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  bool checkedValue;

  final AuthService _auth = AuthService();
  final Streams streams = Streams();
  final DatabaseService database = DatabaseService();

  var tasks = [];

  var showPersonal = true;

  void initState() {
    super.initState();
    checkedValue = false;

    tasks = [];
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30, bottom: 10),
                          child: Text("Task Manager", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height / 4.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFF572f8c),
                      border: Border(
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new OutlineButton(
                              child: Row(
                                children: <Widget>[
                                  IconButton(icon: Icon(Icons.account_circle)),
                                  Text("Personal Tasks"),
                                  SizedBox(width: 8)
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  showPersonal = true;
                                });
                              },
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                          ),
                          new OutlineButton(
                              child: Row(
                                children: <Widget>[
                                  IconButton(icon: Icon(Icons.group)),
                                  Text("Group Tasks"),
                                  SizedBox(width: 8)
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  showPersonal = false;
                                });
                              },
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                          ),
                        ],
                      )
                  ),
                ),
                showPersonal ? PersonalPage(snapshot, user) : GroupPage(snapshot, user)
              ],
            ),
          );
        }
      ),
    );
  }

  Widget GroupPage(snapshot, user) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 5),
          child: Text("Group Tasks", style: TextStyle(fontSize: 24, color: Color(0xFF572f8c))),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {
              if (tasks[index].shared) {
                return Container(
                  width: double.infinity,
                  child: ActiveTask(tasks[index], user.uid, snapshot.data.groups[0], this),
                );
              }
              else {
                return SizedBox();
              }
            }
        ),
        IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: () async {
            var taskID = (user.uid + DateTime.now().millisecondsSinceEpoch.toString());
            var alertTime = '14:15';
            var assignee = user.uid;
            var puid = user.uid;
//                      var days = [false, false, false, false, false, false, false];
            var icon = "😇";
            var title = "New Task";
            var group_id = snapshot.data.groups[0].code;
            var date = DateTime.now().millisecondsSinceEpoch.toString();
            var shared = false;

            await database.createSingleTask(taskID, alertTime, date, icon, assignee, title, puid, shared);

            await database.addSingleTask(taskID, puid, group_id, shared);

            setState(() {
              var new_task = single_task.fromMap({
                'icon': icon,
                'id': taskID,
                'title': title,
                'creator': user.uid,
                'days': null,
                'date': date,
                'alert_time': alertTime,
              });
              tasks.add(new_task);

            });
          },
        ),
      ],
    );
  }

  Widget PersonalPage(snapshot, user) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Personal Tasks", style: TextStyle(fontSize: 24, color: Color(0xFF572f8c))),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {
              if (!tasks[index].shared) {
                return Container(
                  width: double.infinity,
                  child: ActiveTask(tasks[index], user.uid, snapshot.data.groups[0], this),
                );
              }
              else {
                return SizedBox();
              }
            }
        ),
        IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: () async {
            var taskID = (user.uid + DateTime.now().millisecondsSinceEpoch.toString());
            var alertTime = '14:15';
            var assignee = user.uid;
            var puid = user.uid;
//                      var days = [false, false, false, false, false, false, false];
            var icon = "😇";
            var title = "New Task";
            var group_id = snapshot.data.groups[0].code;
            var date = DateTime.now().millisecondsSinceEpoch.toString();
            var shared = false;

            await database.createSingleTask(taskID, alertTime, date, icon, assignee, title, puid, shared);

            await database.addSingleTask(taskID, puid, group_id, shared);

            setState(() {
              var new_task = single_task.fromMap({
                'icon': icon,
                'id': taskID,
                'title': title,
                'creator': user.uid,
                'days': null,
                'date': date,
                'alert_time': alertTime,
              });
              tasks.add(new_task);

            });
          },
        )
      ],
    );
  }
}




