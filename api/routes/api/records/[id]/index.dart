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
  // To-do: check permission
  final sdb = await context.read<Future<SurrealDB>>();
  final user = await getUser(context);

  if (context.request.method == HttpMethod.put) {
    // to-do: Validate user has edit permissions
    final medicalRecordRec = UpdateMedicalRecord.fromJson(
      await context.request.json() as Map<String, dynamic>,
    ).toJson();
    // to-do: Prevent editing of completed/locked records
    // to-do: Track field-level changes for audit
    medicalRecordRec['updatedAt'] = DateTime.now().toIso8601String();

    await sdb.update(medicalRecordTable, medicalRecordRec);
    // to-do: Notify other healthcare providers of changes

    return Response(body: json.encode({'msg': 'record modifies'}));
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
