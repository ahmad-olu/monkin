// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  createdBy: json['createdBy'] as String,
  passwordHash: json['passwordHash'] as String?,
  id: json['id'] as String?,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
  isActive: json['isActive'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': ?instance.id,
  'createdBy': instance.createdBy,
  'email': instance.email,
  'passwordHash': instance.passwordHash,
  'role': _$UserRoleEnumMap[instance.role],
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phone': instance.phone,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.superAdmin: 'superAdmin',
  UserRole.admin: 'admin',
  UserRole.doctor: 'doctor',
  UserRole.nurse: 'nurse',
  UserRole.receptionist: 'receptionist',
};

CreateUser _$CreateUserFromJson(Map<String, dynamic> json) => CreateUser(
  email: json['email'] as String,
  passwordHash: json['passwordHash'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: json['createdBy'] as String,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$CreateUserToJson(CreateUser instance) =>
    <String, dynamic>{
      'email': instance.email,
      'passwordHash': instance.passwordHash,
      'role': _$UserRoleEnumMap[instance.role]!,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'isActive': instance.isActive,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

CreateUserRequest _$CreateUserRequestFromJson(Map<String, dynamic> json) =>
    CreateUserRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$CreateUserRequestToJson(CreateUserRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'role': _$UserRoleEnumMap[instance.role]!,
    };
