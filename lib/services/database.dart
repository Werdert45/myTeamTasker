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

    var repeated_tasks = [];
    var single_tasks = [];

    var groups = [];

    var repeated_full = [];
    var single_full = [];

    for (var i = 0; i < user.personal_single_tasks.length; i++) {
      var task = await singleTasksCollection.document(user.personal_single_tasks[i]).get();

      var spec_group = single_task.fromMap(task.data);
      single_full.add(spec_group);
    }

    for (var i = 0; i < user.personal_repeated_tasks.length; i++) {
      var task = await repeatedTasksCollection.document(user.personal_repeated_tasks[i]).get();

      var spec_group = repeated_task.fromMap(task.data);
      repeated_full.add(spec_group);
    }

    for (var i = 0; i < user.groups.length; i++) {
      var groupdata = await groupsCollection.document(user.groups[i]).get();
      var spec_group = group.fromMap(groupdata.data);
      groups.add(spec_group);
      repeated_tasks = repeated_tasks + spec_group.repeated_tasks;
      single_tasks = single_tasks + spec_group.single_tasks;
    }

    for (var i = 0; i < repeated_tasks.length; i++) {
      var repeated_tasks_data = await repeatedTasksCollection.document(repeated_tasks[i]).get();
      var spec_repeated_task = repeated_task.fromMap(repeated_tasks_data.data);

      var today = DateTime.now().weekday;

      if (spec_repeated_task.days[today - 1]) {
        repeated_full.add(spec_repeated_task);
      }
    }

    for (var i = 0; i < single_tasks.length; i++) {
      var single_tasks_data = await singleTasksCollection.document(single_tasks[i]).get();
      var spec_single_task = single_task.fromMap(single_tasks_data.data);

      var today = DateTime.now();
      var date = DateTime.fromMillisecondsSinceEpoch(int.parse(spec_single_task.date));

      if ((date.day == today.day) && (date.month == today.month) && (date.year == today.year)) {
        single_full.add(spec_single_task);
      }
    }

    tasks = repeated_full + single_full;

    var userWithTasks = complete_user.fromMap({'name': user.name, 'profile_picture': user.profile_picture, 'email': user.email, 'groups': groups, 'tasks': tasks});

    return userWithTasks;
  }

  getAllTasks(uid) async {
    var userdata = await usersCollection.document(uid).get();

    var user = user_db.fromMap(userdata.data);

    var tasks = [];

    var repeated_tasks = [];
    var single_tasks = [];

    var groups = [];

    var repeated_full = [];
    var single_full = [];

    for (var i = 0; i < user.personal_single_tasks.length; i++) {
      var task = await singleTasksCollection.document(user.personal_single_tasks[i]).get();

      var spec_group = single_task.fromMap(task.data);
      single_full.add(spec_group);
    }

    for (var i = 0; i < user.personal_repeated_tasks.length; i++) {
      var task = await repeatedTasksCollection.document(user.personal_repeated_tasks[i]).get();

      var spec_group = repeated_task.fromMap(task.data);
      repeated_full.add(spec_group);
    }

    for (var i = 0; i < user.groups.length; i++) {
      var groupdata = await groupsCollection.document(user.groups[i]).get();
      var spec_group = group.fromMap(groupdata.data);
      groups.add(spec_group);
      repeated_tasks = repeated_tasks + spec_group.repeated_tasks;
      single_tasks = single_tasks + spec_group.single_tasks;
    }

    for (var i = 0; i < repeated_tasks.length; i++) {
      var repeated_tasks_data = await repeatedTasksCollection.document(repeated_tasks[i]).get();
      var spec_repeated_task = repeated_task.fromMap(repeated_tasks_data.data);

      repeated_full.add(spec_repeated_task);
    }

    for (var i = 0; i < single_tasks.length; i++) {
      var single_tasks_data = await singleTasksCollection.document(single_tasks[i]).get();
      var spec_single_task = single_task.fromMap(single_tasks_data.data);

      var today = DateTime.now();
      var date = DateTime.fromMillisecondsSinceEpoch(int.parse(spec_single_task.date));

      single_full.add(spec_single_task);
    }

    tasks = repeated_full + single_full;

    var userWithTasks = complete_user.fromMap({'name': user.name, 'profile_picture': user.profile_picture, 'email': user.email, 'groups': groups, 'tasks': tasks});

    return userWithTasks;
  }

  getCalendar(uid) async {

    final Map<DateTime, dynamic> per_day = new Map();

    // Get the user data and set model
    var userdata = await usersCollection.document(uid).get();
    var user = user_db.fromMap(userdata.data);

    // Check for the personal tasks
    var tasks = [];

    var repeated_tasks = [];
    var single_tasks = [];

    var groups = [];

    var repeated_full = [];
    var single_full = [];

    for (var i = 0; i < user.personal_single_tasks.length; i++) {
      var task = await singleTasksCollection.document(user.personal_single_tasks[i]).get();

      var spec_group = single_task.fromMap(task.data);
      single_full.add(spec_group);
    }

    for (var i = 0; i < user.personal_repeated_tasks.length; i++) {
      var task = await repeatedTasksCollection.document(user.personal_repeated_tasks[i]).get();

      var spec_group = repeated_task.fromMap(task.data);
      repeated_full.add(spec_group);
    }


    // Get all of the groups
    for (var i = 0; i < user.groups.length; i++) {
      var groupdata = await groupsCollection.document(user.groups[i]).get();
      var spec_group = group.fromMap(groupdata.data);
      groups.add(spec_group);
      repeated_tasks = repeated_tasks + spec_group.repeated_tasks;
      single_tasks = single_tasks + spec_group.single_tasks;
    }

    // Get all of the repeated tasks
    for (var i = 0; i < repeated_tasks.length; i++) {
      var repeated_tasks_data = await repeatedTasksCollection.document(repeated_tasks[i]).get();
      var spec_repeated_task = repeated_task.fromMap(repeated_tasks_data.data);

      var today = DateTime.now().weekday;

      repeated_full.add(spec_repeated_task);
    }

    for (var i = 0; i < single_tasks.length; i++) {
      var single_tasks_data = await singleTasksCollection.document(single_tasks[i]).get();
      var spec_single_task = single_task.fromMap(single_tasks_data.data);
      single_full.add(spec_single_task);
    }

    tasks = repeated_full + single_full;

    var day_of_the_year = DateTime.now();
    var day = day_of_the_year.day;
    var month = day_of_the_year.month;
    var year = day_of_the_year.year;

    // Per task in the total task list
    for (int i = 0; i < tasks.length; i++) {
      // If task is a single task
      if (!tasks[i].repeated) {
        var date = DateTime.fromMillisecondsSinceEpoch(int.parse(tasks[i].date));
        var day = date.day;
        var month = date.month;
        var year = date.year;

        if (per_day.containsKey(DateTime(year, month, day))) {
          // Second task
          per_day[DateTime(year, month, day)] += [{'name': tasks[i].title, 'icon': tasks[i].icon, 'isDone': tasks[i].finished, 'days': null, 'alert_time': tasks[i].alert_time}];
        } else {
          per_day[DateTime(year, month, day)] = [{'name': tasks[i].title, 'icon': tasks[i].icon, 'isDone': tasks[i].finished, 'days': null, 'alert_time': tasks[i].alert_time}];
        }
      }

      else {
        // Set day of today
        var day_of_the_year = DateTime.now();

        // Loop over a whole year
        for (int j = 0; j < 364; j++) {

          if (tasks[i].days[day_of_the_year.weekday - 1]) {
            var day = day_of_the_year.day;
            var month = day_of_the_year.month;
            var year = day_of_the_year.year;

            if (per_day.containsKey(DateTime(year, month, day))) {
              per_day[DateTime(year, month, day)] += [{'name': tasks[i].title, 'icon': tasks[i].icon, 'isDone': tasks[i].finished, 'days': tasks[i].days, 'alert_time': tasks[i].alert_time}];
            } else {
              per_day[DateTime(year, month, day)] = [{'name': tasks[i].title, 'icon': tasks[i].icon, 'isDone': tasks[i].finished, 'days': tasks[i].days, 'alert_time': tasks[i].alert_time}];
            }
          }

          day_of_the_year = day_of_the_year.add(Duration(days: 1));
        }
      }
    }

    // Return a map with the days of the next year 
    return per_day;
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

  Future addRepeatedTask(taskID, puid, group_id, shared) async {
    if (shared) {
      await groupsCollection.document(group_id).updateData({
        'repeated_tasks': FieldValue.arrayUnion([taskID])
      });
    }

    else {
      await usersCollection.document(puid).updateData({
        'personal_repeated_tasks': FieldValue.arrayUnion([taskID])
      });
    }
  }

  Future addSingleTask(taskID, puid, group_id, shared) async {
    if (shared) {
      await groupsCollection.document(group_id).updateData({
        'single_tasks': FieldValue.arrayUnion([taskID])
      });
    }

    else {
      await usersCollection.document(puid).updateData({
        'personal_single_tasks': FieldValue.arrayUnion([taskID])
      });
    }
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

  Future createSingleTask(taskID, alertTime, date, icon, assignee, title, puid, shared) async {
    await singleTasksCollection.document(taskID).setData({
      'alert_time': alertTime,
      'date': date,
      'creator': puid,
      'assignee': assignee,
      'days': null,
      'icon': icon,
      'id': taskID,
      'title': title,
      'shared': shared,
      'repeated': false,
      'finished': false,
      'finished_by': []
    });
  }

  Future createRepeatedTask(taskID, alertTime, assignee, puid, days, icon, title, shared) async {
    await repeatedTasksCollection.document(taskID).setData({
      'alert_time': alertTime,
      'assignee': assignee,
      'creator': puid,
      'days': days,
      'icon': icon,
      'id': taskID,
      'title': title,
      'shared': shared,
      'repeated': true,
      'finished': false,
      'finished_by': []
//      'description': description
    });
  }

  Future removeSingleTask(taskID) async {
    await singleTasksCollection.document(taskID).delete();
  }

  Future removeRepeatedTask(taskID) async {
    await repeatedTasksCollection.document(taskID).delete();
  }

  Future completeReplacementTask(taskID, group_id, puid, repeated, shared, init_repeated, init_shared) async {
    // Remove all of the references and task objects
    if (init_repeated && init_shared) {
      await groupsCollection.document(group_id).updateData({'repeated_tasks': FieldValue.arrayRemove([taskID])});
      await repeatedTasksCollection.document(taskID).delete();
    }

    else if (init_repeated && !init_shared) {
      await usersCollection.document(puid).updateData({'personal_repeated_tasks': FieldValue.arrayRemove([taskID])});
      await repeatedTasksCollection.document(taskID).delete();
    }

    else if (!init_repeated && init_shared) {
      await groupsCollection.document(group_id).updateData({'single_tasks': FieldValue.arrayRemove([taskID])});
      await singleTasksCollection.document(taskID).delete();
    }

    else if (!init_repeated && !init_shared) {
      await usersCollection.document(puid).updateData({'personal_single_tasks': FieldValue.arrayRemove([taskID])});
      await singleTasksCollection.document(taskID).delete();
    }

    else {
      print("No clue");
    }
  }

  Future updateFinishedStatusSingle(taskID, status, puid) async {
    await singleTasksCollection.document(taskID).updateData({
      'finished': status,
      'finished_by': FieldValue.arrayUnion([puid])
    });
  }

  Future updateFinishedStatusRepeated(taskID, status, puid) async {
    await repeatedTasksCollection.document(taskID).updateData({
      'finished': status,
      'finished_by': FieldValue.arrayUnion([puid])
    });
  }

  Future createUser(puid, name, email) async {
    await usersCollection.document(puid).setData({
      'uid': puid,
      'email': email,
      'name': name,
      'profile_picture': 'placeholder',
      'groups': [],
      'personal_repeated_tasks': [],
      'personal_single_tasks': []
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