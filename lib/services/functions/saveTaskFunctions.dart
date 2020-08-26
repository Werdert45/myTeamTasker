import 'dart:convert';
import 'dart:io';

import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:path_provider/path_provider.dart';

writeTasksToStorage(List tasks) async {
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

  String jsonFile = jsonEncode(jsonReady);

  return file.writeAsString(jsonFile);
}

readTasksFromStorage() async {
  var path = await _localPath;
  var file = File('$path/tasks.json');

  List tasks = [];

  String contents = await file.readAsString();

  // Map of data inside of JSON
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


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}