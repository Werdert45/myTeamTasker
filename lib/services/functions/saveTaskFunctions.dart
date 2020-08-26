import 'dart:convert';
import 'dart:io';

import 'package:collaborative_repitition/models/complete_user.dart';
import 'package:collaborative_repitition/models/group.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:path_provider/path_provider.dart';


writeGeneralInfoToStorage(complete_user complete_user) async {
  // Get storage path and file
  var path = await _localPath;
  var file = File('$path/general_info.json');

  Map jsonReady = {};

  jsonReady['name'] = complete_user.name;
  jsonReady['email'] = complete_user.email;
  jsonReady['groups'] = {};
  jsonReady['profile_picture'] = complete_user.profile_picture;
  jsonReady['tasks'] = {};
  jsonReady['personal_history'] = complete_user.personal_history;
  jsonReady['personal_history'] = complete_user.group_history;

  var tasks = complete_user.tasks;
  
  for (int i=0; i < tasks.length; i++) {
    if (tasks[i] is repeated_task) {
//      var task = repeated_task.fromMap(tasks[i]);
      jsonReady['tasks'][tasks[i].id] = jsonEncode(tasks[i].toMap());
    }

    else if (tasks[i] is single_task) {
      jsonReady['tasks'][tasks[i].id] = jsonEncode(tasks[i].toMap());
    }

    else {
      print("Something is wrong, I can feel it");
    }
  }
  
  var groups = complete_user.groups;
  for (int i = 0; i < groups.length; i++) {
    jsonReady['groups'][groups[i].id] = jsonEncode(groups[i].toMap());
  }
  

  // Write string to the file
  var json = jsonEncode(jsonReady);

  return file.writeAsString(json);
}


/// Read the file from the storage
/// storage ---> tasks
readGeneralInfoFromStorage() async {
  var path = await _localPath;
  var file = File('$path/general_info.json');

  List tasks = [];
  List groups = [];

  // Get string of data
  String contents = await file.readAsString();

  // Map of data inside of JSON from string
  Map data = jsonDecode(contents);

  // Loop through all tasks and check if repeated, if so set as repeated task,
  // otherwise set as single task
  data['tasks'].forEach((key, value) {
    Map task = jsonDecode(value);

    if (task['repeated']) {
      print('repeated');
      tasks.add(repeated_task.fromMap(task));
    }

    else {
      print('not repeated');
      tasks.add(single_task.fromMap(task));
    }
  });


  // Loop through all groups
  data['groups'].forEach((key, value) {
    Map single_group = jsonDecode(value);

    groups.add(group.fromMap(single_group));

//    if (task['repeated']) {
//      print('repeated');
//      tasks.add(repeated_task.fromMap(task));
//    }

  });

  Map fullUser = {
    'name': data['name'],
    'email': data['email'],
    'groups': groups,
    'profile_picture': data['profile_picture'],
    'tasks': tasks,
    'personal_history': data['personal_history'],
    'group_history': data['group_history']
  };

  return complete_user.fromMap(fullUser);
}

/// Write the tasks to the storage:
/// tasks --> storage
writeTasksToStorage(List tasks) async {
  // Get storage path and file
  var path = await _localPath;
  var file = File('$path/tasks.json');
  Map jsonReady = {};

  // Add the objects to the jsonReady
  for (int i=0; i < tasks.length; i++) {
    if (tasks[i] is repeated_task) {
//      var task = repeated_task.fromMap(tasks[i]);
      jsonReady[tasks[i].id] = jsonEncode(tasks[i].toMap());
    }

    else if (tasks[i] is single_task) {
      jsonReady[tasks[i].id] = jsonEncode(tasks[i].toMap());
    }

    else {
      print("Something is wrong, I can feel it");
    }
  }

  // Write to json
  String jsonFile = jsonEncode(jsonReady);

  // Write string to the file
  return file.writeAsString(jsonFile);
}


/// Read the file from the storage
/// storage ---> tasks
readTasksFromStorage() async {
  var path = await _localPath;
  var file = File('$path/tasks.json');

  List tasks = [];

  // Get string of data
  String contents = await file.readAsString();

  // Map of data inside of JSON from string
  Map data = jsonDecode(contents);

  // Loop through all tasks and check if repeated, if so set as repeated task,
  // otherwise set as single task
  data.forEach((key, value) {
    Map task = jsonDecode(value);

    if (task['repeated']) {
      print('repeated');
      tasks.add(repeated_task.fromMap(task));
    }

    else {
      print('not repeated');
      tasks.add(single_task.fromMap(task));
    }
  });

  return tasks;
}

/// Function to get the path to the application directory
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}