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
  final treatmentPlanId = id;
  if (context.request.method == HttpMethod.put) {
    final req = await context.request.json() as Map<String, dynamic>;
    final status = TreatmentStatus.values.byName(req['status'] as String);
    // to-do: Validate and user has permissions
    final treatmentPlanQuery = await sdb.query(
          r'''
          SELECT * FROM type::table($table) where id = $id;
          ''',
          {
            'table': treatmentPlanTable,
            'id': id,
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

    final updatedTreatment =
        treatmentPlan.first.copyWith(status: status, updatedAt: DateTime.now());
    if (status == TreatmentStatus.completed ||
        status == TreatmentStatus.cancelled) {
      updatedTreatment.copyWith(endDate: DateTime.now());
    }

    await sdb.update(treatmentPlanId, updatedTreatment.toJson());
    // to-do: Notify patient and relevant staff of status changes
    // to-do: Update related appointment statuses if needed
    // to-do: Generate treatment summary report
    return Response(statusCode: HttpStatus.created);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
