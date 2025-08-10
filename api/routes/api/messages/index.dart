import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';
import '../../../helper/get_user.dart';
import '../../../helper/patient_exist.dart';

Future<Response> onRequest(RequestContext context) async {
  final sdb = await context.read<Future<SurrealDB>>();
  final user = await getUser(context);

  if (context.request.method == HttpMethod.post) {
    // to-do:Validate sender has permission to send messages

    final messageRec = Message.fromJson(
      await context.request.json() as Map<String, dynamic>,
    );

    if (messageRec.patientId != null) {
      final res = await doesPatientWithIdExist(sdb, messageRec.patientId!);
      if (res == null) {
        return Response(
          statusCode: HttpStatus.badRequest,
          body: json.encode({'msg': 'patient does not exist'}),
        );
      }
    }

    if (messageRec.recipientId != null) {
      final res = await doesUserWithIdExist(sdb, messageRec.recipientId!);
      if (res == null) {
        return Response(
          statusCode: HttpStatus.badRequest,
          // body: json.encode({"msg": "user does not exist"}),
        );
      }
    }
    final newMessage = messageRec.copyWith(updatedAt: DateTime.now());

    if (messageRec.status == MessageStatus.draft) {
      await sdb.create(messageTable, newMessage.toJson());
    } else if (messageRec.status == MessageStatus.scheduled) {
      // to-do: Queue message for scheduled delivery
    } else {
      newMessage.copyWith(status: MessageStatus.sent);
      await sdb.create(messageTable, newMessage.toJson());

      if (newMessage.patientId != null && newMessage.recipientId == null) {
        // to-do: email patient the message
      }

      // to-do: Track delivery attempts and status
      // to-do: Log message creation
    }

    return Response(statusCode: HttpStatus.created);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
