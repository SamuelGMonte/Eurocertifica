// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:eurocertifica_web/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.type,
    required super.idDepartment,
    required super.extraData,
  });

  User copyWith(
      {int? id,
      String? email,
      String? name,
      UserType? type,
      int? idDepartment,
      Map<String, dynamic>? extraData}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      type: type ?? this.type,
      idDepartment: idDepartment ?? this.idDepartment,
      extraData: extraData ?? this.extraData,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      type: user.type,
      idDepartment: user.idDepartment,
      extraData: user.extraData,
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      email: map['email'] as String,
      name: map['name'] as String,
      type: map['type'] == 'manager' ? UserType.manager : UserType.collaborator,
      idDepartment: map['idDepartment'] as int,
      extraData: map['extraData'] != null
          ? Map<String, dynamic>.from(
              (map['extraData'] as Map<String, dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, type: $type, extraData: $extraData)';
  }

  @override
  bool operator ==(covariant UserModel other) {
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
