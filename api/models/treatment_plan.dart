import 'package:equatable/equatable.dart';

enum TreatmentStatus {
  active,
  completed,
  suspended,
  cancelled,
}

class TreatmentPlan extends Equatable {
  const TreatmentPlan({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.medicalRecordId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.status,
    required this.goals,
    required this.medications,
    required this.instructions,
    required this.createdAt,
    required this.updatedAt,
    this.endDate,
    this.notes,
  });

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      medicalRecordId: json['medicalRecordId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int),
      endDate:
          DateTime.fromMillisecondsSinceEpoch(json['endDate'] as int? ?? 0),
      status: TreatmentStatus.values.byName(json['status'] as String),
      goals: List<String>.from(json['goals'] as List),
      medications: List<String>.from(json['medications'] as List),
      instructions: List<String>.from(json['instructions'] as List),
      notes: json['notes'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }
  final String id;
  final String patientId;
  final String doctorId;
  final String medicalRecordId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final TreatmentStatus status;
  final List<String> goals;
  final List<String> medications;
  final List<String> instructions;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'medicalRecordId': medicalRecordId,
      'title': title,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'status': status.name,
      'goals': goals,
      'medications': medications,
      'instructions': instructions,
      'notes': notes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

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
