import 'package:equatable/equatable.dart';

class Medication extends Equatable {
  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.form,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.genericName,
    this.manufacturer,
    this.description,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      genericName: json['genericName'] as String?,
      dosage: json['dosage'] as String,
      form: json['form'] as String,
      manufacturer: json['manufacturer'] as String?,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }
  final String id;
  final String name;
  final String? genericName;
  final String dosage;
  final String form;
  final String? manufacturer;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Medication copyWith({
    String? id,
    String? name,
    String? genericName,
    String? dosage,
    String? form,
    String? manufacturer,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      dosage: dosage ?? this.dosage,
      form: form ?? this.form,
      manufacturer: manufacturer ?? this.manufacturer,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genericName': genericName,
      'dosage': dosage,
      'form': form,
      'manufacturer': manufacturer,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return '''Medication(id: $id, name: $name, genericName: $genericName, dosage: $dosage, form: $form, manufacturer: $manufacturer, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      genericName,
      dosage,
      form,
      manufacturer,
      description,
      isActive,
      createdAt,
      updatedAt,
    ];
  }
}
