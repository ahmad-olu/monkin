import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:test/test.dart';
import 'package:utils/utils.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../../consts/db_table.dart';
import '../../../routes/api/auth/login.dart' as login_route;
import '../../../routes/api/auth/register.dart' as register_route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late Uri uri;

  late String adminId;
  late String superAdminJwt;
  const adminEmail = 'super.admin@gmail.com';
  const adminPassword = 'myVeryVerySecurePassword23';

  const email = 'man.man@gmail.com';
  const password = 'myVerySecuredPassword';
  const role = UserRole.doctor;
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

  setUpAll(() async {
    final db = SurrealDB('ws://localhost:8050/rpc')..connect();
    await db.wait();
    await db.use('test', 'test');
    await db.signin(user: 'root', pass: 'secret');

    await db.delete(userTable);

    final passwordHash = BCrypt.hashpw(adminPassword, BCrypt.gensalt());
    final admin = CreateUser(
      email: adminEmail,
      passwordHash: passwordHash,
      role: UserRole.superAdmin,
      firstName: 'super',
      lastName: 'admin',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    adminId = User.fromJson(
      await db.create(userTable, admin.toJson()) as Map<String, dynamic>? ?? {},
    ).id!;
  });

  // tearDown(() async {
  //   final db = SurrealDB('ws://localhost:8050/rpc')..connect();
  //   await db.wait();
  //   await db.use('test', 'test');
  //   await db.signin(user: 'root', pass: 'secret');
  //   await db.delete(userTable);
  // });

  group('Authorization /api/', () {
    test('super admin login responds with a 200 created', () async {
      // Arrange

      when(() => request.method).thenReturn(HttpMethod.post);
      const formData = FormData(
        fields: {
          'email': adminEmail,
          'password': adminPassword,
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
    test('super admin register new user responds with a 201 created', () async {
      // Arrange

      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: adminId));
      when(() => request.method).thenReturn(HttpMethod.post);
      // when(() => request.headers)
      //     .thenReturn({'Authorization': 'Bearer $superAdminJwt'});

      final formData = FormData(
        fields: {
          'email': email,
          'password': password,
          'role': role.name,
          'firstName': firstName,
          'lastName': lastName,
        },
        files: const {},
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
