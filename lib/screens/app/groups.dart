import 'package:collaborative_repitition/components/active-task-tile.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_repitition/components/add_task.dart';

class TaskManagerPage extends StatefulWidget {
  @override
  _TaskManagerPageState createState() => _TaskManagerPageState();
}

class _TaskManagerPageState extends State<TaskManagerPage> {
  bool checkedValue;
  bool isShowSticker;
  var categories;

  final AuthService _auth = AuthService();
  final Streams streams = Streams();
  final DatabaseService database = DatabaseService();

  var tasks = [];

  var showPersonal = true;

  void initState() {
    super.initState();
    checkedValue = false;

    isShowSticker = false;
    categories = Emoji(name: 'Sailboat', emoji: '👑');

    tasks = [];
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<User>(context);

    return Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: streams.getAllTasks(user.uid),
              builder: (context, snapshot) {
                tasks = snapshot.data.tasks;
                return Stack(
                    children: [
                      Column(
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
                          showPersonal ? PersonalPage(snapshot, user) : GroupPage(snapshot, user),
                        ],
                      ),
                    ]
                );
              }
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
//                        addTaskWidget;
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple,
          heroTag: "add_task",
        ),
    );
  }

  Widget GroupPage(snapshot, user) {
    print(snapshot.data.tasks);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 5),
          child: Text("Group Tasks", style: TextStyle(fontSize: 24, color: Color(0xFF572f8c))),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Single Tasks", style: TextStyle(fontSize: 18, color: Color(0xFF572f8c))),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {
              if (tasks[index].shared && !tasks[index].repeated) {
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
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Repeated Tasks", style: TextStyle(fontSize: 18, color: Color(0xFF572f8c))),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {
              if (tasks[index].shared && tasks[index].repeated) {
                print("RETURN NOW");
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
      ],
    );
  }

  Widget PersonalPage(snapshot, user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Personal Tasks", style: TextStyle(fontSize: 24, color: Color(0xFF572f8c))),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Single Tasks", style: TextStyle(fontSize: 18, color: Color(0xFF572f8c))),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {
              if (!tasks[index].shared && !tasks[index].repeated) {
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
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Repeated Tasks", style: TextStyle(fontSize: 18, color: Color(0xFF572f8c))),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {
              if (!tasks[index].shared && tasks[index].repeated) {
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
      ],
    );
  }

}




