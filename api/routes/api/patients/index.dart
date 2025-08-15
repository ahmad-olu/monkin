import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart' show patientTable;
import '../../../helper/get_user.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.put:
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _post(
  RequestContext context,
) async {
  try {
    // To-do: check permission
    final sdb = await context.read<Future<SurrealDB>>();
    final user = await getUser(context);

    if (user.role != UserRole.admin &&
        user.role != UserRole.superAdmin &&
        user.role != UserRole.doctor &&
        user.role != UserRole.nurse &&
        user.role != UserRole.receptionist) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {
          'msg': 'you dont have the right privilege to perform this task',
        },
      );
    }

    // TO-do: Validate all required patient information
    final newPatientRec = Patient.fromJson(
      await context.request.json() as Map<String, dynamic>,
    );

    final checkPatientQuery = await sdb.query(
          r'SELECT * FROM type::table($table) WHERE email = $email OR phone = $phone;',
          {
            'table': patientTable,
            'email': newPatientRec.email,
            'phone': newPatientRec.phone,
          },
        ) as List? ??
        [];
    final checkPatient = SurrealQueryResult<Patient>.fromJson(
      checkPatientQuery[0] as Map<String, dynamic>,
      (json) => Patient.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    if (checkPatient.isNotEmpty) {
      return Response(
        statusCode: HttpStatus.conflict,
        body: json.encode({
          'msg': 'patient already exists',
        }),
      );
    }

    // ? insert patient
    newPatientRec.copyWith(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy: user.id,
      isActive: true,
    );

    final patient = await sdb.create(patientTable, newPatientRec.toJson())
            as Map<String, dynamic>? ??
        {};

    // To-do: Log patient creation event

    return Response.json(statusCode: HttpStatus.created, body: patient);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _get(
  RequestContext context,
) async {
  try {
    // To-do: check permission
    final sdb = await context.read<Future<SurrealDB>>();
    final user = await getUser(context);
    if (user.role != UserRole.admin &&
        user.role != UserRole.superAdmin &&
        user.role != UserRole.doctor &&
        user.role != UserRole.nurse &&
        user.role != UserRole.receptionist) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {
          'msg': 'you dont have the right privilege to perform this task',
        },
      );
    }
    // to-do: Parse query parameters for pagination, search, and filters
    // to-do: Build dynamic SQL query based on filters
    // to-do: Apply search across name, phone, email, and patient number
    // to-do: Implement pagination with limit and offset
    // to-do: Sort results by specified criteria

    final patientsRes = await sdb.query(r'SELECT * FROM type::table($table);', {
          'table': patientTable,
        }) as List? ??
        [];

    final patients = SurrealQueryResult<Patient>.fromJson(
      patientsRes[0] as Map<String, dynamic>,
      (json) => Patient.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    return Response.json(body: patients);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
