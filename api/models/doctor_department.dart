import 'package:equatable/equatable.dart';

class DoctorDepartment extends Equatable {
  const DoctorDepartment({
    required this.id,
    required this.doctorId,
    required this.departmentId,
    required this.isPrimary,
    required this.createdAt,
  });

  factory DoctorDepartment.fromJson(Map<String, dynamic> json) {
    return DoctorDepartment(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      departmentId: json['departmentId'] as String,
      isPrimary: json['isPrimary'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'departmentId': departmentId,
      'isPrimary': isPrimary,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

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
