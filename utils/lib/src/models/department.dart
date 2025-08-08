// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;
import 'package:meta/meta.dart' show immutable;

part 'department.g.dart';

@immutable
@JsonSerializable()
class Department extends Equatable {
  const Department({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.headOfDepartment,
  });

  final String id;
  final String name;
  final String? description;
  final String? headOfDepartment;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Department copyWith({
    String? id,
    String? name,
    String? description,
    String? headOfDepartment,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      headOfDepartment: headOfDepartment ?? this.headOfDepartment,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentToJson(this);

  @override
  String toString() {
    return '''Department(id: $id, name: $name, description: $description, headOfDepartment: $headOfDepartment, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      headOfDepartment,
      isActive,
      createdAt,
      updatedAt,
    ];
  }
}
