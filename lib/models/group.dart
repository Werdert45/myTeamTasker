class group {
  final String code;
  final String description;
  final String id;
  final Map members;
  final String name;
  final List repeated_tasks;
  final List single_tasks;
  final Map tasks_history;

  group({this.name, this.code, this.description, this.id, this.members, this.repeated_tasks, this.single_tasks, this.tasks_history});

  factory group.fromMap(Map data) {
    data = data ?? {};
    return group(
      name: data['name'] ?? '',
      code: data['code'] ?? '',
      description: data['description'] ?? '',
      id: data['id'] ?? '',
      members: data['members'] ?? {},
      repeated_tasks: data['repeated_tasks'] ?? [],
      single_tasks: data['single_tasks'] ?? [],
      tasks_history: data['tasks_history'] ?? {}
    );
  }
}