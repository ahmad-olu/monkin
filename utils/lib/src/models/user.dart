// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

enum UserRole {
  admin,
  doctor,
  nurse,
  receptionist,
}

@immutable
@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.firstName,
    required this.lastName,
    this.role,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.phone,
  });

  @JsonKey(includeIfNull: false)
  final String id;
  final String email;
  final String passwordHash;
  final UserRole? role;
  final String firstName;
  final String lastName;
  final String? phone;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User copyWith({
    String? id,
    String? email,
    String? passwordHash,
    UserRole? role,
    String? firstName,
    String? lastName,
    String? phone,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return '''User(id: $id, email: $email, passwordHash: $passwordHash, role: $role, firstName: $firstName, lastName: $lastName, phone: $phone, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }

  @override
  List<Object?> get props {
    return [
      id,
      email,
      passwordHash,
      role,
      firstName,
      lastName,
      phone,
      isActive,
      createdAt,
      updatedAt,
    ];
  }
}

@immutable
@JsonSerializable()
class CreateUser {
  const CreateUser({
    required this.email,
    required this.passwordHash,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
  });

  final String email;
  final String passwordHash;
  final UserRole role;
  final String firstName;
  final String lastName;
  final String? phone;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CreateUser.fromJson(Map<String, dynamic> json) =>
      _$CreateUserFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserToJson(this);
}

@immutable
@JsonSerializable()
class CreateUserRequest {
  const CreateUserRequest({
    required this.email,
    required this.password,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  final String email;
  final String password;
  final UserRole role;
  final String firstName;
  final String lastName;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);
}
