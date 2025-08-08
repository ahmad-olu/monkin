import 'package:equatable/equatable.dart';

enum AppointmentType {
  consultation,
  followUp,
  checkup,
  procedure,
  emergency,
}

enum AppointmentStatus {
  scheduled,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
}

class Appointment extends Equatable {
  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.duration,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.reason,
    this.notes,
    this.reminderSent,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      appointmentDate:
          DateTime.fromMillisecondsSinceEpoch(json['appointmentDate'] as int),
      duration: Duration(milliseconds: json['duration'] as int? ?? 0),
      type: AppointmentType.values.byName(json['type'] as String),
      status: AppointmentStatus.values.byName(json['status'] as String),
      reason: json['reason'] as String?,
      notes: json['notes'] as String?,
      reminderSent: json['reminderSent'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime appointmentDate;
  final Duration duration;
  final AppointmentType type;
  final AppointmentStatus status;
  final String? reason;
  final String? notes;
  final String? reminderSent;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    DateTime? appointmentDate,
    Duration? duration,
    AppointmentType? type,
    AppointmentStatus? status,
    String? reason,
    String? notes,
    String? reminderSent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      duration: duration ?? this.duration,
      type: type ?? this.type,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      reminderSent: reminderSent ?? this.reminderSent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.millisecondsSinceEpoch,
      'duration': duration.inMilliseconds,
      'type': type.name,
      'status': status.name,
      'reason': reason,
      'notes': notes,
      'reminderSent': reminderSent,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return '''Appointment(id: $id, patientId: $patientId, doctorId: $doctorId, appointmentDate: $appointmentDate, duration: $duration, type: $type, status: $status, reason: $reason, notes: $notes, reminderSent: $reminderSent, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }

  @override
  List<Object?> get props {
    return [
      id,
      patientId,
      doctorId,
      appointmentDate,
      duration,
      type,
      status,
      reason,
      notes,
      reminderSent,
      createdAt,
      updatedAt,
    ];
  }
}
