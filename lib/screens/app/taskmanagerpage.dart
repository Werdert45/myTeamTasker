import 'package:collaborative_repitition/components/active-task-tile.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  var single_shared = false;
  var repeated_shared = false;

  var single_personal = false;
  var repeated_personal = false;


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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<User>(context);

    return Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: streams.getAllTasks(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
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
                                  color: primaryColor,
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
                else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }
          ),
        ),
    );
  }

  Widget GroupPage(snapshot, user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 5),
          child: Text("Group Tasks", style: TextStyle(fontSize: 24, color: primaryColor)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Single Tasks", style: TextStyle(fontSize: 18, color: primaryColor)),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {
              if (tasks[index].shared && !tasks[index].repeated) {
//                setState(() {
//                  single_shared = true;
//                });

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
        (single_shared ? SizedBox() : Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Text("No Single Tasks yet, add one using the big button"))),

        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Repeated Tasks", style: TextStyle(fontSize: 18, color: primaryColor)),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {


              if (tasks[index].shared && tasks[index].repeated) {
//                setState(() {
//                  repeated_shared = true;
//                });

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
        (repeated_shared ? SizedBox() : Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Text("No Repeated Tasks yet, add one using the big button"))),
      ],
    );
  }

  Widget PersonalPage(snapshot, user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Personal Tasks", style: TextStyle(fontSize: 24, color: primaryColor)),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Single Tasks", style: TextStyle(fontSize: 18, color: primaryColor)),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {
              if (!tasks[index].shared && !tasks[index].repeated) {
//                setState(() {
//                  single_personal = true;
//                });

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
        (single_personal ? SizedBox() : Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Text("No Single Tasks yet, add one using the big button"))),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Repeated Tasks", style: TextStyle(fontSize: 18, color: primaryColor)),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.tasks.length,
            itemBuilder: (context, index) {
              if (!tasks[index].shared && tasks[index].repeated) {

//                setState(() {
//                  repeated_personal = true;
//                });

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
        (repeated_personal ? SizedBox() : Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Text("No Repeated Tasks yet, add one using the big button"))),
      ],
    );
  }

}



