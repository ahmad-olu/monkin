import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';
import '../../../helper/get_user.dart';

Future<Response> onRequest(RequestContext context) async {
  final sdb = await context.read<Future<SurrealDB>>();
  final user = await getUser(context);

  if (context.request.method == HttpMethod.post) {
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
  } else if (context.request.method == HttpMethod.get) {
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
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
