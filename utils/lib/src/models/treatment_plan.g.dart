// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreatmentPlan _$TreatmentPlanFromJson(Map<String, dynamic> json) =>
    TreatmentPlan(
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      status: $enumDecode(_$TreatmentStatusEnumMap, json['status']),
      goals: (json['goals'] as List<dynamic>).map((e) => e as String).toList(),
      medications: (json['medications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      id: json['id'] as String?,
      patientId: json['patientId'] as String?,
      doctorId: json['doctorId'] as String?,
      medicalRecordId: json['medicalRecordId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$TreatmentPlanToJson(TreatmentPlan instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'patientId': ?instance.patientId,
      'doctorId': ?instance.doctorId,
      'medicalRecordId': ?instance.medicalRecordId,
      'title': instance.title,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'status': _$TreatmentStatusEnumMap[instance.status]!,
      'goals': instance.goals,
      'medications': instance.medications,
      'instructions': instance.instructions,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$TreatmentStatusEnumMap = {
  TreatmentStatus.active: 'active',
  TreatmentStatus.completed: 'completed',
  TreatmentStatus.suspended: 'suspended',
  TreatmentStatus.cancelled: 'cancelled',
};
