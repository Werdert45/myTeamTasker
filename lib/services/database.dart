import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_repitition/models/complete_user.dart';
import 'package:collaborative_repitition/models/group.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/models/user_db.dart';

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

      if (task.data != null && single_task.fromMap(task.data).title != null) {
        var spec_group = single_task.fromMap(task.data);
        single_full.add(spec_group);
      }
    }

    for (var i = 0; i < user.personal_repeated_tasks.length; i++) {
      var task = await repeatedTasksCollection.document(user.personal_repeated_tasks[i]).get();

      var spec_group = repeated_task.fromMap(task.data);
      repeated_full.add(spec_group);
    }

    var group_list = user.groups.keys.toList();
    var groupy = await groupsCollection.document(group_list[0]).get();
    var group_data = group.fromMap(groupy.data);


    for (var i = 0; i < group_list.length; i++) {
      var groupdata = await groupsCollection.document(group_list[i]).get();
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
      var date = DateTime.fromMillisecondsSinceEpoch(spec_single_task.date);

      if ((date.day == today.day) && (date.month == today.month) && (date.year == today.year)) {
        single_full.add(spec_single_task);
      }
    }

    tasks = repeated_full + single_full;


    var userWithTasks = complete_user.fromMap({'name': user.name, 'profile_picture': user.profile_picture, 'email': user.email, 'groups': groups, 'tasks': tasks, 'personal_history': user.tasks_history, 'group_history': group_data.tasks_history});

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

    var group_list = user.groups.keys.toList();
    var groupy = await groupsCollection.document(group_list[0]).get();
    var group_data = group.fromMap(groupy.data);

    for (var i = 0; i < group_list.length; i++) {
      var groupdata = await groupsCollection.document(group_list[i]).get();
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

    var group_codes = [];
    var groups = [];

    var repeated_full = [];
    var single_full = [];

    for (var i = 0; i < user.personal_single_tasks.length; i++) {
      var task = await singleTasksCollection.document(user.personal_single_tasks[i]).get();

      if (task.data != null) {
        var spec_group = single_task.fromMap(task.data);
        single_full.add(spec_group);
      }
    }

    for (var i = 0; i < user.personal_repeated_tasks.length; i++) {
      var task = await repeatedTasksCollection.document(user.personal_repeated_tasks[i]).get();

      var spec_group = repeated_task.fromMap(task.data);
      repeated_full.add(spec_group);
    }

    user.groups.forEach((key, value) { group_codes.add(key); });

    // Get all of the groups
    for (var i = 0; i < group_codes.length; i++) {
      var groupdata = await groupsCollection.document(group_codes[i]).get();
      var spec_group = group.fromMap(groupdata.data);
      groups.add(spec_group);
      repeated_tasks = repeated_tasks + spec_group.repeated_tasks;
      single_tasks = single_tasks + spec_group.single_tasks;
    }

    // Get all of the repeated tasks
    for (var i = 0; i < repeated_tasks.length; i++) {
      var repeated_tasks_data = await repeatedTasksCollection.document(repeated_tasks[i]).get();
      var spec_repeated_task = repeated_task.fromMap(repeated_tasks_data.data);

      repeated_full.add(spec_repeated_task);
    }

    for (var i = 0; i < single_tasks.length; i++) {
      var single_tasks_data = await singleTasksCollection.document(single_tasks[i]).get();
      var spec_single_task = single_task.fromMap(single_tasks_data.data);
      single_full.add(spec_single_task);
    }

    tasks = repeated_full + single_full;

    var day_of_the_year = DateTime.now();

    // Per task in the total task list
    for (int i = 0; i < tasks.length; i++) {
      // If task is a single task
      if (tasks[i] is single_task) {
        var date = DateTime.fromMillisecondsSinceEpoch(tasks[i].date);
        var day = date.day;
        var month = date.month;
        var year = date.year;

        var isDone;

        var now = DateTime.now();

        if (DateTime(year, month, day) == DateTime(now.year, now.month, now.day)) {
          if (per_day.containsKey(DateTime(year, month, day))) {
            per_day[DateTime(year, month, day)] += [{'task': tasks[i], 'isDone': tasks[i].finished, 'groups': groups[0], 'tasks_history_pers': user.tasks_history, 'total_tasks': tasks}];
          } else {
            per_day[DateTime(year, month, day)] = [{'task': tasks[i], 'isDone': tasks[i].finished, 'groups': groups[0], 'tasks_history_pers': user.tasks_history, 'total_tasks': tasks}];
          }
        } else {
          if (tasks[i] is repeated_task) {
            isDone = false;
          }

          else {
            isDone = tasks[i].finished;
          }

          if (per_day.containsKey(DateTime(year, month, day))) {
            per_day[DateTime(year, month, day)] += [{'task': tasks[i], 'isDone': isDone, 'groups': groups[0], 'tasks_history_pers': user.tasks_history, 'total_tasks': tasks}];
          } else {
            per_day[DateTime(year, month, day)] = [{'task': tasks[i], 'isDone': isDone, 'groups': groups[0], 'tasks_history_pers': user.tasks_history, 'total_tasks': tasks}];
          }
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

            var isDone;

            var now = DateTime.now();

            if (DateTime(year, month, day) == DateTime(now.year, now.month, now.day)) {
              if (per_day.containsKey(DateTime(year, month, day))) {
                per_day[DateTime(year, month, day)] += [{'task': tasks[i], 'isDone': tasks[i].finished, 'groups': groups[0], 'tasks_history_pers': user.tasks_history, 'total_tasks': tasks}];
              } else {
                per_day[DateTime(year, month, day)] = [{'task': tasks[i], 'isDone': tasks[i].finished, 'groups': groups[0], 'tasks_history_pers': user.tasks_history, 'total_tasks': tasks}];
              }
            } else {
              if (tasks[i] is repeated_task) {
                isDone = false;
              }

              else {
                isDone = tasks[i].finished;
              }

              if (per_day.containsKey(DateTime(year, month, day))) {
                per_day[DateTime(year, month, day)] += [{'task': tasks[i], 'isDone': isDone, 'groups': groups[0], 'tasks_history_pers': user.tasks_history, 'total_tasks': tasks}];
              } else {
                per_day[DateTime(year, month, day)] = [{'task': tasks[i], 'isDone': isDone, 'groups': groups[0], 'tasks_history_pers': user.tasks_history, 'total_tasks': tasks}];
              }
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

  Future addGroupToUser(String code, puid, name) async {
    code = code.toUpperCase();

    var valid = await groupsCollection.document(code).get();

    if (valid.data == null) {
      return "error";
    }

    else if (valid.data is Map){
      // Add the group to the user and the user to the group
      try {
        var group_snap = await groupsCollection.document(code).get();
        var group_data = group.fromMap(group_snap.data);

        Map members_data = group_data.members;
        members_data[puid] = name;


        await groupsCollection.document(code).updateData({
          'members': members_data,
        });

        await usersCollection.document(puid).setData({
          'groups': {code: group_data.name}
        }, merge: true);

        return group_data;
      } catch (e) {
        print(e);
        return "error";
      }
    }

    else {
      return "error";
    }

  }


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

  Future removeRepeatedTaskFromUser(taskID, puid) async {
    await usersCollection.document(puid).updateData({
      'personal_repeated_tasks': FieldValue.arrayRemove([taskID])
    });
  }

  Future removeSingleTaskFromUser(taskID, puid) async {
    await usersCollection.document(puid).updateData({
      'personal_single_tasks': FieldValue.arrayRemove([taskID])
    });
  }


  Future createSingleTask(taskID, alertTime, date, icon, assignee, title, puid, shared, group_code, group_name, description) async {
      await singleTasksCollection.document(taskID).setData({
        'alert_time': alertTime,
        'date': date,
        'creator': puid,
        'assignee': assignee,
        'days': null,
        'icon': icon,
        'id': taskID,
        'title': title,
        'description': description,
        'shared': shared,
        'repeated': false,
        'finished': false,
        'finished_by': {},
        'belongs_to': [group_code, group_name]
      });

      var new_task = await singleTasksCollection.document(taskID).get();

      return single_task.fromMap(new_task.data);
  }

  Future createRepeatedTask(taskID, alertTime, assignee, puid, days, icon, title, shared, group_code, group_name, description) async {
      await repeatedTasksCollection.document(taskID).setData({
        'alert_time': alertTime,
        'assignee': assignee,
        'creator': puid,
        'days': days,
        'icon': icon,
        'id': taskID,
        'title': title,
        'description': description,
        'shared': shared,
        'repeated': true,
        'finished': false,
        'finished_by': {},
        'belongs_to': [group_code, group_name]
      });


      var new_task = await repeatedTasksCollection.document(taskID).get();

      return repeated_task.fromMap(new_task.data);
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

  Future addToSharedTaskHistory(String puid, String taskID, String groupID, Map task_history) async {
    var time = DateTime.now();
    var date = "${time.year}-${time.month}-${time.day}";

    // Update the list of finished tasks for the user (tasks_history)
    if (task_history.containsKey(date)) {
      if (task_history[date].containsKey(puid)) {
        var list = [];

        list += task_history[date][puid];
        list.add(taskID);

        task_history[date][puid] = list;
      }
      else {
        task_history[date][puid] = [taskID];
      }
    }

    else {
      task_history[date] = {puid: []};
      task_history[date][puid].add(taskID);
    }

    await groupsCollection.document(groupID).updateData({
      'tasks_history': task_history
    });
  }


  Future removeFromSharedTaskHistory(String puid, String taskID, String groupID, Map task_history, bool repeated) async {
    var time = DateTime.now();
    var date = "${time.year}-${time.month}-${time.day}";

    // Note start using the uid of the user that finished the task before you (if it is the case that the task was done by someone else
    // And you decided that it was not finished
    var list = [];
    list += task_history[date][puid];

    list.remove(taskID);

    task_history[date][puid] = list;

    await groupsCollection.document(groupID).updateData({
      'tasks_history': task_history
    });

    if (repeated) {
      await repeatedTasksCollection.document(taskID).updateData({
        'finished_by': {}
      });
    }

    else {
      await singleTasksCollection.document(taskID).updateData({
        'finished_by': {}
      });
    }
  }


  Future addToPersonalTaskHistory(String puid, String taskID, Map task_history, total_tasks) async {
    var time = DateTime.now();
    var date = "${time.year}-${time.month}-${time.day}";

    if (task_history.containsKey(date)) {
      task_history[date][0] += 1;
    }

    else {
      task_history[date] = [1, total_tasks];
    }

    await usersCollection.document(puid).updateData({
      'tasks_history': task_history
    });
  }

  Future removeFromPersonalTaskHistory(String puid, String taskID, Map task_history, total_tasks, bool repeated) async {
    var time = DateTime.now();
    var date = "${time.year}-${time.month}-${time.day}";

    task_history[date][0] -= 1;

    await usersCollection.document(puid).updateData({
      'tasks_history': task_history
    });

    if (repeated) {
      await repeatedTasksCollection.document(taskID).updateData({
        'finished_by': {}
      });
    }

    else {
      await singleTasksCollection.document(taskID).updateData({
        'finished_by': {}
      });
    }
  }

  Future updateFinishedStatusSingle(taskID, status, puid) async {
    var user = await usersCollection.document(puid).get();

    await singleTasksCollection.document(taskID).setData({
      'finished': status,
      'finished_by': {puid: user.data['name']}
    }, merge: true);

    var task = await singleTasksCollection.document(taskID).get();

    return task;
  }

  Future updateFinishedStatusRepeated(taskID, status, puid) async {
    var user = await usersCollection.document(puid).get();

    await repeatedTasksCollection.document(taskID).setData({
      'finished': status,
      'finished_by': {puid: user.data['name']}
    }, merge: true);


    var task = await repeatedTasksCollection.document(taskID).get();

    return task;
  }

  Future createUser(puid, name, email) async {
    await usersCollection.document(puid).setData({
      'uid': puid,
      'email': email,
      'name': name,
      'profile_picture': 'placeholder',
      'groups': {},
      'personal_repeated_tasks': [],
      'personal_single_tasks': []
    });
  }

  Future setProfilePicture(puid, image_path) async {
    await usersCollection.document(puid).updateData({
      'profile_picture': image_path
    });
  }

  Future addToGroup(puid, group_code, name) async {
    try {
      var group_snap = await groupsCollection.document(group_code).get();


      var group_data = group.fromMap(group_snap.data);


      Map members_data = group_data.members;
      members_data[puid] = name;


      await groupsCollection.document(group_code).updateData({
        'members': members_data,
      });

      await usersCollection.document(puid).setData({
        'groups': {group_code: group_data.name}
      }, merge: true);

      return "finished";
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future updateEmail(puid, email) async {
    await usersCollection.document(puid).updateData({
      'email': email.toLowerCase()
    });
  }

  Future createGroup(puid, group_name, group_description) async {
    bool allowed = false;
    int index = 1;

    var group_code = puid.toString().substring(0,6).toUpperCase() + "0" + index.toString();
    var user = await usersCollection.document(puid).get();

    var groupReq = await groupsCollection.document(group_code).get();

    while (!allowed) {
      if (groupReq.data != null) {
        index += 1;

        if (index < 10) {
          group_code = group_code.substring(0,6) + "0" + index.toString();
        }

        else {
          group_code = group_code.substring(0,6) + index.toString();
        }
      }

      groupReq = await groupsCollection.document(group_code).get();
      if (groupReq.data == null) {
        allowed = true;
      }
    }

    await groupsCollection.document(group_code).setData({
      'code': group_code,
      'description': group_description,
      'id': puid.split('').reversed.join(),
      'members': {puid: user.data['name']},
      'name': group_name,
      'single_tasks': [],
      'repeated_tasks': [],
      'tasks_history': {}
    });

    var newGroupReq = await groupsCollection.document(group_code).get();
    var new_map = user.data['groups'];
    new_map[group_code] = group_name;

    await usersCollection.document(puid).setData({
      'groups': new_map
    }, merge: true);

    var new_group = group.fromMap(newGroupReq.data);

    return new_group;
  }

  Future updateGroup(group_name, group_description, group_code) async {
    await groupsCollection.document(group_code).updateData({
      'description': group_description,
      'name': group_name
    });
  }

  Future leaveGroup(puid, group_code) async {
    var group_data = await groupsCollection.document(group_code).get();
    var group_model = group.fromMap(group_data.data);
    var members = group_model.members;
    members.remove(puid);

    await groupsCollection.document(group_code).updateData({
      'members': members
    });

    var user_data = await usersCollection.document(puid).get();
    var user = user_db.fromMap(user_data.data);

    var user_groups = user.groups;
    user_groups.remove(group_code);

    await usersCollection.document(puid).updateData({
      'groups': user_groups
    });
  }


  Future updateName(puid, name) async {
    await usersCollection.document(puid).updateData({
      'name': name
    });
  }
}