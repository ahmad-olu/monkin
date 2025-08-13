import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';
import '../../../helper/get_user.dart';
import '../../index.dart' hide User;

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.put:
      return _put(context);
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  try {
    final sdb = await context.read<Future<SurrealDB>>();
    final user = await getUser(context);

    final checkUserQuery = await sdb.query(
            r'SELECT * OMIT passwordHash FROM type::table($table) WHERE id = $id;',
            {
              'table': userTable,
              'id': user.id,
            }) as List? ??
        [];
    final checkUser = SurrealQueryResult<User>.fromJson(
      checkUserQuery[0] as Map<String, dynamic>,
      (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    // To-do: Log user view event

    return Response.json(
      body: checkUser.first.toJson(),
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _put(RequestContext context) async {
  try {
    final sdb = await context.read<Future<SurrealDB>>();
    final user = await getUser(context);

    final json = await context.request.json() as Map<String, dynamic>;
    final email = json['email'] as String? ?? '';
    final firstName = json['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    final phone = json['phone'] as String? ?? '';

    final checkUserQuery =
        await sdb.query(r'SELECT * FROM type::table($table) WHERE id = $id;', {
              'table': userTable,
              'id': user.id,
            }) as List? ??
            [];
    final checkUser = SurrealQueryResult<User>.fromJson(
      checkUserQuery[0] as Map<String, dynamic>,
      (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    final userResult = checkUser.first;
    final newUser = userResult.copyWith(
      email: email.isEmpty ? userResult.email : email,
      firstName: firstName.isEmpty ? userResult.firstName : firstName,
      lastName: lastName.isEmpty ? userResult.lastName : lastName,
      phone: phone.isEmpty ? userResult.phone : phone,
    );

    await sdb.update(userResult.id!, newUser.toJson());

    // To-do: Send user account updated email
    // To-do: Log user account updated event

    return Response.json(
      statusCode: HttpStatus.created,
      body: {'msg': 'user account updated'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
