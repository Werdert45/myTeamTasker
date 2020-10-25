import 'package:collaborative_repitition/components/active-task-tile.dart';
import 'package:collaborative_repitition/components/syncingComponents.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/connectionFunctions.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskManagerPage extends StatefulWidget {
  final user_data;

  TaskManagerPage({this.user_data});


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

  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  var tasks;

  var showPersonal = true;

  var single_shared = false;
  var repeated_shared = false;

  var single_personal = false;
  var repeated_personal = false;

  bool brightness = false;

  void initState() {
    super.initState();
    checkedValue = false;

    isShowSticker = false;
    categories = Emoji(name: 'Sailboat', emoji: '👑');

    // Connection check
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

    getDarkModeSetting().then((val) {
      brightness = val;
    });
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
    getDarkModeSetting().then((val) {
      brightness = val;
    });

    var color = brightness ? darkmodeColor : lightmodeColor;

    var tasks = widget.user_data.tasks;

    return Scaffold(
      body: SingleChildScrollView(
          child: connected(_source) ?
          Stack(
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
                              padding: EdgeInsets.only(left: 30, top: 20),
                              child: Text("Task Manager", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: color['primaryColor'],
                          border: Border(
                          ),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new OutlineButton(
                                  child: Row(
                                    children: <Widget>[
//                                              IconButton(icon: Icon(Icons.account_circle)),
                                      Text("Personal Tasks"),
//                                              SizedBox(width: 8)
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPersonal = true;
                                    });
                                  },
                                  color: showPersonal ? Colors.blue : Colors.white,
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                              ),
                              SizedBox(width: 40),
                              new OutlineButton(
                                  child: Row(
                                    children: <Widget>[
//                                              IconButton(icon: Icon(Icons.group)),
                                      Text("Group Tasks"),
//                                                SizedBox(width: 8)
                                    ],
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPersonal = false;
                                    });
                                  },
                                  color: !showPersonal ? Colors.blue : Colors.white,
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                              ),
                            ],
                          )
                      ),
                    ),
                    showPersonal ? PersonalPage(widget.user_data, user, color) : GroupPage(widget.user_data, user, color),
                  ],
                ),
                checkConnectivity(_source, context, true),
              ]
          ) :
          Stack(
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
                              padding: EdgeInsets.only(left: 30, top: 20),
                              child: Text("Task Manager", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: color['primaryColor'],
                          border: Border(
                          ),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                      ),
                    ),
                    Text("Offline, manage your tasks later, when online again.")
                  ],
                ),
                checkConnectivity(_source, context, true),
              ]
          )
      ),
    );
  }

  Widget GroupPage(snapshot, user, color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Group Tasks", style: TextStyle(fontSize: 24, color: color['primaryColor'])),
        ),
        ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.tasks.length,
            itemBuilder: (context, index) {
              if (snapshot.tasks[index].shared) {
                return Container(
                  width: double.infinity,
                  child: ActiveTask(snapshot.tasks[index], user.uid, snapshot.groups[0], this, snapshot),
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

  Widget PersonalPage(snapshot, user, color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20),
          child: Text("Personal Tasks", style: TextStyle(fontSize: 24, color: color['primaryColor'])),
        ),
        ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.tasks.length,
            itemBuilder: (context, index) {
              if (!snapshot.tasks[index].shared) {
                return Container(
                  width: double.infinity,
                  child: ActiveTask(snapshot.tasks[index], user.uid, snapshot.groups[0], this, snapshot),
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




