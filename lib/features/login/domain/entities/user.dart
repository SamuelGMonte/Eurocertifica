// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum UserType { collaborator, manager }

class User {
  final int id;
  final String email;
  final String name;
  final UserType type;
  final Map<String, dynamic>? extraData;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.type,
    this.extraData,
  });

  factory User.collaborator(
      {required int id,
      required String email,
      required String name,
      required UserType type,
      required int points,
      required String registry,
      required String role,
      required int idTeam}) {
    return User(
      id: id,
      email: email,
      name: name,
      type: type,
      extraData: {
        'points': points,
        'role': role,
        'idTeam': idTeam,
      },
    );
  }

  factory User.manager(
      {required int id,
      required String email,
      required String name,
      required UserType type,
      required int department,
      required List<int> idTeams}) {
    return User(
      id: id,
      email: email,
      name: name,
      type: type,
      extraData: {
        'department': department,
        'idTeams': idTeams,
      },
    );
  }

  User copyWith(
      {int? id,
      String? email,
      String? name,
      UserType? type,
      Map<String, dynamic>? extraData}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      type: type ?? this.type,
      extraData: extraData ?? this.extraData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'type': type.toString(),
      'extraData': extraData,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      email: map['email'] as String,
      name: map['name'] as String,
      type: map['type'] == 'manager' ? UserType.manager : UserType.collaborator,
      extraData: map['extraData'] != null
          ? Map<String, dynamic>.from(
              (map['extraData'] as Map<String, dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, type: $type, extraData: $extraData)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.name == name &&
        other.type == type &&
        mapEquals(other.extraData, extraData);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        type.hashCode ^
        extraData.hashCode;
  }
}
