import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user, context) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/selectpic');
    }).catchError((e) {
      print(e);
    });
  }

  Future updateEmail(email) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    user.updateEmail(email).then((_) {
      print("Succesfully changed password");
      return true;
    }).catchError((error) {
      print("Password wasn't changed, due to: " + error.toString());
      return false;
    });
  }

  Future updatePassword(password) async {
    //Create an instance of the current user.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_){
      print("Succesfull changed password");
    }).catchError((error){
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  Future updateProfilePic(picUrl) async {
    var userInfo = new UserUpdateInfo();
    userInfo.photoUrl = picUrl;
  }

  Future updateNickName(String newName) async {
    var userInfo = new UserUpdateInfo();
    userInfo.displayName = newName;
  }
}
