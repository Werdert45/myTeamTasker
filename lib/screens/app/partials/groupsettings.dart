import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/group.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class GroupSettings extends StatefulWidget {
  final group;

  GroupSettings({this.group});

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  final DatabaseService database = DatabaseService();

  var selection = 0;

  TextEditingController _groupNameController;
  TextEditingController _groupDescriptionController;

  var groupName;
  var groupDescription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    TextEditingController _groupNameController;
    TextEditingController _groupDescriptionController;

  }



  @override
  Widget build(BuildContext context) {
    _groupNameController = TextEditingController(text: widget.group.name);
    _groupDescriptionController = TextEditingController(text: widget.group.description);

    groupName = widget.group.name;
    groupDescription = widget.group.description;


    var members = widget.group.members.values.toList();
    var user = Provider.of<User>(context);
    var brightness = SchedulerBinding.instance.window.platformBrightness;


    var color = brightness == Brightness.light ? lightmodeColor : darkmodeColor;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 12),
                  child: GestureDetector(
                    onTap: () async {
                      // await the saving of the changes first
                      try {
                        print(groupDescription);
                        if (groupDescription != widget.group.description || groupName != widget.group.name) {
                          await database.updateGroup(groupName, groupDescription, widget.group.code);
                        }

                        Navigator.pop(context);
                      } catch (e) {
                        return e;
                      }
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(groupName, style: TextStyle(fontSize: 24)),
                ),
              ),
              Positioned(
                top: 60,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("GROUP NAME", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: _groupNameController,
                          validator: (val) => val.isEmpty ? 'No description provided' : null,
                          onChanged: (val) {
                            groupName = val;
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
                              hintText: "First ever group"
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("DESCRIPTION", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5),
                        TextFormField(
                          minLines: 4,
                          maxLines: 4,
                          keyboardType: TextInputType.emailAddress,
                          controller: _groupDescriptionController,
                          validator: (val) => val.isEmpty ? 'No description provided' : null,
                          onChanged: (val) {
                            groupDescription = val;
                          },
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                              hintText: "The small description"
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("MEMBERS", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5),
                        Container(
                          height: 250,
                          child: ListView.builder(
                            physics: members.length <= 3 ? NeverScrollableScrollPhysics() : null,
                            itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 1.5, color: Colors.black12),
                                    ),
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(35),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Align(
                                              alignment: Alignment.center,
                                              heightFactor: 0.5,
                                              widthFactor: 1,
                                              child: Image(image: FirebaseImage('gs://collaborative-repetition.appspot.com/profile_pictures/7xKIeduBjIMWpGqQynUckKIPjiu1.jpg'))),
                                        ),
                                      ),
                                    ),
                                    title: Text("Ian Ronk"),
//                                    subtitle: admin ? Text("ADMIN") : SizedBox(),
//                                    trailing: index == 0 ? _simplePopup() : SizedBox()
                                  ),
                                );
                            },
                            itemCount: members.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 20,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      await database.leaveGroup(user.uid, widget.group.code);

                      Navigator.pop(context);
                    } catch (e) {
                      return e;
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text("LEAVE GROUP", style: TextStyle(color: Colors.white, fontSize: 18))
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }


  Widget _simplePopup() => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            SizedBox(width: 8),
            Text("Remove this user")
          ],
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: Row(
          children: [
            Icon(Icons.person, color: Colors.green),
            SizedBox(width: 8),
            Text("Set as admin")
          ],
        ),
      ),
    ],
    onSelected: (value) {
      if (value == 1) {
        // Show dialog to remove user from the group
      }

      else if (value == 2) {
        // Show dialog to set user as admin
      }
    },
  );
}
