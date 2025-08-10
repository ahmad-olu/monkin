// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecord _$MedicalRecordFromJson(Map<String, dynamic> json) =>
    MedicalRecord(
      chiefComplaint: json['chiefComplaint'] as String,
      visitDate: DateTime.parse(json['visitDate'] as String),
      id: json['id'] as String?,
      patientId: json['patientId'] as String?,
      doctorId: json['doctorId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      historyOfPresentIllness: json['historyOfPresentIllness'] as String?,
      physicalExamination: json['physicalExamination'] as String?,
      diagnosis: json['diagnosis'] as String?,
      treatmentPlan: json['treatmentPlan'] as String?,
      medications: json['medications'] as String?,
      notes: json['notes'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MedicalRecordToJson(MedicalRecord instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'patientId': ?instance.patientId,
      'doctorId': ?instance.doctorId,
      'chiefComplaint': instance.chiefComplaint,
      'historyOfPresentIllness': instance.historyOfPresentIllness,
      'physicalExamination': instance.physicalExamination,
      'diagnosis': instance.diagnosis,
      'treatmentPlan': instance.treatmentPlan,
      'medications': instance.medications,
      'notes': instance.notes,
      'attachments': instance.attachments,
      'visitDate': instance.visitDate.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
