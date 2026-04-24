enum UserType { collaborator, manager }

class User {
  final int id;
  final String email;
  final String name;
  final UserType type;
  final int idDepartment;
  final Map<String, dynamic>? extraData;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.type,
    required this.idDepartment,
    this.extraData,
  });

  factory User.collaborator({
    required int id,
    required String email,
    required String name,
    required UserType type,
    required int idDepartment,
    required int points,
    required String job,
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      type: type,
      idDepartment: idDepartment,
      extraData: {'points': points, 'job': job},
    );
  }

  factory User.manager({
    required int id,
    required String email,
    required String name,
    required UserType type,
    required int idDepartment,
    required List<int> idTeams,
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      type: type,
      idDepartment: idDepartment,
      extraData: {'idTeams': idTeams},
    );
  }
}
