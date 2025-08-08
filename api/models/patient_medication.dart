import 'package:equatable/equatable.dart';

class PatientMedication extends Equatable {
  const PatientMedication({
    required this.id,
    required this.patientId,
    required this.medicationId,
    required this.doctorId,
    required this.dosage,
    required this.frequency,
    required this.instructions,
    required this.startDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.endDate,
  });

  factory PatientMedication.fromJson(Map<String, dynamic> json) {
    return PatientMedication(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      medicationId: json['medicationId'] as String,
      doctorId: json['doctorId'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      instructions: json['instructions'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int),
      endDate:
          DateTime.fromMillisecondsSinceEpoch(json['endDate'] as int? ?? 0),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }
  final String id;
  final String patientId;
  final String medicationId;
  final String doctorId;
  final String dosage;
  final String frequency;
  final String instructions;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'medicationId': medicationId,
      'doctorId': doctorId,
      'dosage': dosage,
      'frequency': frequency,
      'instructions': instructions,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

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
