// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorDepartment _$DoctorDepartmentFromJson(Map<String, dynamic> json) =>
    DoctorDepartment(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      departmentId: json['departmentId'] as String,
      isPrimary: json['isPrimary'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DoctorDepartmentToJson(DoctorDepartment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctorId': instance.doctorId,
      'departmentId': instance.departmentId,
      'isPrimary': instance.isPrimary,
      'createdAt': instance.createdAt.toIso8601String(),
    };
