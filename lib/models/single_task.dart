class single_task {
  final String icon;
  final String title;
  final String id;
  final int date;
  final String alert_time;
  final String creator;
  final String assignee;
  final List days;
  final bool shared;
  final bool repeated;
  final bool finished;

  single_task({this.icon, this.id, this.title, this.date, this.alert_time, this.creator, this.assignee, this.days, this.shared, this.repeated, this.finished});


  factory single_task.fromMap(Map data) {
    data = data ?? {};
    return single_task(
      icon: data['icon'] ?? '',
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      days: null,
      date: data['date'] ?? null,
      alert_time: data['alert_time'] ?? null,
      creator: data['creator'] ?? '',
      assignee: data['assignee'] ?? '',
      shared: data['shared'] ?? false,
      repeated: data['repeated'] ?? false,
      finished: data['finished'] ?? false
    );
  }
}

//
//IconButton(
//icon: Icon(Icons.add_circle),
//onPressed: () async {
//var taskID = (user.uid + DateTime.now().millisecondsSinceEpoch.toString());
//var alertTime = '14:15';
//var assignee = user.uid;
//var puid = user.uid;
////                      var days = [false, false, false, false, false, false, false];
//var icon = "😇";
//var title = "New Task";
//var group_id = snapshot.data.groups[0].code;
//var date = DateTime.now().millisecondsSinceEpoch.toString();
//var shared = false;
//var repeated = false;
//
//await database.createSingleTask(taskID, alertTime, date, icon, assignee, title, puid, shared);
//
//await database.addSingleTask(taskID, puid, group_id, shared);
//
//setState(() {
//var new_task = single_task.fromMap({
//'icon': icon,
//'id': taskID,
//'title': title,
//'creator': user.uid,
//'days': null,
//'date': date,
//'alert_time': alertTime,
//'repeated': false
//});
//tasks.add(new_task);
//
//});
//},
//),