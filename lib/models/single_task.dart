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
  final List belongs_to;

  single_task({this.icon, this.id, this.title, this.date, this.alert_time, this.creator, this.assignee, this.days, this.shared, this.repeated, this.finished, this.belongs_to});


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
      finished: data['finished'] ?? false,
      belongs_to: data['belongs_to'] ?? null
    );
  }
}
