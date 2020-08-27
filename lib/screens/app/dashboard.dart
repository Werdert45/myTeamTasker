import 'package:collaborative_repitition/components/syncingComponents.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/screens/app/settingsPage.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/connectionFunctions.dart';
import 'package:collaborative_repitition/services/functions/progressbar.dart';
import 'package:collaborative_repitition/services/functions/saveTaskFunctions.dart';

import 'package:connectivity/connectivity.dart';

import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../components/task-tile.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../services/auth.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();


  static _DashboardPageState of(BuildContext context) {
    return context.findAncestorStateOfType<_DashboardPageState>();
  }
}

class _DashboardPageState extends State<DashboardPage> {

  bool checkedValue;

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

  refresh() {
    setState(() {});
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
              var tasks = snapshot.data.tasks;

              var finished_tasks = progressBar(tasks);
              var finished_count = finished_tasks[1].length;

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
                            checkConnectivity(_source, context, true)
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
                          percent: (finished_count / (finished_tasks[0].length + finished_count)),
                          center: Text(
                            ((finished_count / (finished_tasks[0].length + finished_count))*100).round().toString() + "%",
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
                                  if (snapshot.data.tasks[index].title != "") {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Container(
                                        width: double.infinity,
                                        child: EmoIcon(refresh, tasks[index], user.uid, snapshot.data.groups[0], this, snapshot.data.personal_history, finished_count, tasks.length),
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
      ),
    );
  }
}

