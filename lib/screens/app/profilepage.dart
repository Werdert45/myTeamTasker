import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/usermanagement.dart';
import 'package:collaborative_repitition/components/task-tile.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool checkedValue;
  var _controller;
  var name;
  var picture;

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
          tasks = snapshot.data.tasks;

          _controller = new TextEditingController(text: snapshot.data.name);

          return Container(
              child: Stack(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10, top: 30),
                              child: IconButton(
                                icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30),
                                onPressed: () async {
                                  await _auth.signOut();
                                  Navigator.pushReplacementNamed(context, '/landingpage');
                                },
                              ),
                            )
                        )
                      ],
                    ),
                    height: MediaQuery.of(context).size.height / 5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFF572f8c),
                        border: Border(
                        ),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            child: Stack(
                                children: [
                                  Container(
                                    width: 200,
                                    height: 200,
                                    child: Align(
                                        alignment: Alignment.center,
                                        heightFactor: 0.5,
                                        widthFactor: 1,
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: FirebaseImage('gs://collaborative-repetition.appspot.com/' + snapshot.data.profile_picture.toString(),
                                                  ), fit: BoxFit.cover
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(110.0)),
                                          ),
                                        )
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      icon: Icon(Icons.add_circle, size: 40),
                                      onPressed: () {
                                      },
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 250,
                            child: TextField(
                              autofocus: false,
                              onChanged: (val) {
                                setState(() => name = val);
                              },
                              controller: _controller,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                                labelText: "Name",
                                prefixText: "df",
                                  labelStyle: TextStyle(color: Colors.grey),
                                  prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                                  focusColor: Color(0xFF572f8c),
                                  fillColor: Color(0xFF572f8c),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(color: Color(0xFF572f8c), width: 2)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(color: Color(0xFF572f8c), width: 2)
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide(color: Color(0xFF572f8c), width: 2)
                                  ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Personal Tasks", style: TextStyle(fontSize: 24)),
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
                                  SizedBox(height: 20),
                                  Text("Groups", style: TextStyle(fontSize: 24)),
                                  ListView.builder(
                                    shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data.groups.length,
                                      itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(snapshot.data.groups[index].name),
                                        subtitle: Text(snapshot.data.groups[index].description),
                                        trailing: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 12),
                                            Text("Tasks: " + snapshot.data.groups[index].repeated_tasks.length.toString()),
                                            SizedBox(height: 2),
                                            Text("Members: " + snapshot.data.groups[index].members.length.toString())
                                          ],
                                        ),
                                      );
                                      }
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  )
                ],
              )
          );
        },
      ),
    );
  }
}

