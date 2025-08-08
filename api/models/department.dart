import 'package:equatable/equatable.dart';

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

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      headOfDepartment: json['headOfDepartment'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'headOfDepartment': headOfDepartment,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

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
