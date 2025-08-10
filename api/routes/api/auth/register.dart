import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart'
    show CreateUser, CreateUserRequest, SurrealQueryResult, User, UserRole;

import '../../../consts/db_table.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final sdb = await context.read<Future<SurrealDB>>();

  final method = request.method;
  if (method == HttpMethod.post) {
    final form = CreateUserRequest.fromJson(
      await request.formData().then((e) => e.fields),
    );

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
        role: UserRole.admin,
        firstName: form.firstName,
        lastName: form.lastName,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
  }

  return Response(statusCode: HttpStatus.methodNotAllowed);
}
