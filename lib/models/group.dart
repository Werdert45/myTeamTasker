class group {
  final String code;
  final String description;
  final String id;
  final List members;
  final String name;
  final List tasks;

  group({this.name, this.code, this.description, this.id, this.members, this.tasks});

  factory group.fromMap(Map data) {
    data = data ?? {};
    return group(
      name: data['name'] ?? '',
      code: data['code'] ?? '',
      description: data['description'] ?? '',
      id: data['id'] ?? '',
      members: data['members'] ?? '',
      tasks: data['tasks'] ?? []
    );
  }
}