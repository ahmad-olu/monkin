import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';
import '../../../helper/get_user.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(RequestContext context) async {
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
    final req = Department.fromJson(
      await context.request.json() as Map<String, dynamic>,
    );
    final departmentQuery = await sdb.query(
          r'''
          SELECT * FROM type::table($table) where name = $name;
          ''',
          {
            'table': departmentTable,
            'name': req.name,
          },
        ) as List? ??
        [];

    final department = SurrealQueryResult<Department>.fromJson(
      departmentQuery[0] as Map<String, dynamic>,
      (json) => Department.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    if (department.isNotEmpty) {
      return Response.json(
          statusCode: HttpStatus.conflict,
          body: {'msg': 'department ${department.first.name} already exist'});
    }
    // to-do: Verify user has administrative permissions
    final newDep = req.copyWith(createdAt: DateTime.now(), isActive: true);
    // to-do: Create department hierarchy relationships if applicable
    await sdb.create(departmentTable, newDep.toJson());
    // to-do: Log department creation
    // to-do: Notify relevant administrators

    return Response.json(statusCode: HttpStatus.created);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _get(RequestContext context) async {
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
    // to-do: Query active departments with optional filters
    // to-do: Include head of department information
    // to-do: Count assigned doctors per department

    final medicationQuery = await sdb.query(
          r'''
           SELECT *
           FROM type::table($table)
           ORDER BY name ASC, createdAt DESC;
          ''',
          {
            'table': departmentTable,
          },
        ) as List? ??
        [];

    final medication = SurrealQueryResult<Department>.fromJson(
      medicationQuery[0] as Map<String, dynamic>,
      (json) => Department.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    return Response.json(body: medication);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
