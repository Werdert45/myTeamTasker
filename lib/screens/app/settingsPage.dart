import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';


class SettingsPage extends StatefulWidget {
  final data;

  SettingsPage(this.data);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;

  @override

  Widget build(BuildContext context) {

    var user = Provider.of<User>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 170,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(21, 105, 94, 1),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: EdgeInsets.only(left: 20, top: 20),
                            child: Container(
                              width: 70,
                              height: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Align(
                                      alignment: Alignment.center,
                                      heightFactor: 0.5,
                                      widthFactor: 1,
                                      child: Image(image: FirebaseImage('gs://collaborative-repetition.appspot.com/' + widget.data.profile_picture.toString()))),
                                ),
                              ),
                            )
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: EdgeInsets.only(left: 110, top: 50),
                            child: Container(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Change your settings,", style: TextStyle(color: Colors.white70)),
                                  Text(widget.data.name, style: TextStyle(fontSize: 20, color: Colors.white))
                                ],
                              ),
                            )
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 70,
                      height: 1,
                      color: Colors.grey,
                    ),
                    Text("General"),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 70,
                      height: 1,
                      color: Colors.grey,
                    )
                  ],
                ),
                Container(
                  height: 200,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: ListTile.divideTiles(
                        context: context,
                      tiles: [
                        ListTile(
                          leading: Icon(Icons.brightness_3),
                            title: Text("Dark Mode"),
                          trailing: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                                print(isSwitched);
                              });
                            },
                            activeTrackColor: Colors.blue,
                            activeColor: Colors.blueAccent,
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.language),
                            title: Text("Language"),
                          trailing: Text("English"),
                        ),
                        ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text("Logout"),
                          trailing: Icon(Icons.arrow_forward_ios, size: 12,),
                        )
                      ]
                    ).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 70,
                      height: 1,
                      color: Colors.grey,
                    ),
                    Text("Personal"),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 70,
                      height: 1,
                      color: Colors.grey,
                    )
                  ],
                ),
                Container(
                  height: 200,
                  child: ListView(
                    primary: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: ListTile.divideTiles(
                        context: context,
                        tiles: [
                          ListTile(
                            leading: Icon(Icons.notifications),
                            title: Text("Notify for each task"),
                            trailing: Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  print(isSwitched);
                                });
                              },
                              activeTrackColor: Colors.blue,
                              activeColor: Colors.blueAccent,
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text("Change email"),
                            trailing: Text("ianronk0@gmail.com"),
                          ),
                          ListTile(
                            leading: Icon(Icons.lock),
                            title: Text("Change password"),
                            trailing: Text("********"),
                          )
                        ]
                    ).toList(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 100,
                      height: 1,
                      color: Colors.grey,
                    ),
                    Text("Manage Groups"),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 100,
                      height: 1,
                      color: Colors.grey,
                    )
                  ],
                ),
                Container(
                  height: 200,
                  child: ListView(
                    primary: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: ListTile.divideTiles(
                        context: context,
                        tiles: [
                          ListTile(
                            leading: Text("T"),
                            title: Text("First ever group"),
                            trailing: Icon(Icons.arrow_forward_ios, size: 12,),
                          ),
                          ListTile(
                            leading: Text("T"),
                            title: Text("My Groupie 1"),
                            trailing: Icon(Icons.arrow_forward_ios, size: 12,),
                          ),
                          ListTile(
                            leading: Text("T"),
                            title: Text("The Fam"),
                            trailing: Icon(Icons.arrow_forward_ios, size: 12,),
                          )
                        ]
                    ).toList(),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 1,
                  color: Colors.grey
                ),
                ListTile(
                  leading: Icon(Icons.library_books),
                  title: Text("Licensing"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
