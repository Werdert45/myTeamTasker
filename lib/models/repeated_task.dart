class repeated_task {
  final String icon;
  final String title;
  final String description;
  final String id;
  final List days;
  final String alert_time;
  final String creator;
  final String assignee;
  final bool shared;
  final bool repeated;
  final bool finished;
  final Map finished_by;
  final List belongs_to;

  repeated_task({this.icon, this.id, this.title, this.description, this.days, this.creator, this.alert_time, this.assignee, this.shared, this.repeated, this.finished, this.finished_by, this.belongs_to});


  factory repeated_task.fromMap(Map data) {
    data = data ?? {};
    return repeated_task(
        icon: data['icon'] ?? '',
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        creator: data['creator'] ?? '',
        days: data['days'] ?? [false, false, false, false, false, false, false],
        alert_time: data['alert_time'] ?? null,
        assignee: data['assignee'] ?? '',
        shared: data['shared'] ?? false,
        repeated: data['repeated'] ?? false,
        finished: data['finished'] ?? false,
        finished_by: data['finished_by'] ?? {},
        belongs_to: data['belongs_to'] ?? null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'icon': icon,
      'id': id,
      'title': title,
      'description': description,
      'creator': creator,
      'days': days,
      'alert_time': alert_time,
      'assignee': assignee,
      'shared': shared,
      'repeated': repeated,
      'finished': finished,
      'finished_by': finished_by,
      'belongs_to': belongs_to
    };
  }
}