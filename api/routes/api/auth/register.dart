import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart'
    show CreateUser, CreateUserRequest, SurrealQueryResult, User, UserRole;

import '../../../consts/db_table.dart';
import '../../../helper/get_user.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.get:
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
    if (user.role != UserRole.admin && user.role != UserRole.superAdmin) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {
          'msg': 'you dont have the right privilege to perform this task',
        },
      );
    }
    final form = CreateUserRequest.fromJson(
      await context.request.formData().then((e) => e.fields),
    );
    if (user.role == UserRole.admin && form.role == UserRole.admin) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {
          'msg': 'you dont have the right privilege to perform this task',
        },
      );
    }
    // to-do: make email unique
    final checkUserQuery = await sdb
            .query(r'SELECT * FROM type::table($table) WHERE email = $email;', {
          'table': userTable,
          'email': form.email,
        }) as List? ??
        [];
    final checkUser = SurrealQueryResult<User>.fromJson(
      checkUserQuery[0] as Map<String, dynamic>,
      (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    final resultList = checkUser;
    if (resultList.isEmpty) {
      final passwordHash = BCrypt.hashpw(form.password, BCrypt.gensalt());
      final userData = CreateUser(
        email: form.email,
        passwordHash: passwordHash,
        role: form.role,
        firstName: form.firstName,
        lastName: form.lastName,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: user.id,
      );

      await sdb
          .create(userTable, userData)
          .then((e) => User.fromJson(e as Map<String, dynamic>? ?? {}));

      // To-do: Send welcome email with login credentials
      // To-do: Log user creation event
    }

    return Response(
      statusCode: HttpStatus.created,
      body: json.encode({'msg': 'user created'}),
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
