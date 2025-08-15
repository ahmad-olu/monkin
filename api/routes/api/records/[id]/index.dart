import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../../consts/db_table.dart';
import '../../../../helper/get_user.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.put:
      return _put(context, id);
    case HttpMethod.get:
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _put(
  RequestContext context,
  String medicalRecordId,
) async {
  try {
    final sdb = await context.read<Future<SurrealDB>>();
    final user = await getUser(context);
    if (user.role != UserRole.admin &&
        user.role != UserRole.superAdmin &&
        user.role != UserRole.doctor &&
        user.role != UserRole.nurse &&
        user.role != UserRole.receptionist) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {
          'msg': 'you dont have the right privilege to perform this task',
        },
      );
    }
    // to-do: Validate user has edit permissions
    final medicalRecordRec = UpdateMedicalRecord.fromJson(
      await context.request.json() as Map<String, dynamic>,
    ).toJson();
    // to-do: Prevent editing of completed/locked records
    // to-do: Track field-level changes for audit
    medicalRecordRec['updatedAt'] = DateTime.now().toIso8601String();

    await sdb.merge(medicalRecordTable, medicalRecordRec);
    // to-do: Notify other healthcare providers of changes

    return Response(
        statusCode: HttpStatus.created,
        body: json.encode({'msg': 'record modifies'}));
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
