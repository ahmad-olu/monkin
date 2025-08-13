import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';
import '../../../helper/get_user.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.put:
      return _put(context);
    case HttpMethod.get:
    case HttpMethod.post:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _put(RequestContext context) async {
  try {
    final sdb = await context.read<Future<SurrealDB>>();
    final user = await getUser(context);

    final form = (await context.request.formData()).fields;
    final password = form['password'];
    final confirmPassword = form['confirm_password'];

    if (password != confirmPassword) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'msg': 'password and confirm password do not match'},
      );
    }

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

    // ?m for old password check
    // final checkPassword =
    //     BCrypt.checkpw(password!, checkUser.first.passwordHash);
    // if (!checkPassword) {
    //   return Response(statusCode: HttpStatus.internalServerError);
    // }

    final passwordHash = BCrypt.hashpw(password!, BCrypt.gensalt());
    final userResult = checkUser.first.copyWith(
      passwordHash: passwordHash,
      updatedAt: DateTime.now(),
    );

    await sdb.update(userResult.id!, userResult.toJson());

    // To-do: Send user password changed email
    // To-do: Log user password changed event

    return Response.json(
      statusCode: HttpStatus.created,
      body: {'msg': 'user account status updated'},
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
