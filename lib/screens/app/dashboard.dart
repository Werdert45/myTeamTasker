import 'package:collaborative_repitition/components/syncingComponents.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/complete_user.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/screens/app/settingsPage.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/connectionFunctions.dart';
import 'package:collaborative_repitition/services/functions/progressbar.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:collaborative_repitition/services/functions/saveTaskFunctions.dart';
import 'package:connectivity/connectivity.dart';

import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../components/task-tile.dart';
import '../../services/auth.dart';

class DashboardPage extends StatefulWidget {
//  Function(complete_user) callbackParent;
  complete_user user_data;
  bool changedData;

  DashboardPage({this.user_data, this.changedData});

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

  var tasks;
  bool brightness = false;


  void initState() {
    super.initState();
    checkedValue = false;

    tasks = [];

    // Connection check
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });

    getDarkModeSetting().then((val) {
      brightness = val;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh(uid) async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    var new_userData = await streams.getCompleteUser(uid);


    setState(() {
      tasks = new_userData.tasks;
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
//    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
//    items.add((items.length+1).toString());
//    if(mounted)
//      setState(() {
//
//      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    updateUser(new_user) {
      setState(() {
        widget.user_data = new_user;
        widget.changedData = true;
      });

      return new_user;
    }


    getDarkModeSetting().then((val) {
      brightness = val;
    });

    var color = brightness ? darkmodeColor : lightmodeColor;

    tasks = widget.user_data.tasks;
    var finished_tasks = progressBar(tasks);
    var finished_count = finished_tasks[1].length;

    return SingleChildScrollView(
      child: Container(
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
                              Text("Hi, " + widget.user_data.name.split(" ")[0] + "!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white)),
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
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: color['primaryColor']),
                                borderRadius: BorderRadius.all(Radius.circular(125.0)),
                                boxShadow: [
                                  BoxShadow(blurRadius: 4.0, color: Colors.black)
                                ]),
//                          child: Icon(Icons.person, size: 130, color: secondaryColor),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(180),
                              child: Align(
                                  alignment: Alignment.center,
                                  heightFactor: 1,
                                  widthFactor: 0.5,
                                  child: Image(image: FirebaseImage('gs://collaborative-repetition.appspot.com/' + widget.user_data.profile_picture.toString()))),
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
                                MaterialPageRoute(builder: (context) => SettingsPage(widget.user_data))
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
                    color: color['foregroundColor'],
                    border: Border(
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                ),
              ),
              SizedBox(height: 20),
//                      Padding(
//                        padding: EdgeInsets.only(left: 20, bottom: 10),
//                        child: Text("Progess", style: TextStyle(fontSize: 24, color: Colors.grey)),
//                      ),
//                      Padding(
//                        padding: EdgeInsets.symmetric(horizontal: 20.0),
//                        child: new LinearPercentIndicator(
//                          width: MediaQuery.of(context).size.width - 40,
//                          lineHeight: 20.0,
//                          percent: (finished_count / (finished_tasks[0].length + finished_count)),
//                          center: Text(
//                            ((finished_count / (finished_tasks[0].length + finished_count))*100).round().toString() + "%",
//                            style: new TextStyle(fontSize: 12.0),
//                          ),
////                        trailing: Icon(Icons.mood, size: 40),
//                          linearStrokeCap: LinearStrokeCap.roundAll,
//                          backgroundColor: Colors.grey,
//                          progressColor: Colors.blue,
//                        ),
//                      ),
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
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height- 250,
                      child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(),
                        footer: CustomFooter(
                          builder: (BuildContext context,LoadStatus mode){
                            Widget body ;
                            if(mode==LoadStatus.idle){
                              body =  Text("pull up load");
                            }
                            else if(mode==LoadStatus.loading){
                              body =  CircularProgressIndicator();
                            }
                            else if(mode == LoadStatus.failed){
                              body = Text("Load Failed!Click retry!");
                            }
                            else if(mode == LoadStatus.canLoading){
                              body = Text("release to load more");
                            }
                            else{
                              body = Text("No more Data");
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child:body),
                            );
                          },
                        ),
                        controller: _refreshController,
                        onRefresh: () {_onRefresh(user.uid);},
                        onLoading: _onLoading,
                        child: ListView.builder(
                            padding: EdgeInsets.only(top: 10),
                            shrinkWrap: true,
//                                  physics: NeverScrollableScrollPhysics(),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              if (tasks[index].title != "") {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    width: double.infinity,
                                    child: EmoIcon(user_data: widget.user_data, callback: updateUser, task: tasks[index], puid: user.uid, group: widget.user_data.groups[0], parent: this, tasks_history_pers: widget.user_data.personal_history, total_tasks: finished_count, count: tasks.length, color: color),
                                  ),
                                );
                              }
                              else {
                                return SizedBox();
                              }
                            }
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}

