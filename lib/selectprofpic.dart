import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:provider/provider.dart';

import 'services/usermanagement.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

class SelectprofilepicPage extends StatefulWidget {
  final user_name;


  SelectprofilepicPage(this.user_name);


  @override
  _SelectprofilepicPageState createState() => _SelectprofilepicPageState();
}

class _SelectprofilepicPageState extends State<SelectprofilepicPage> {


  final AuthService _auth = AuthService();
  File newProfilePic;
  TextEditingController _controller;

  String _name = '';


  void initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.user_name);
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfilePic = tempImage;
    });
  }

  uploadImage(uid) {
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/${uid.toString()}.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(newProfilePic);



    _auth.setProfileImage(uid, 'profile_pictures/${uid.toString()}.jpg');

    Navigator.pushNamed(context, '/selectgroup');
  }

  UserManagement userManagement = new UserManagement();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return new Scaffold(
        resizeToAvoidBottomInset: false,
        body: newProfilePic == null ? getChooseButton(context) : getUploadButton(user));
  }

  Widget getChooseButton(context) {
    return new Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              color: Color(0xFF572f8c),
              child: Center(
                  child: Text("WELCOME\n" + widget.user_name, style: TextStyle(fontSize: 34, color: Color(0xFFc6bed2),
                      fontWeight: FontWeight.w400), textAlign: TextAlign.center)
              )
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
                            border: Border.all(color: Color(0xFF572f8c)),
                            borderRadius: BorderRadius.all(Radius.circular(125.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ]),
                        child: Icon(Icons.person, size: 130, color: Color(0xFFc6bed2)),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, bottom: 0),
                          child: IconButton(
                            icon: Icon(Icons.add_circle, color: Color(0xFF572f8c)),
                            onPressed: getImage,
                            iconSize: 50,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                Text(
                  'Choose an avatar',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFF572f8c),
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 55.0),
                TextField(
                  onChanged: (val) {
                    setState(() => _name = val);
                  },
                  controller: _controller,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    prefixText: "df",
                    prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                    focusColor: Color(0xFFc6bed2),
                    fillColor: Color(0xFFc6bed2),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                    ),
                    hintText: 'Enter Email',
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            )),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30, bottom: 15),
            child: RaisedButton(
                onPressed: getImage,
                textColor: Color(0xFFc6bed2),
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Color(0xFF572f8c),
                child: Container(
                    child: Text("SELECT IMAGE", style: TextStyle(fontSize: 12))
                )
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(right: 40, bottom: 30),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                "SKIP",
                style: TextStyle(color: Color(0xFF572f8c), fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        Positioned(
            top: 30,
            left: 10,
            child: IconButton(
                icon: Icon(Icons.arrow_back, size: 25, color: Colors.white),
                onPressed: () { Navigator.pop(context); }
            )
        )
      ],
    );
  }

  Widget getUploadButton(user) {
    return new Stack(
      children: <Widget>[

        Align(
          alignment: Alignment.topCenter,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              color: Color(0xFF572f8c),
              child: Center(
                  child: Text("CHOOSE PICTURE", style: TextStyle(fontSize: 34, color: Color(0xFFc6bed2),
                      fontWeight: FontWeight.w400), textAlign: TextAlign.center)
              )
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
                          child: IconButton(
                            icon: Icon(Icons.add_circle, color: Color(0xFF572f8c)),
                            onPressed: getImage,
                            iconSize: 50,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(height: 30.0),
                SizedBox(height: 55.0),
                TextField(
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    prefixText: "df",
                    prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                    focusColor: Color(0xFFc6bed2),
                    fillColor: Color(0xFFc6bed2),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                    ),
                    hintText: 'Enter Email',
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            )),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30, bottom: 15),
            child: RaisedButton(
                onPressed: () {uploadImage(user.uid);},
                textColor: Color(0xFFc6bed2),
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Color(0xFF572f8c),
                child: Container(
                    child: Text("CONTINUE", style: TextStyle(fontSize: 12))
                )
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(right: 40, bottom: 30),
            child: GestureDetector(
              onTap: getImage,
              child: Text(
                "CHOOSE OTHER",
                style: TextStyle(color: Color(0xFF572f8c), fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        Positioned(
            top: 30,
            left: 10,
            child: IconButton(
                icon: Icon(Icons.arrow_back, size: 25, color: Colors.white),
                onPressed: () { Navigator.pop(context); }
            )
        ),
      ],
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
