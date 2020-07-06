//import 'dart:html';
import 'dart:io';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task-tile.dart';
import 'components/button.dart';
import 'services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:async';


const String kTestString = 'Hello world!';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool checkedValue;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  final AuthService _auth = AuthService();
  final Streams streams = Streams();
  final DatabaseService database = DatabaseService();
  final FirebaseStorage storage = FirebaseStorage(storageBucket: 'gs://collaborative-repetition.appspot.com/');

  Future<void> _downloadFile(StorageReference ref) async {
    final String url = await ref.getDownloadURL();
    final String uuid = Uuid().v1();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/tmp$uuid.txt');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    assert(await tempFile.readAsString() == "");
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    final String tempFileContents = await tempFile.readAsString();
    assert(tempFileContents == kTestString);
    assert(byteCount == kTestString.length);

    final String fileContents = downloadData.body;
    final String name = await ref.getName();
    final String bucket = await ref.getBucket();
    final String path = await ref.getPath();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Success!\n Downloaded $name \n from url: $url @ bucket: $bucket\n '
            'at path: $path \n\nFile contents: "$fileContents" \n'
            'Wrote "$tempFileContents" to tmp.txt',
        style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0)),
      ),
    ));
  }

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
          tasks = snapshot.data.tasks;



          _downloadFile(snapshot.data.profile_picture);

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
                            child: SizedBox(),
                          ),
                        )
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

                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
//                    height: 800,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
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
                              return Container(
                                width: double.infinity,
                                child: EmoIcon(tasks[index], user.uid, snapshot.data.groups[0], this),
                              );
                            }
                        ),
                      ],
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
