// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart' show immutable;
import 'package:utils/utils.dart';

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
    required this.appointmentDate,
    required this.duration,
    this.id,
    this.patientId,
    this.doctorId,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.reason,
    this.notes,
    this.reminderSent,
    this.doctor,
    this.patient,
  });

  @JsonKey(includeIfNull: false)
  final String? id;
  @JsonKey(includeIfNull: false)
  final String? patientId;
  @JsonKey(includeIfNull: false)
  final String? doctorId;
  final DateTime appointmentDate; // date and start time
  @DurationConverter()
  final Duration duration;
  final AppointmentType? type;
  final AppointmentStatus? status;
  final String? reason;
  final String? notes;
  final String? reminderSent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @JsonKey(includeIfNull: false)
  final User? doctor;
  @JsonKey(includeIfNull: false)
  final Patient? patient;

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
      patient,
      doctor,
    ];
  }
}

@immutable
@JsonSerializable()
class CreateAppointment {
  const CreateAppointment({
    required this.appointmentDate,
    required this.duration,
    required this.doctorEmail,
    required this.patientEmail,
    this.type,
    this.status,
    this.reason,
    this.notes,
    this.reminderSent,
  });

  final String patientEmail;
  final String doctorEmail;
  final DateTime appointmentDate; // date and start time
  @DurationConverter()
  final Duration duration;
  final AppointmentType? type;
  final AppointmentStatus? status;
  final String? reason;
  final String? notes;
  final String? reminderSent;

  factory CreateAppointment.fromJson(Map<String, dynamic> json) =>
      _$CreateAppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAppointmentToJson(this);
}

class DurationConverter implements JsonConverter<Duration, int> {
  const DurationConverter();

  @override
  Duration fromJson(int milliseconds) => Duration(milliseconds: milliseconds);

  @override
  int toJson(Duration duration) => duration.inMilliseconds;
}
