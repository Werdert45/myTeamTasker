import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:collaborative_repitition/services/usermanagement.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

class ChangeProfilePicturePage extends StatefulWidget {
  final user;

  ChangeProfilePicturePage(this.user);


  @override
  _ChangeProfilePicturePageState createState() => _ChangeProfilePicturePageState();
}

class _ChangeProfilePicturePageState extends State<ChangeProfilePicturePage> {

  final AuthService _auth = AuthService();
  DatabaseService database = DatabaseService();
  File newProfilePic;
  TextEditingController _controller;

  String _name;


  void initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.user.name);
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 800);
    setState(() {
      newProfilePic = tempImage;
    });
  }

  uploadImage(uid) async {
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/${uid.toString()}.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(newProfilePic);
    await _auth.setProfileImage(uid, 'profile_pictures/${uid.toString()}.jpg');
  }

  UserManagement userManagement = new UserManagement();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    _name = widget.user.name;

    var brightness = SchedulerBinding.instance.window.platformBrightness;


    var color = brightness == Brightness.light ? lightmodeColor : darkmodeColor;



    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: newProfilePic == null ? getChooseButton(context, user, color) : getUploadButton(user, color));
  }

  Widget getChooseButton(context, user, color) {
    return SafeArea(
      child: new Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Change Profile Settings", style: TextStyle(fontSize: 24)),
            ),
          ),
          Positioned(
              width: 350.0,
              top: MediaQuery.of(context).size.height / 5,
              left: MediaQuery.of(context).size.width / 2 - 175,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 220,
                    width: 220,
                    child: Stack(
                      children: [
                        Container(
                          width: 220.0,
                          height: 220.0,
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
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Align(
                                alignment: Alignment.center,
                                heightFactor: 0.5,
                                widthFactor: 1,
                                child: Image(image: FirebaseImage('gs://collaborative-repetition.appspot.com/' + widget.user.profile_picture))),
                          ),
                        ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 0, bottom: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: color['primaryColor']
                              ),
                              child: IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: getImage,
                                iconSize: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'CHANGE PICTURE',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 55.0),
                  Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Text("NAME", style: TextStyle(fontSize: 16, color: Colors.grey))
                  ),
                  TextFormField(
                    controller: _controller,
                    validator: (val) => val.isEmpty ? 'No description provided' : null,
                    onChanged: (val) {
                      setState(() => _name = val);
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
                        hintText: "New email address"
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              )),
          Positioned(
              left: 10,
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 25, color: Colors.black),
                  onPressed: () async {
                    try {
                      if (_name != widget.user.name) {
                        await database.updateName(user.uid, _name);
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      return e;
                    }


                  }
              )
          )
        ],
      ),
    );
  }

  Widget getUploadButton(user, color) {
    return SafeArea(
      child: new Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Change Profile Settings", style: TextStyle(fontSize: 24)),
            ),
          ),
          Positioned(
              width: 350.0,
              top: MediaQuery.of(context).size.height / 5,
              left: MediaQuery.of(context).size.width / 2 - 175,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 220,
                    width: 220,
                    child: Stack(
                      children: [
                        Container(
                            width: 220.0,
                            height: 220.0,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                image: DecorationImage(
                                    image: FileImage(newProfilePic), fit: BoxFit.cover),
                                borderRadius: BorderRadius.all(Radius.circular(110.0)),
                                boxShadow: [
                                  BoxShadow(blurRadius: 7.0, color: Colors.black)
                                ])),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 0, bottom: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: color['primaryColor']
                              ),
                              child: IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: getImage,
                                iconSize: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'CHANGE PICTURE',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(height: 55.0),
                  Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Text("NAME", style: TextStyle(fontSize: 16, color: Colors.grey))
                  ),
                  TextFormField(
                    controller: _controller,
                    validator: (val) => val.isEmpty ? 'No description provided' : null,
                    onChanged: (val) {
                      setState(() => _name = val);
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
                        hintText: "New email address"
                    ),
                  ),
                  SizedBox(height: 30.0),
                ],
              )),
          Positioned(
              left: 10,
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 25, color: Colors.black),
                  onPressed: () async {
                    try {
                      // save the name if the name has been changed
                      if (_name != widget.user.name) {
                        await database.updateName(user.uid, _name);
                      }
                      // upload the image to firebase as it has been changed
                      uploadImage(user.uid);

                      Navigator.pop(context);
                    } catch (e) {
                      return e;
                    }
                  }
              )
          )
        ],
      ),
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
