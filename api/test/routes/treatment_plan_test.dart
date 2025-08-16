import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:test/test.dart';
import 'package:utils/utils.dart';

import '../../consts/db_table.dart';
import '../../routes/api/treatment_plans/[id]/status.dart'
    as treatment_plan_status_route;
import '../../routes/api/patients/[patientId]/treatment_plans.dart'
    as treatment_plan_route;
import '../../routes/api/auth/login.dart' as login_route;
import '../../routes/api/auth/register.dart' as register_route;
import '../../routes/api/patients/index.dart' as patients_route;

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
  late String treatmentId;

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
    await db.delete(treatmentPlanTable);

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

  group('Treatment Plan /api/appointments', () {
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
          email: 'opatient1@gmail.com');

      when(() => request.json()).thenAnswer((_) async => data.toJson());

      // Act
      final response = await patients_route.onRequest(context);

      // Assert
      final body = json.decode(await response.body()) as Map<String, dynamic>;
      patientId = body['id'] as String;
      expect(response.statusCode, equals(HttpStatus.created));
    });

    test('non admin create treatment plan responds with a 201 created',
        () async {
      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: user1Id));
      when(() => request.method).thenReturn(HttpMethod.post);
      final data = TreatmentPlan(
        title: 'treatment title',
        description: 'treatment description',
        startDate: DateTime.now().add(const Duration(days: 5)),
        goals: const [],
        medications: const [],
        instructions: const [],
      );

      when(() => request.json()).thenAnswer((_) async => data.toJson());

      final response = await treatment_plan_route.onRequest(context, patientId);

      expect(response.statusCode, equals(HttpStatus.created));
    });

    test('non admin get all patient treatment plan responds with a 201 created',
        () async {
      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: user1Id));
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await treatment_plan_route.onRequest(context, patientId);

      expect(response.statusCode, equals(HttpStatus.ok));
      final body = json.decode(await response.body()) as List<dynamic>;
      expect(body.isEmpty, equals(false));
      final treatment = body
          .map((p) => TreatmentPlan.fromJson(p as Map<String, dynamic>))
          .toList();
      treatmentId = treatment.first.id!;
      expect(treatment.first.title, equals('treatment title'));
    });

    test('non admin view  single treatment plan responds with a 201 created',
        () async {
      when(() => context.read<Future<UserIdFromJwt>>())
          .thenAnswer((_) async => UserIdFromJwt(id: user1Id));
      when(() => request.method).thenReturn(HttpMethod.put);

      when(() => request.json()).thenAnswer(
        (_) async => {
          'status': TreatmentStatus.suspended,
        },
      );

      final response =
          await treatment_plan_status_route.onRequest(context, treatmentId);

      expect(response.statusCode, equals(HttpStatus.created));
    });
  });
}
