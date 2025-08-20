import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';

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
    final request = context.request;
    final sdb = await context.read<Future<SurrealDB>>();

    final json = await request.json() as Map<String, dynamic>;
    final reqRefreshToken = json['refresh_token'] as String?;

    if (reqRefreshToken == null) {
      return Response(statusCode: HttpStatus.badRequest);
    }

    final payload = JWT.verify(reqRefreshToken, SecretKey('secret passphrase'));
    final payloadData = payload.payload as Map<String, dynamic>;
    final id = payloadData['id'] as String;
    final checkUserQuery =
        await sdb.query(r'SELECT * FROM type::table($table) WHERE id = $id;', {
              'table': userTable,
              'id': id,
            }) as List? ??
            [];
    final checkUser = SurrealQueryResult<User>.fromJson(
      checkUserQuery[0] as Map<String, dynamic>,
      (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    if (checkUser.isEmpty) {
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
    final accessToken = jwt.sign(
      SecretKey('secret passphrase'),
      expiresIn: const Duration(hours: 1),
    );

    final refreshToken = jwt.sign(
      SecretKey('secret passphrase'),
      expiresIn: const Duration(hours: 1),
    );
    // To-do: pass secret from .environment
    // To-do: Log successful login attempt

    return Response.json(
      body: {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'data': checkUser.first,
      },
    );
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
