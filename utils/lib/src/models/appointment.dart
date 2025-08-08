// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart' show immutable;

part 'appointment.g.dart';

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

@immutable
@JsonSerializable()
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

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);

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
