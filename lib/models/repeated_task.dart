class repeated_task {
  final String icon;
  final String title;
  final String id;
  final List days;
  final DateTime alert_time;
  final String creator;
  final String assignee;

  repeated_task({this.icon, this.id, this.title, this.days, this.creator, this.alert_time, this.assignee});


  factory repeated_task.fromMap(Map data) {
    data = data ?? {};
    return repeated_task(
        icon: data['icon'] ?? '',
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        creator: data['creator'] ?? '',
        days: data['days'] ?? null,
        alert_time: DateTime.fromMillisecondsSinceEpoch(data['alert_time']) ?? null,
        assignee: data['assignee'] ?? '',
    );
  }
}