class single_task {
  final String icon;
  final String title;
  final String id;
  final DateTime date;
  final DateTime alert_time;
  final String creator;
  final String assignee;
  final List days;

  single_task({this.icon, this.id, this.title, this.date, this.alert_time, this.creator, this.assignee, this.days});


  factory single_task.fromMap(Map data) {
    data = data ?? {};
    return single_task(
      icon: data['icon'] ?? '',
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      days: [],
      date: DateTime.fromMillisecondsSinceEpoch(data['date']) ?? null,
      alert_time: DateTime.fromMillisecondsSinceEpoch(data['alert_time']) ?? null,
      creator: data['creator'] ?? '',
      assignee: data['assignee'] ?? ''
    );
  }
}