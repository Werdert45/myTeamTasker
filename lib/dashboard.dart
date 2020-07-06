import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task-tile.dart';
import 'components/button.dart';
import 'services/auth.dart';

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
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return SingleChildScrollView(
      child: FutureBuilder(
        future: streams.getCompleteUser(user.uid),
        builder: (context, snapshot) {
          print(snapshot);


          tasks = snapshot.data.tasks;
          return Container(
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: RaisedButton(
                        onPressed: () async {
                          await _auth.signOut();
                        },
                        child: Text("Logout"),
                      ),
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

                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
//                    height: 800,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.tasks.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: double.infinity,
                            child: EmoIcon(tasks[index], user.uid, snapshot.data.groups[0], this),
                          );
                        }
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () async {
                      var taskID = (user.uid + DateTime.now().millisecondsSinceEpoch.toString());
                      var alertTime = '14:15';
                      var assignee = user.uid;
                      var puid = user.uid;
                      var days = [false, false, false, false, false, false, false];
                      var icon = "😇";
                      var title = "New Task";
                      var group_id = snapshot.data.groups[0];

                      await database.createRepeatedTask(taskID, alertTime, assignee, puid, days, icon, title);

                      await database.addRepeatedTaskToGroup(taskID, puid, group_id);

                      setState(() {
                        var new_task = repeated_task.fromMap({
                          'icon': icon,
                          'id': taskID,
                          'title': title,
                          'creator': user.uid,
                          'days': days,
                          'alert_time': alertTime
                        });
                        tasks.add(new_task);
                      });
                    },
                  )
                ],
              )
          );
        },
      ),
    );
  }
}
