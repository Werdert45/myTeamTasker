class user_db {
  final String name;
  final String email;
  final List groups;
  final String profile_picture;


  user_db({this.email, this.name, this.groups, this.profile_picture});

  factory user_db.fromMap(Map data) {
    data = data ?? {};
    return user_db(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      groups: data['groups'] ?? [],
      profile_picture: data['profile_picture'] ?? null
    );
  }

}