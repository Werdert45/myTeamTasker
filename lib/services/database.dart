import 'package:cloud_firestore/cloud_firestore.dart';

// TODO get all recent catches from the database and all of the species

// @author Ian Ronk
// @class DatabaseService
class Streams {

  final String uid;
  Streams({ this.uid});

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final CollectionReference groupsCollection = Firestore.instance.collection('groups');


  Stream<DocumentSnapshot> get users {
    return usersCollection.document(uid).snapshots();
  }

  Stream<DocumentSnapshot> get groups {
    return groupsCollection.document(uid).snapshots();
  }
}

class DatabaseService {

  final String uid;

  DatabaseService({ this.uid});

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final CollectionReference groupsCollection = Firestore.instance.collection('groups');


  Future createUser(puid, name, email) async {
    await usersCollection.document(puid).setData({
      'uid': puid,
      'email': email,
      'name': name,
      'profile_picture': 'placeholder',
      'groups': [],
      'personal_tasks': []
    });

  }

  Future setProfilePicture(puid, image_path) async {
    await usersCollection.document(puid).updateData({
      'profile_picture': image_path
    });
  }

  Future addToGroup(puid, group_code) async {
    try {
      await groupsCollection.document(group_code).updateData({
        'members': FieldValue.arrayUnion([puid])
      });

      await usersCollection.document(puid).updateData({
        'groups': FieldValue.arrayUnion([group_code])
      });

      print("SUCCESS");
      return "finished";
    } catch (e) {
      return e;
    }

  }

  Future createGroup(puid, group_name, group_description) async {
    var group_code = puid.toString().substring(0,6).toUpperCase();

    await groupsCollection.document(group_code).setData({
      'code': group_code,
      'description': group_description,
      'id': puid.split('').reversed.join(),
      'members': [puid],
      'name': group_name
    });

    await usersCollection.document(puid).updateData({
      'groups': FieldValue.arrayUnion([group_code])
    });

  }
}