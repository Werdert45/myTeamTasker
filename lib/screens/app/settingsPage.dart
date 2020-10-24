import 'dart:io';

import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/main.dart';
import 'package:collaborative_repitition/models/group.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/notifications_lib/builder/RemindersListViewBuilder.dart';
import 'package:collaborative_repitition/notifications_lib/models/index.dart';
import 'package:collaborative_repitition/notifications_lib/store/AppState.dart';
import 'package:collaborative_repitition/notifications_lib/utils/notificationHelper.dart';
import 'package:collaborative_repitition/screens/app/partials/groupsettings.dart';
import 'package:collaborative_repitition/screens/app/settings_sub/changeEmail.dart';
import 'package:collaborative_repitition/screens/app/settings_sub/changePassword.dart';
import 'package:collaborative_repitition/screens/app/settings_sub/changeProfilePicture.dart';
import 'package:collaborative_repitition/screens/app/settings_sub/notificationSettings.dart';
import 'package:collaborative_repitition/screens/authentication/create_group.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:collaborative_repitition/services/usermanagement.dart';
import 'package:collaborative_repitition/theme_changer.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';


class SettingsPage extends StatefulWidget {
  final data;

  SettingsPage(this.data);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();
  final userManagement = UserManagement();
  final DatabaseService database = DatabaseService();


  TextEditingController _groupCodeController;
  var _groupCode = "";
  List groupsList = [];

  bool isDark = false;
  bool sendNotifications = false;

  bool wrongGroupCode = false;
  bool brightness = false;
  // Set the standard settings
//
//  // Notifications
//  bool notify = false;

  // Something
  bool isSwitched = false;
  var user_data;

  bool changePassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDarkModeSetting().then((val) {
      brightness = val;
    });
  }

  @override

  Widget build(BuildContext context) {

    user_data = widget.data;
    var user = Provider.of<User>(context);
    getDarkModeSetting().then((val) {
      brightness = val;
    });
    

    var color = brightness ? darkmodeColor : lightmodeColor;

    groupsList = user_data.groups;
    
    return FutureBuilder(
      future: initSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          isDark = snapshot.data[0];
          sendNotifications = snapshot.data[2];


          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Column(
                    children: [
                      wrongGroupCode ?
                      GestureDetector(
                          child: Container(
                              color: Colors.red,
                              width: MediaQuery.of(context).size.width - 140,
                              height: 40,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: Center(
                                      child: Text("Wrong group code, try again")
                                  )
                              )
                          ),
                          onTap: () {
                            setState(() {
                              wrongGroupCode = false;
                            });
                          }
                      ) : SizedBox(),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 170,
                        decoration: BoxDecoration(
                            color: color['foregroundColor'],
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
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeProfilePicturePage(user_data)));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(35),
                                        child: Align(
                                            alignment: Alignment.center,
                                            heightFactor: 1,
                                            widthFactor: 0.5,
                                            child: Image(image: FirebaseImage('gs://collaborative-repetition.appspot.com/' + user_data.profile_picture.toString()))),
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
                                        Text(user_data.name, style: TextStyle(fontSize: 20, color: Colors.white))
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
                                    value: isDark,
                                    onChanged: (value) {
                                      if (value) {
                                        ThemeBuilder.of(context).changeTheme(Brightness.dark);
                                      }

                                      else {
                                        ThemeBuilder.of(context).changeTheme(Brightness.light);
                                      }

                                      darkModeToSF(value);

                                      setState(() {
                                        isDark = value;
                                      });
                                    },
                                    activeTrackColor: color['primaryColorFocus'],
                                    activeColor: color['primaryColor'],
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.language),
                                  title: Text("Language"),
                                  trailing: Text("English"),
                                ),
                                ListTile(
                                  onTap: () async {
                                    await _auth.signOut();
                                    Navigator.pushReplacementNamed(context, '/landingpage');
                                  },
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
                        height: changePassword ? 400 : 200,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          primary: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: ListTile.divideTiles(
                              context: context,
                              tiles: [
                                ListTile(
                                  leading: Icon(Icons.notifications),
                                  title: Text("Notifications"),
                                  trailing: Switch(
                                    value: sendNotifications,
                                    onChanged: (value) {
                                      notificationsToSF(value);

                                      setState(() {
                                        sendNotifications = value;
                                      });
                                    },
                                    activeTrackColor: color['primaryColorFocus'],
                                    activeColor: color['primaryColor'],
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.email),
                                  title: Text("Change email"),
                                  trailing: Container(
                                    width: 155,
                                    height: 30,
                                    child: Row(
                                      children: [
                                        Text(user_data.email.toLowerCase()),
                                        SizedBox(width: 4,),
                                        Icon(Icons.arrow_forward_ios, size: 12,)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmail(email: user_data.email)));
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.lock),
                                  title: Text("Change password"),
                                  trailing: Container(
                                    width: 94,
                                    height: 30,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Text("***********"),
                                        ),
                                        SizedBox(width: 4,),
                                        Icon(Icons.arrow_forward_ios, size: 12,)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(email: user_data.email)));
                                  },
                                ),
//                  changePassword ? Container(height: 200, width: double.infinity, color: Colors.red) : SizedBox()
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
                      ListTile(
                        leading: Icon(Icons.add),
                        title: Text("Create new group"),
                        trailing: Icon(Icons.arrow_forward_ios, size: 12,),
                        onTap: () async {
                          var newGroupsList = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupPage(groupList: groupsList)));

                          setState(() {
                            groupsList = newGroupsList;
                          });
                        },
                      ),
                      Container(
                          height: 60.0 * groupsList.length + 0.0,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: groupsList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(Icons.group),
                                title: Text(groupsList[index].name),
                                trailing: Icon(Icons.arrow_forward_ios, size: 12),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => GroupSettings(group: groupsList[index])));
                                },
                              );
                            },
                          )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _groupCodeController,
                                validator: (val) => val.isEmpty ? 'No description provided' : null,
                                onChanged: (val) {
                                  _groupCode = val;
                                },
                                textCapitalization: TextCapitalization.none,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                            labelText: "Task Title",
                                  prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                                  focusColor: color['primaryColor'],
                                  fillColor: Color(0xFFE0E0E0),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2)
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2)
                                  ),
                                    hintText: 'Insert Group Code'
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: GestureDetector(
                                onTap: () async {
                                  var result = await database.addGroupToUser(_groupCode, user.uid, widget.data.name);
                                  print(result != "error");

                                  if (result != "error")
                                  {
                                    setState(() {
                                      groupsList = groupsList + [result];
                                    });

                                  }
                                  else {
                                    setState(() {
                                      wrongGroupCode = true;
                                    });
                                  }
                                },
                                child: Container(
                                    color: Colors.green, child: Icon(Icons.add, size: 25),
                                  width: 45,
                                  height: 45
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 1,
                          color: Colors.grey
                      ),
                      ListTile(
                        leading: Icon(Icons.library_books),
                        title: Text("Licensing"),
                        onTap: _launchURL,
                      )
                    ],
                  ),
                ),
              ),
            ),
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
    );
  }
}

_launchURL() async {
  const url = 'https://ianronk.nl/privacy_policy/taskcollab';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}