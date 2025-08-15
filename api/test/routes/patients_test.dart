import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:test/test.dart';
import 'package:utils/utils.dart';

import '../../consts/db_table.dart';
import '../../routes/api/auth/login.dart' as login_route;
import '../../routes/api/auth/register.dart' as register_route;
import '../../routes/api/patients/index.dart' as patients_route;
import '../../routes/api/patients/[id].dart' as patient_route;

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

  late String user1Id;
  const email = 'man.man@gmail.com';
  const password = 'myVerySecuredPassword';
  const role = UserRole.doctor;
  const firstName = 'Johnny';
  const lastName = 'dove';

  late String patientId;

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
    await db.delete(patientTable);

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

  group('Patient /api/', () {
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
      user1Id = (body['data'] as Map)['id'] as String;
      expect(accessToken.isEmpty, equals(false));
    });

    test('non admin add patient responds with a 201 created', () async {
      // Arrange

      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: user1Id));
      when(() => request.method).thenReturn(HttpMethod.post);
      final data = Patient(
        address: '9897, new address street, new address',
        patientNumber: '', //number
        firstName: 'malik',
        lastName: 'monk',
        dateOfBirth: DateTime(1987, 9, 7),
        gender: Gender.male,
        phone: '+2345869574889',
      );

      when(() => request.json()).thenAnswer((_) async => data.toJson());

      // Act
      final response = await patients_route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(HttpStatus.created));
      final body = json.decode(await response.body()) as Map<String, dynamic>;

      final patientFirstName = body['firstName'] as String;
      patientId = body['id'] as String;
      expect(patientFirstName, equals('malik'));
    });

    test('non admin get patient responds with a 200 ok', () async {
      // Arrange

      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: user1Id));
      when(() => request.method).thenReturn(HttpMethod.get);

      // Act
      final response = await patients_route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = json.decode(await response.body()) as List<dynamic>;
      expect(body.isEmpty, equals(false));
      final patients =
          body.map((p) => Patient.fromJson(p as Map<String, dynamic>)).toList();

      expect(patients.first.firstName, equals('malik'));
    });

    test('non admin get patient with patientId responds with a 200 ok',
        () async {
      // Arrange

      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: user1Id));
      when(() => request.method).thenReturn(HttpMethod.get);

      // Act
      final response = await patient_route.onRequest(context, patientId);

      // Assert
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = json.decode(await response.body()) as Map<String, dynamic>;
      final patientLastName = body['lastName'] as String;
      expect(patientLastName, equals('monk'));
    });

    test('non admin update patient with patientId responds with a 200 ok',
        () async {
      // Arrange

      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: user1Id));
      when(() => request.method).thenReturn(HttpMethod.put);
      when(() => request.json()).thenAnswer(
        (_) async => const UpdatePatient(lastName: 'Money').toJson(),
      );

      // Act
      final response = await patient_route.onRequest(context, patientId);

      // Assert
      expect(response.statusCode, equals(HttpStatus.created));
      final body = json.decode(await response.body()) as Map<String, dynamic>;
      final patientLastName = body['lastName'] as String;
      expect(patientLastName, equals('Money'));
    });
  });
}
