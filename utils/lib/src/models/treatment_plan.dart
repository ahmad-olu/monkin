// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'treatment_plan.g.dart';

enum TreatmentStatus {
  active,
  completed,
  suspended,
  cancelled,
}

@immutable
@JsonSerializable()
class TreatmentPlan extends Equatable {
  const TreatmentPlan({
    required this.title,
    required this.description,
    required this.startDate,
    required this.goals,
    required this.medications,
    required this.instructions,
    this.status,
    this.id,
    this.patientId,
    this.doctorId,
    this.medicalRecordId,
    this.createdAt,
    this.updatedAt,
    this.endDate,
    this.notes,
  });

  @JsonKey(includeIfNull: false)
  final String? id;
  @JsonKey(includeIfNull: false)
  final String? patientId;
  @JsonKey(includeIfNull: false)
  final String? doctorId;
  @JsonKey(includeIfNull: false)
  final String? medicalRecordId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final TreatmentStatus? status;
  final List<String> goals;
  final List<String> medications;
  final List<String> instructions;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TreatmentPlan copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? medicalRecordId,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    TreatmentStatus? status,
    List<String>? goals,
    List<String>? medications,
    List<String>? instructions,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TreatmentPlan(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      medicalRecordId: medicalRecordId ?? this.medicalRecordId,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      goals: goals ?? this.goals,
      medications: medications ?? this.medications,
      instructions: instructions ?? this.instructions,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) =>
      _$TreatmentPlanFromJson(json);

  Map<String, dynamic> toJson() => _$TreatmentPlanToJson(this);

  @override
  String toString() {
    return '''TreatmentPlan(id: $id, patientId: $patientId, doctorId: $doctorId, medicalRecordId: $medicalRecordId, title: $title, description: $description, startDate: $startDate, endDate: $endDate, status: $status, goals: $goals, medications: $medications, instructions: $instructions, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }

  @override
  List<Object?> get props {
    return [
      id,
      patientId,
      doctorId,
      medicalRecordId,
      title,
      description,
      startDate,
      endDate,
      status,
      goals,
      medications,
      instructions,
      notes,
      createdAt,
      updatedAt,
    ];
  }
}
