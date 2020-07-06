class single_task {
  final String icon;
  final String title;
  final String id;
  final int date;
  final String alert_time;
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
      days: null,
      date: data['date'] ?? null,
      alert_time: data['alert_time'] ?? null,
      creator: data['creator'] ?? '',
      assignee: data['assignee'] ?? ''
    );
  }
}