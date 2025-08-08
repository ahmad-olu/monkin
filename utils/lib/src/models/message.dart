// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart' show immutable;

part 'message.g.dart';

enum MessageType {
  appointmentReminder,
  treatmentUpdate,
  generalCommunication,
  emergencyAlert,
}

enum MessageStatus {
  draft,
  scheduled,
  sent,
  delivered,
  read,
  failed,
}

@immutable
@JsonSerializable()
class Message extends Equatable {
  const Message({
    required this.id,
    required this.senderId,
    required this.type,
    required this.subject,
    required this.content,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.scheduledFor,
    this.sentAt,
    this.readAt,
    this.recipientId,
    this.patientId,
  });

  final String id;
  final String senderId;
  final String? recipientId;
  final String? patientId;
  final MessageType type;
  final String subject;
  final String content;
  final MessageStatus status;
  final DateTime? scheduledFor;
  final DateTime? sentAt;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message copyWith({
    String? id,
    String? senderId,
    String? recipientId,
    String? patientId,
    MessageType? type,
    String? subject,
    String? content,
    MessageStatus? status,
    DateTime? scheduledFor,
    DateTime? sentAt,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      patientId: patientId ?? this.patientId,
      type: type ?? this.type,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      status: status ?? this.status,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return '''Message(id: $id, senderId: $senderId, recipientId: $recipientId, patientId: $patientId, type: $type, subject: $subject, content: $content, status: $status, scheduledFor: $scheduledFor, sentAt: $sentAt, readAt: $readAt, createdAt: $createdAt, updatedAt: $updatedAt)''';
  }

  @override
  List<Object?> get props {
    return [
      id,
      senderId,
      recipientId,
      patientId,
      type,
      subject,
      content,
      status,
      scheduledFor,
      sentAt,
      readAt,
      createdAt,
      updatedAt,
    ];
  }
}
