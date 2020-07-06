import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_repitition/models/complete_user.dart';
import 'package:collaborative_repitition/models/group.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/models/user_db.dart';

// TODO get all recent catches from the database and all of the species

// @author Ian Ronk
// @class DatabaseService
class Streams {

  final String uid;
  Streams({ this.uid});

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final CollectionReference groupsCollection = Firestore.instance.collection('groups');
  final CollectionReference repeatedTasksCollection = Firestore.instance.collection('repeated_tasks');
  final CollectionReference singleTasksCollection = Firestore.instance.collection('single_tasks');

  getCompleteUser(uid) async {
    var userdata = await usersCollection.document(uid).get();

    var user = user_db.fromMap(userdata.data);

    var tasks = [];
    user.personal_tasks.isNotEmpty ? tasks.add(user.personal_tasks) : null;

    var repeated_tasks = [];
    var single_tasks = [];

    for (var i = 0; i < user.groups.length; i++) {
      var groupdata = await groupsCollection.document(user.groups[i]).get();
      var spec_group = group.fromMap(groupdata.data);
      repeated_tasks = repeated_tasks + spec_group.repeated_tasks;
      single_tasks = single_tasks + spec_group.single_tasks;
    }

    for (var i = 0; i < repeated_tasks.length; i++) {
      var repeated_tasks_data = await repeatedTasksCollection.document(repeated_tasks[i]).get();
      var spec_repeated_task = repeated_task.fromMap(repeated_tasks_data.data);
      tasks.add(spec_repeated_task);
    }

    for (var i = 0; i < single_tasks.length; i++) {
      var single_tasks_data = await singleTasksCollection.document(single_tasks[i]).get();
      var spec_single_task = single_task.fromMap(single_tasks_data.data);
      tasks.add(spec_single_task);
    }

    var userWithTasks = complete_user.fromMap({'name': user.name, 'profile_picture': user.profile_picture, 'email': user.email, 'groups': user.groups, 'tasks': tasks});

    print("TDF");
    print(userWithTasks);
    return userWithTasks;
  }


  Stream<DocumentSnapshot> get users {
    return usersCollection.document(uid).snapshots();
  }

  Stream<DocumentSnapshot> get groups {
    return groupsCollection.document(uid).snapshots();
  }


  Stream<user_db> streamUser(String uid) {
    return usersCollection.document(uid).snapshots().map((snap) => user_db.fromMap(snap.data));
  }

  Stream<group> streamGroup(String code) {
    return groupsCollection.document(code).snapshots().map((snap) => group.fromMap(snap.data));
  }

}

class DatabaseService {

  final String uid;

  DatabaseService({ this.uid});

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('users');
  final CollectionReference groupsCollection = Firestore.instance.collection('groups');
  final CollectionReference repeatedTasksCollection = Firestore.instance.collection('repeated_tasks');
  final CollectionReference singleTasksCollection = Firestore.instance.collection('single_tasks');

  Future addRepeatedTaskToGroup(taskID, puid, group_id) async {
    await groupsCollection.document(group_id).updateData({
      'repeated_tasks': FieldValue.arrayUnion([taskID])
    });
  }

  Future removeRepeatedTaskFromGroup(taskID, group_id) async {
    await groupsCollection.document(group_id).updateData({
      'repeated_tasks': FieldValue.arrayRemove([taskID])
    });
  }

  Future removeSingleTaskFromGroup(taskID, group_id) async {
    await groupsCollection.document(group_id).updateData({
      'single_tasks': FieldValue.arrayRemove([taskID])
    });
  }


  Future createSingleTask(taskID, alertTime, date, icon, assignee, title, puid) async {
    await singleTasksCollection.document(taskID).setData({
      'alert_time': alertTime,
      'date': date,
      'creator': puid,
      'assignee': assignee,
      'days': null,
      'icon': icon,
      'id': taskID,
      'title': title
    });
  }

  Future createRepeatedTask(taskID, alertTime, assignee, puid, days, icon, title) async {
    await repeatedTasksCollection.document(taskID).setData({
      'alert_time': alertTime,
      'assignee': assignee,
      'creator': puid,
      'days': days,
      'icon': icon,
      'id': taskID,
      'title': title
    });
  }

  Future updateSingleTask(taskID, alertTime, date, icon, title) async {
    await singleTasksCollection.document(taskID).updateData({
      'alert_time': alertTime,
      'icon': icon,
      'title': title,
      'date': date
    });
  }

  Future updateRepeatedTask(taskID, alertTime, days, icon, title) async {
    await repeatedTasksCollection.document(taskID).updateData({
      'alert_time': alertTime,
      'icon': icon,
      'title': title,
      'days': days
    });
  }

  Future removeSingleTask(taskID) async {
    await singleTasksCollection.document(taskID).delete();
  }

  Future removeRepeatedTask(taskID) async {
    await repeatedTasksCollection.document(taskID).delete();
  }


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
      'name': group_name,
      'single_tasks': [],
      'repeated_tasks': [],
    });

    await usersCollection.document(puid).updateData({
      'groups': FieldValue.arrayUnion([group_code])
    });

  }
}