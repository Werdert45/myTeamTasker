
progressBar(tasks) {
  var not_finished = [];
  var finished = [];

  for (int i = 0; i < tasks.length; i++) {
    if (tasks[i].finished) {
      finished.add(tasks[i]);
    }

    else {
      not_finished.add(tasks[i]);
    }
  }

  return [not_finished, finished];
}