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
  final sdb = await context.read<Future<SurrealDB>>();
  final user = await getUser(context);

  if (context.request.method == HttpMethod.put) {
    // to-do: Validate user has permissions
    final appointmentId = id;
    final req = await context.request.json() as Map<String, dynamic>;
    final status = req['status'] as String;

    final appointment = await sdb.select<Appointment>(appointmentId);
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
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
