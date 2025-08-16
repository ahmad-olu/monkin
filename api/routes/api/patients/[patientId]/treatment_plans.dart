import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../../consts/db_table.dart';
import '../../../../helper/get_user.dart';
import '../../../../helper/patient_exist.dart';

Future<Response> onRequest(
  RequestContext context,
  String patientId,
) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context, patientId);
    case HttpMethod.get:
      return _get(context, patientId);
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(
  RequestContext context,
  String patientId,
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
    // to-do: Verify doctor has treatment permissions

    final patient = await doesPatientWithIdExist(sdb, patientId);
    if (patient == null) {
      return Response(statusCode: HttpStatus.internalServerError);
    }
    final treatmentPlanRec = TreatmentPlan.fromJson(
      await context.request.json() as Map<String, dynamic>,
    ).copyWith(
      status: TreatmentStatus.active,
      patientId: patientId,
      doctorId: user.id,
      createdAt: DateTime.now(),
    );
    await sdb.create(treatmentPlanTable, treatmentPlanRec.toJson());
    // to-do: Schedule follow-up reminders
    // to-do: Notify patient of new treatment plan

    return Response(statusCode: HttpStatus.created);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _get(
  RequestContext context,
  String patientId,
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
    // to-do:Verify user has permission to view patient's treatment plans
    // to-do: Query active and historical treatment plans
    // to-do:Include progress tracking information
    final treatmentPlanQuery = await sdb.query(
          r'''
          SELECT * FROM type::table($table)
          ORDER BY status ASC, createdAt DESC;
          ''',
          {
            'table': treatmentPlanTable,
          },
        ) as List? ??
        [];
    final treatmentPlan = SurrealQueryResult<TreatmentPlan>.fromJson(
      treatmentPlanQuery[0] as Map<String, dynamic>,
      (json) => TreatmentPlan.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    // to-do: Include associated medications and goals
    // to-do: Calculate completion percentages

    return Response.json(body: treatmentPlan);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
