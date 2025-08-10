// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
  appointmentDate: DateTime.parse(json['appointmentDate'] as String),
  duration: const DurationConverter().fromJson(
    (json['duration'] as num).toInt(),
  ),
  id: json['id'] as String?,
  patientId: json['patientId'] as String?,
  doctorId: json['doctorId'] as String?,
  type: $enumDecodeNullable(_$AppointmentTypeEnumMap, json['type']),
  status: $enumDecodeNullable(_$AppointmentStatusEnumMap, json['status']),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  reason: json['reason'] as String?,
  notes: json['notes'] as String?,
  reminderSent: json['reminderSent'] as String?,
  doctor: json['doctor'] == null
      ? null
      : User.fromJson(json['doctor'] as Map<String, dynamic>),
  patient: json['patient'] == null
      ? null
      : Patient.fromJson(json['patient'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'patientId': ?instance.patientId,
      'doctorId': ?instance.doctorId,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'duration': const DurationConverter().toJson(instance.duration),
      'type': _$AppointmentTypeEnumMap[instance.type],
      'status': _$AppointmentStatusEnumMap[instance.status],
      'reason': instance.reason,
      'notes': instance.notes,
      'reminderSent': instance.reminderSent,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'doctor': ?instance.doctor,
      'patient': ?instance.patient,
    };

const _$AppointmentTypeEnumMap = {
  AppointmentType.consultation: 'consultation',
  AppointmentType.followUp: 'followUp',
  AppointmentType.checkup: 'checkup',
  AppointmentType.procedure: 'procedure',
  AppointmentType.emergency: 'emergency',
};

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.scheduled: 'scheduled',
  AppointmentStatus.confirmed: 'confirmed',
  AppointmentStatus.inProgress: 'inProgress',
  AppointmentStatus.completed: 'completed',
  AppointmentStatus.cancelled: 'cancelled',
  AppointmentStatus.noShow: 'noShow',
};

CreateAppointment _$CreateAppointmentFromJson(Map<String, dynamic> json) =>
    CreateAppointment(
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      duration: const DurationConverter().fromJson(
        (json['duration'] as num).toInt(),
      ),
      doctorEmail: json['doctorEmail'] as String,
      patientEmail: json['patientEmail'] as String,
      type: $enumDecodeNullable(_$AppointmentTypeEnumMap, json['type']),
      status: $enumDecodeNullable(_$AppointmentStatusEnumMap, json['status']),
      reason: json['reason'] as String?,
      notes: json['notes'] as String?,
      reminderSent: json['reminderSent'] as String?,
    );

Map<String, dynamic> _$CreateAppointmentToJson(CreateAppointment instance) =>
    <String, dynamic>{
      'patientEmail': instance.patientEmail,
      'doctorEmail': instance.doctorEmail,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'duration': const DurationConverter().toJson(instance.duration),
      'type': _$AppointmentTypeEnumMap[instance.type],
      'status': _$AppointmentStatusEnumMap[instance.status],
      'reason': instance.reason,
      'notes': instance.notes,
      'reminderSent': instance.reminderSent,
    };
