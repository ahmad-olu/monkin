import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';
import '../../../helper/get_user.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  switch (context.request.method) {
    case HttpMethod.delete:
      return _delete(context, id);
    case HttpMethod.get:
    case HttpMethod.put:
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _delete(RequestContext context, String id) async {
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
    final doctorDepartmentId = id;
    // to-do: Validate assignment exists and user has permissions
    final doctorDepartmentQuery = await sdb.query(
          r'''
          SELECT * FROM type::table($table) where id = $id AND isPrimary = true;
          ''',
          {
            'table': doctorDepartmentTable,
            'id': doctorDepartmentId,
          },
        ) as List? ??
        [];

    final doctorDepartment = SurrealQueryResult<DoctorDepartment>.fromJson(
      doctorDepartmentQuery[0] as Map<String, dynamic>,
      (json) =>
          DoctorDepartment.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    if (doctorDepartment.isNotEmpty) {
      return Response.json(
        statusCode: HttpStatus.conflict,
        body: {
          'msg': 'cannot delete primary',
        },
      );
    }
    // to-do: Prevent removal if doctor has active patients in department
    // to-do: Soft delete assignment record with timestamp (lollz). permanent delete jare
    // to-do: Reassign active appointments if necessary
    // to-do: Log assignment removal

    await sdb.delete(doctorDepartmentId);

    return Response();
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
