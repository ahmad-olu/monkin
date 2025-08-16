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

Future<Response> _put(RequestContext context, String appointmentId) async {
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

    final req = await context.request.json() as Map<String, dynamic>;
    final status = req['status'] as String;

    final appointment = (await sdb.select(appointmentId))
        .map((u) => Appointment.fromJson(u as Map<String, dynamic>))
        .toList();
    if (appointment.isEmpty) {
      return Response(statusCode: HttpStatus.internalServerError);
    }
    if (appointment.first.status == AppointmentStatus.cancelled) {
      return Response(
        statusCode: HttpStatus.internalServerError,
        body: json.encode({'msg': 'cant change cancelled appointments'}),
      );
    }
    final app = appointment.first.copyWith(
      status: AppointmentStatus.values.byName(status),
      updatedAt: DateTime.now(),
    );
    await sdb.update(appointmentTable, app.toJson());
    // to-do: Send notifications based on status change
    // to-do: Update calendar entries accordingly
    // to-do: Log status change for reporting
    return Response(statusCode: HttpStatus.created);
  } catch (e) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
