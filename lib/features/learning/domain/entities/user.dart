class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.points,
  });

  final String id;
  final String email;
  final String name;
  final int points;

  User copyWith({String? id, String? email, String? name, int? points}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      points: points ?? this.points,
    );
  }
}
