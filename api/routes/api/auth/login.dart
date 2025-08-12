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

    final checkUserQuery = await sdb
            .query(r'SELECT * FROM type::table($table) WHERE email = $email;', {
          'table': userTable,
          'email': email,
        }) as List? ??
        [];
    final checkUser = SurrealQueryResult<User>.fromJson(
      checkUserQuery[0] as Map<String, dynamic>,
      (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    if (checkUser.isEmpty) {
      return Response(statusCode: HttpStatus.unauthorized);
    }

    final checkPassword =
        BCrypt.checkpw(password!, checkUser.first.passwordHash);
    if (!checkPassword) {
      return Response(statusCode: HttpStatus.internalServerError);
    }

    final jwt = JWT(
      {
        'id': checkUser.first.id,
        'role': 'admin',
      },
      subject: checkUser.first.id,
      issuer: 'monkin',
      audience: Audience.one('https://monkin.com'),
    );
    final token = jwt.sign(
      SecretKey('secret passphrase'),
      expiresIn: const Duration(hours: 1),
    );
    // To-do: pass secret from .environment
    // To-do: Log successful login attempt

    return Response(
      body: json.encode({'access_token': token, 'data': checkUser.first}),
    );
  }

  return Response(statusCode: HttpStatus.methodNotAllowed);
}
