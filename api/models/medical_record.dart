import 'package:equatable/equatable.dart';

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

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      chiefComplaint: json['chiefComplaint'] as String,
      historyOfPresentIllness: json['historyOfPresentIllness'] as String?,
      physicalExamination: json['physicalExamination'] as String?,
      diagnosis: json['diagnosis'] as String?,
      treatmentPlan: json['treatmentPlan'] as String?,
      medications: json['medications'] as String?,
      notes: json['notes'] as String?,
      attachments: List<String>.from(json['attachments'] as List? ?? []),
      visitDate: DateTime.fromMillisecondsSinceEpoch(json['visitDate'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'chiefComplaint': chiefComplaint,
      'historyOfPresentIllness': historyOfPresentIllness,
      'physicalExamination': physicalExamination,
      'diagnosis': diagnosis,
      'treatmentPlan': treatmentPlan,
      'medications': medications,
      'notes': notes,
      'attachments': attachments,
      'visitDate': visitDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

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
