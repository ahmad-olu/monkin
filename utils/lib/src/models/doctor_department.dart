// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;
import 'package:meta/meta.dart' show immutable;

part 'doctor_department.g.dart';

@immutable
@JsonSerializable()
class DoctorDepartment extends Equatable {
  const DoctorDepartment({
    required this.id,
    required this.doctorId,
    required this.departmentId,
    required this.isPrimary,
    required this.createdAt,
  });

  final String id;
  final String doctorId;
  final String departmentId;
  final bool isPrimary;
  final DateTime createdAt;

  DoctorDepartment copyWith({
    String? id,
    String? doctorId,
    String? departmentId,
    bool? isPrimary,
    DateTime? createdAt,
  }) {
    return DoctorDepartment(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      departmentId: departmentId ?? this.departmentId,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DoctorDepartment.fromJson(Map<String, dynamic> json) =>
      _$DoctorDepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorDepartmentToJson(this);

  @override
  String toString() {
    return '''DoctorDepartment(id: $id, doctorId: $doctorId, departmentId: $departmentId, isPrimary: $isPrimary, createdAt: $createdAt)''';
  }

  @override
  List<Object> get props {
    return [
      id,
      doctorId,
      departmentId,
      isPrimary,
      createdAt,
    ];
  }
}
