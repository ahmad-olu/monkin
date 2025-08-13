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

Future<Response> _put(RequestContext context, String userId) async {
  try {
    final sdb = await context.read<Future<SurrealDB>>();
    final user = await getUser(context);
    if (user.role != UserRole.admin || user.role != UserRole.superAdmin) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {
          'msg': 'you dont have the right privilege to perform this task',
        },
      );
    }

    final checkUserQuery =
        await sdb.query(r'SELECT * FROM type::table($table) WHERE id = $id;', {
              'table': userTable,
              'id': userId,
            }) as List? ??
            [];
    final checkUser = SurrealQueryResult<User>.fromJson(
      checkUserQuery[0] as Map<String, dynamic>,
      (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    final userResult = checkUser.first.copyWith(
      isActive: !(checkUser.first.isActive ?? true),
      updatedAt: DateTime.now(),
    );

    if (user.role == UserRole.admin &&
        (userResult.role == UserRole.admin ||
            userResult.role == UserRole.superAdmin)) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {
          'msg': 'you dont have the right privilege to perform this task',
        },
      );
    }

    await sdb.update(userResult.id!, userResult.toJson());

    // To-do: Send user account status changed email
    // To-do: Log user account status changed event

    return Response.json(
        statusCode: HttpStatus.created,
        body: {'msg': 'user account status updated'});
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
