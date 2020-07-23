class user_db {
  final String name;
  final String email;
  final Map groups;
  final String profile_picture;
  final List personal_repeated_tasks;
  final List personal_single_tasks;
  final Map tasks_history;



  user_db({this.email, this.name, this.groups, this.profile_picture, this.personal_repeated_tasks, this.personal_single_tasks, this.tasks_history});

  factory user_db.fromMap(Map data) {
    data = data ?? {};
    return user_db(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      groups: data['groups'] ?? {},
      profile_picture: data['profile_picture'] ?? null,
      personal_repeated_tasks: data['personal_repeated_tasks'] ?? [],
      personal_single_tasks: data['personal_single_tasks'] ?? [],
      tasks_history: data['tasks_history'] ?? {}
    );
  }

}