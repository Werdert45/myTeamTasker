class complete_user {
  final String name;
  final String email;
  final List groups;
  final String profile_picture;
  final List tasks;
  final Map personal_history;
  final Map group_history;


  complete_user({this.email, this.name, this.groups, this.profile_picture, this.tasks, this.personal_history, this.group_history});

  factory complete_user.fromMap(Map data) {
    data = data ?? {};
    return complete_user(
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        groups: data['groups'] ?? [],
        tasks: data['tasks'] ?? [],
        profile_picture: data['profile_picture'] ?? null,
        personal_history: data['personal_history'] ?? {},
        group_history: data['group_history'] ?? {}
    );
  }

}