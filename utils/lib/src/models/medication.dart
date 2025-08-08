// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;
import 'package:meta/meta.dart' show immutable;

part 'medication.g.dart';

@immutable
@JsonSerializable()
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

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationToJson(this);

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
