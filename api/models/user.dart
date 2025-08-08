import 'package:equatable/equatable.dart';

enum UserRole {
  admin,
  doctor,
  nurse,
  receptionist,
}

class User extends Equatable {
  const User({
    required this.id,
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
      role: UserRole.values.byName(json['role'] as String),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }
  final String id;
  final String email;
  final String passwordHash;
  final UserRole role;
  final String firstName;
  final String lastName;
  final String? phone;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'role': role.name,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

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
