import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:test/test.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';
import '../../../routes/api/auth/change_password.dart' as change_password_route;
import '../../../routes/api/auth/login.dart' as login_route;
import '../../../routes/api/auth/profile.dart' as profile_route;
import '../../../routes/api/auth/register.dart' as register_route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late Uri uri;

  late String adminId;
  const adminEmail = 'super.admin@gmail.com';
  const adminPassword = 'myVeryVerySecurePassword23';
  const adminNewPassword = 'myVeryVerySecurePassword239';

  late String user1Id;
  const email = 'man.man@gmail.com';
  const password = 'myVerySecuredPassword';
  const newPassword = 'myVerySecuredPassword22';
  const role = UserRole.doctor;
  const firstName = 'Johnny';
  const newFirstName = 'mon';
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

    test('non admin login responds with a 200 created', () async {
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
      final body = json.decode(await response.body()) as Map<String, dynamic>;
      final accessToken = body['access_token'] as String;
      user1Id = body['data']['id'] as String;
      expect(accessToken.isEmpty, equals(false));
    });

    test('non admin change password responds with a 201 created', () async {
      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: user1Id));
      when(() => request.method).thenReturn(HttpMethod.put);
      const formData = FormData(
        fields: {
          'password': newPassword,
          'confirm_password': newPassword,
        },
        files: {},
      );
      when(() => request.formData()).thenAnswer((_) async => formData);

      final response = await change_password_route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
    });

    test('non admin view profile responds with a 200 ok', () async {
      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: user1Id));
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await profile_route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = json.decode(await response.body()) as Map<String, dynamic>;
      final pEmail = body['email'] as String;
      expect(pEmail, equals(email));
    });

    test('non admin update profile responds with a 201 created', () async {
      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: user1Id));
      when(() => request.method).thenReturn(HttpMethod.put);

      when(() => request.json()).thenAnswer(
        (_) async => {'firstName': newFirstName, 'phone': '+2349857566299'},
      );

      final response = await profile_route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
      final body = json.decode(await response.body()) as Map<String, dynamic>;
      final msg = body['msg'] as String;
      expect(msg, equals('user account updated'));
    });
  });

  // to-do: user activate
  // to-do: user role
}
