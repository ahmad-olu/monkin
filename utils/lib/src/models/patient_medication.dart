// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart' show immutable;

part 'patient_medication.g.dart';

@immutable
@JsonSerializable()
class PatientMedication extends Equatable {
  const PatientMedication({
    required this.dosage,
    required this.frequency,
    required this.instructions,
    required this.startDate,
    this.id,
    this.patientId,
    this.medicationId,
    this.doctorId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.endDate,
  });

  @JsonKey(includeIfNull: false)
  final String? id;
  @JsonKey(includeIfNull: false)
  final String? patientId;
  @JsonKey(includeIfNull: false)
  final String? medicationId;
  @JsonKey(includeIfNull: false)
  final String? doctorId;
  final String dosage;
  final String frequency;
  final String instructions;
  final DateTime startDate;
  final DateTime? endDate;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PatientMedication copyWith({
    String? id,
    String? patientId,
    String? medicationId,
    String? doctorId,
    String? dosage,
    String? frequency,
    String? instructions,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientMedication(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      medicationId: medicationId ?? this.medicationId,
      doctorId: doctorId ?? this.doctorId,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      instructions: instructions ?? this.instructions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory PatientMedication.fromJson(Map<String, dynamic> json) =>
      _$PatientMedicationFromJson(json);

  Map<String, dynamic> toJson() => _$PatientMedicationToJson(this);

  @override
  String toString() {
    return '''PatientMedication(id: $id, patientId: $patientId, medicationId: $medicationId, doctorId: $doctorId, dosage: $dosage, frequency: $frequency, instructions: $instructions, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }

  @override
  List<Object?> get props {
    return [
      id,
      patientId,
      medicationId,
      doctorId,
      dosage,
      frequency,
      instructions,
      startDate,
      endDate,
      isActive,
      createdAt,
      updatedAt,
    ];
  }
}
