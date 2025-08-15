import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart' show Patient, UserRole;

import '../../../helper/get_user.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.put:
      return _put(context, id);
    case HttpMethod.get:
      return _get(context, id);
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
  String patientId,
) async {
  try {
    // To-do: check permission
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
    final data = await context.request.json() as Map<String, dynamic>;
    data['updatedAt'] = DateTime.now().toIso8601String();

    final patient = Patient.fromJson(
        await sdb.merge(patientId, data) as Map<String, dynamic>? ?? {});
    // to-do: Log changes for audit purposes
    return Response.json(
      statusCode: HttpStatus.created,
      body: patient.toJson(),
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _get(
  RequestContext context,
  String patientId,
) async {
  try {
    // To-do: check permission
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
    // to-do: Query patient by ID with active status check
    // ignore: inference_failure_on_function_invocation
    final patient = (await sdb.select(patientId))
        .map((u) => Patient.fromJson(u as Map<String, dynamic>))
        .toList();

    if (patient.isEmpty) {
      return Response(statusCode: HttpStatus.notFound);
    }
    // to-do: Include related data like recent appointments and medical records
    // to-do: Log patient access for audit trail

    return Response.json(body: patient.first.toJson());
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
