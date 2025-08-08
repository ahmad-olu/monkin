import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart'
    show CreateUser, CreateUserRequest, User, UserRole;

import '../../../consts/db_table.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final sdb = await context.read<Future<SurrealDB>>();
  // return Response(statusCode: HttpStatus.methodNotAllowed)

  final method = request.method;
  if (method == HttpMethod.post) {
    final form = CreateUserRequest.fromJson(
      await request.formData().then((e) => e.fields),
    );

    final check_user = await sdb
        .query(r'SELECT * FROM type::table($table) WHERE email = $email;', {
      'table': userTable,
      'email': form.email,
    }) as List?;

    final resultList = check_user?.first.result as List;
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

      // TODO: Send welcome email with login credentials
      // TODO: Log user creation event
    }

    return Response(
      statusCode: HttpStatus.created,
      body: json.encode({'msg': 'user created'}),
    );
  }

  return Response(statusCode: HttpStatus.methodNotAllowed);
}
