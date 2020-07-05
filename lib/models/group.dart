class group {
  final String code;
  final String description;
  final String id;
  final List members;
  final String name;
  final List repeated_tasks;
  final List single_tasks;

  group({this.name, this.code, this.description, this.id, this.members, this.repeated_tasks, this.single_tasks});

  factory group.fromMap(Map data) {
    data = data ?? {};
    return group(
      name: data['name'] ?? '',
      code: data['code'] ?? '',
      description: data['description'] ?? '',
      id: data['id'] ?? '',
      members: data['members'] ?? '',
      repeated_tasks: data['repeated_tasks'] ?? [],
      single_tasks: data['single_tasks'] ?? []
    );
  }
}