// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart' show JsonSerializable;
import 'package:meta/meta.dart' show immutable;

part 'medical_record.g.dart';

@immutable
@JsonSerializable()
class MedicalRecord extends Equatable {
  const MedicalRecord({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.chiefComplaint,
    required this.visitDate,
    required this.createdAt,
    required this.updatedAt,
    this.historyOfPresentIllness,
    this.physicalExamination,
    this.diagnosis,
    this.treatmentPlan,
    this.medications,
    this.notes,
    this.attachments,
  });

  final String id;
  final String patientId;
  final String doctorId;
  final String chiefComplaint;
  final String? historyOfPresentIllness;
  final String? physicalExamination;
  final String? diagnosis;
  final String? treatmentPlan;
  final String? medications;
  final String? notes;
  final List<String>? attachments;
  final DateTime visitDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  MedicalRecord copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? chiefComplaint,
    String? historyOfPresentIllness,
    String? physicalExamination,
    String? diagnosis,
    String? treatmentPlan,
    String? medications,
    String? notes,
    List<String>? attachments,
    DateTime? visitDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      historyOfPresentIllness:
          historyOfPresentIllness ?? this.historyOfPresentIllness,
      physicalExamination: physicalExamination ?? this.physicalExamination,
      diagnosis: diagnosis ?? this.diagnosis,
      treatmentPlan: treatmentPlan ?? this.treatmentPlan,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
      visitDate: visitDate ?? this.visitDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MedicalRecord.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordToJson(this);

  @override
  String toString() {
    return '''MedicalRecord(id: $id, patientId: $patientId, doctorId: $doctorId, chiefComplaint: $chiefComplaint, historyOfPresentIllness: $historyOfPresentIllness, physicalExamination: $physicalExamination, diagnosis: $diagnosis, treatmentPlan: $treatmentPlan, medications: $medications, notes: $notes, attachments: $attachments, visitDate: $visitDate, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }

  @override
  List<Object?> get props {
    return [
      id,
      patientId,
      doctorId,
      chiefComplaint,
      historyOfPresentIllness,
      physicalExamination,
      diagnosis,
      treatmentPlan,
      medications,
      notes,
      attachments,
      visitDate,
      createdAt,
      updatedAt,
    ];
  }
}
