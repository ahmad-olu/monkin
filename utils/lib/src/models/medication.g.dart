// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medication _$MedicationFromJson(Map<String, dynamic> json) => Medication(
  name: json['name'] as String,
  dosage: json['dosage'] as String,
  form: json['form'] as String,
  id: json['id'] as String?,
  isActive: json['isActive'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  genericName: json['genericName'] as String?,
  manufacturer: json['manufacturer'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$MedicationToJson(Medication instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': instance.name,
      'genericName': instance.genericName,
      'dosage': instance.dosage,
      'form': instance.form,
      'manufacturer': instance.manufacturer,
      'description': instance.description,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
