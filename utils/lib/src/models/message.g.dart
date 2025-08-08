// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  id: json['id'] as String,
  senderId: json['senderId'] as String,
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
  subject: json['subject'] as String,
  content: json['content'] as String,
  status: $enumDecode(_$MessageStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  scheduledFor: json['scheduledFor'] == null
      ? null
      : DateTime.parse(json['scheduledFor'] as String),
  sentAt: json['sentAt'] == null
      ? null
      : DateTime.parse(json['sentAt'] as String),
  readAt: json['readAt'] == null
      ? null
      : DateTime.parse(json['readAt'] as String),
  recipientId: json['recipientId'] as String?,
  patientId: json['patientId'] as String?,
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'id': instance.id,
  'senderId': instance.senderId,
  'recipientId': instance.recipientId,
  'patientId': instance.patientId,
  'type': _$MessageTypeEnumMap[instance.type]!,
  'subject': instance.subject,
  'content': instance.content,
  'status': _$MessageStatusEnumMap[instance.status]!,
  'scheduledFor': instance.scheduledFor?.toIso8601String(),
  'sentAt': instance.sentAt?.toIso8601String(),
  'readAt': instance.readAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$MessageTypeEnumMap = {
  MessageType.appointmentReminder: 'appointmentReminder',
  MessageType.treatmentUpdate: 'treatmentUpdate',
  MessageType.generalCommunication: 'generalCommunication',
  MessageType.emergencyAlert: 'emergencyAlert',
};

const _$MessageStatusEnumMap = {
  MessageStatus.draft: 'draft',
  MessageStatus.scheduled: 'scheduled',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};
