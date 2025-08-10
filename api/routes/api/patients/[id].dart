import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart' show Patient, UpdatePatient, fromJson;

import '../../../consts/db_table.dart';
import '../../../helper/get_user.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  // To-do: check permission
  final sdb = await context.read<Future<SurrealDB>>();
  final user = await getUser(context);
  if (context.request.method == HttpMethod.get) {
    // to-do: Query patient by ID with active status check
    final patient = await sdb.select<Patient>(id);

    if (patient.isEmpty) {
      return Response(statusCode: HttpStatus.notFound);
    }
    // to-do: Include related data like recent appointments and medical records
    // to-do: Log patient access for audit trail

    return Response(body: json.encode(patient));
  } else if (context.request.method == HttpMethod.put) {
    // to-do:Check user permissions for patient updates

    // final newPatientRec = UpdatePatient.fromJson(
    //   await context.request.json() as Map<String, dynamic>,
    // );

    final data = await context.request.json() as Map<String, dynamic>;
    data['updatedAt'] = DateTime.now().toIso8601String();

    final patient =
        Patient.fromJson(await sdb.update(id) as Map<String, dynamic>? ?? {});

    // to-do: Log changes for audit purposes
    return Response(
        statusCode: HttpStatus.created, body: json.encode(patient.toJson()));
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
