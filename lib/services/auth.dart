import 'package:collaborative_repitition/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collaborative_repitition/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //  Create user obj based on Firebase user
  User userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(userFromFirebaseUser);
  }

  Future registerWithEmail(String email, String password, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).createUser(user.uid, name, email);
      return userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return e.message;
    }
  }

  Future setProfileImage(String uid, String image_path) async {
    try {
      await DatabaseService(uid: uid).setProfilePicture(uid, image_path);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  // sign in with email and password
  Future signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (e) {
      print(e.toString());
      return e.message;
    }
  }


  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}