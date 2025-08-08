import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final sdb = await context.read<Future<SurrealDB>>();

  final method = request.method;
  if (method == HttpMethod.post) {
    final form = await request.formData().then((e) => e.fields);
    final email = form['email'];
    final password = form['password'];

    final checkUser = await sdb
        .query(r'SELECT * FROM type::table($table) WHERE email = $email;', {
      'table': userTable,
      'email': email,
    }) as List?;
    final first = checkUser?.first.result as List<User>;

    if (first.isEmpty) {
      return Response(statusCode: HttpStatus.internalServerError);
    }

    final checkPassword = BCrypt.checkpw(password!, first.first.passwordHash);
    if (!checkPassword) {
      return Response(statusCode: HttpStatus.internalServerError);
    }

    final jwt = JWT(
      {
        'id': first.first.id,
        'role': 'admin',
        'exp': const Duration(hours: 1),
      },
    );
    final token = jwt.sign(SecretKey('secret passphrase'));
    // TODO: Log successful login attempt

    return Response(
      body: json.encode({'access_token': token, 'data': first.first}),
    );
  }

  return Response(statusCode: HttpStatus.methodNotAllowed);
}
