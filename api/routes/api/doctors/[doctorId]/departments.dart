import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../../consts/db_table.dart';
import '../../../../helper/get_user.dart';

Future<Response> onRequest(
  RequestContext context,
  String doctorId,
) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context, doctorId);
    case HttpMethod.get:
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(RequestContext context, String doctorId) async {
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
    // to-do: Verify doctor exists and has appropriate role
    final req = DoctorDepartment.fromJson(
      await context.request.json() as Map<String, dynamic>,
    );
    final departmentQuery = await sdb.query(
          r'''
          SELECT * FROM type::table($table) where id = $id;
          ''',
          {
            'table': departmentTable,
            'id': req.departmentId,
          },
        ) as List? ??
        [];

    final department = SurrealQueryResult<Department>.fromJson(
      departmentQuery[0] as Map<String, dynamic>,
      (json) => Department.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    if (department.isEmpty) {
      return Response.json(
          statusCode: HttpStatus.conflict,
          body: {'msg': 'department ${department.first.name} does not exist'});
    }

    final doctorDepartmentQuery = await sdb.query(
          r'''
          SELECT * FROM type::table($table) where departmentId = $departmentId AND doctorId = $doctorId;
          ''',
          {
            'table': doctorDepartmentTable,
            'departmentId': req.departmentId,
            'doctorId': doctorId,
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
          'msg': 'doctor in department:${department.first.name} already exist',
        },
      );
    }
    // to-do:check duplicated primary
    final newDep = req.copyWith(createdAt: DateTime.now());
    await sdb.create(doctorDepartmentTable, newDep.toJson());
    // to-do: Notify department head of new assignment
    // to-do: Log assignment change
    return Response(statusCode: HttpStatus.created);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
