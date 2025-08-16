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
  String treatmentPlanId,
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
    final req = await context.request.json() as Map<String, dynamic>;
    final status = req['status'] as TreatmentStatus;
    // to-do: Validate and user has permissions
    final treatmentPlanQuery = await sdb.query(
          r'''
          SELECT * FROM type::table($table) where id = $id;
          ''',
          {
            'table': treatmentPlanTable,
            'id': treatmentPlanId,
          },
        ) as List? ??
        [];
    final treatmentPlan = SurrealQueryResult<TreatmentPlan>.fromJson(
      treatmentPlanQuery[0] as Map<String, dynamic>,
      (json) => TreatmentPlan.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    if (treatmentPlan.isEmpty) {
      return Response(statusCode: HttpStatus.created);
    }

    if (treatmentPlan.first.status == TreatmentStatus.cancelled) {
      return Response(
          statusCode: HttpStatus.internalServerError,
          body: json.encode({'msg': 'cant change a cancelled treatment plan'}));
    }

    var updatedTreatment =
        treatmentPlan.first.copyWith(status: status, updatedAt: DateTime.now());
    if (status == TreatmentStatus.completed ||
        status == TreatmentStatus.cancelled) {
      updatedTreatment = updatedTreatment.copyWith(endDate: DateTime.now());
    }

    await sdb.update(treatmentPlanId, updatedTreatment.toJson());
    // to-do: Notify patient and relevant staff of status changes
    // to-do: Update related appointment statuses if needed
    // to-do: Generate treatment summary report
    return Response(statusCode: HttpStatus.created);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
