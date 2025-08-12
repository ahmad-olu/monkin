import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:test/test.dart';

import '../../../routes/api/auth/login.dart' as login_route;
import '../../../routes/api/auth/register.dart' as register_route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late Uri uri;

  const email = 'man.man@gmail.com';
  const password = 'myVerySecuredPassword';
  const role = 'admin';
  const firstName = 'Johnny';
  const lastName = 'dove';

  setUp(() async {
    context = _MockRequestContext();
    request = _MockRequest();
    uri = _MockUri();
    when(() => context.request).thenReturn(request);
    when(() => request.uri).thenReturn(uri);

    final db = SurrealDB('ws://localhost:8050/rpc')..connect();
    await db.wait();
    await db.use('test', 'test');
    await db.signin(user: 'root', pass: 'secret');

    when(() => context.read<Future<SurrealDB>>()).thenAnswer((_) async => db);
  });

  //tearDown(() async {});

  group('Authorization /api/', () {
    test('registration responds with a 201 created', () async {
      // Arrange

      when(() => request.method).thenReturn(HttpMethod.post);
      const formData = FormData(
        fields: {
          'email': email,
          'password': password,
          'role': role,
          'firstName': firstName,
          'lastName': lastName,
        },
        files: {},
      );

      when(() => request.formData()).thenAnswer((_) async => formData);

      // Act
      final response = await register_route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(HttpStatus.created));
      //expect(response.body(), completion(equals('Hello World')));
    });

    test('login responds with a 200 created', () async {
      // Arrange

      when(() => request.method).thenReturn(HttpMethod.post);
      const formData = FormData(
        fields: {
          'email': email,
          'password': password,
        },
        files: {},
      );

      when(() => request.formData()).thenAnswer((_) async => formData);

      // Act
      final response = await login_route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(HttpStatus.ok));
      final accessToken = (json.decode(await response.body())
          as Map<String, dynamic>)['access_token'] as String;
      expect(accessToken.isEmpty, equals(false));
    });
  });
}
