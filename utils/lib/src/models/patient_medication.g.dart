// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientMedication _$PatientMedicationFromJson(Map<String, dynamic> json) =>
    PatientMedication(
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      instructions: json['instructions'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      id: json['id'] as String?,
      patientId: json['patientId'] as String?,
      medicationId: json['medicationId'] as String?,
      doctorId: json['doctorId'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$PatientMedicationToJson(PatientMedication instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'patientId': ?instance.patientId,
      'medicationId': ?instance.medicationId,
      'doctorId': ?instance.doctorId,
      'dosage': instance.dosage,
      'frequency': instance.frequency,
      'instructions': instance.instructions,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
