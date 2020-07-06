class user_db {
  final String name;
  final String email;
  final List groups;
  final String profile_picture;
  final List personal_tasks;


  user_db({this.email, this.name, this.groups, this.profile_picture, this.personal_tasks});

  factory user_db.fromMap(Map data) {
    data = data ?? {};
    return user_db(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      groups: data['groups'] ?? [],
      profile_picture: data['profile_picture'] ?? null,
      personal_tasks: data['personal_tasks'] ?? []
    );
  }

}