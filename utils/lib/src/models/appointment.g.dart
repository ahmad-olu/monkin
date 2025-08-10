// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
  appointmentDate: DateTime.parse(json['appointmentDate'] as String),
  duration: Duration(microseconds: (json['duration'] as num).toInt()),
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
);

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'patientId': ?instance.patientId,
      'doctorId': ?instance.doctorId,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
      'type': _$AppointmentTypeEnumMap[instance.type],
      'status': _$AppointmentStatusEnumMap[instance.status],
      'reason': instance.reason,
      'notes': instance.notes,
      'reminderSent': instance.reminderSent,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
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
