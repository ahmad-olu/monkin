import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart' show patientTable;

Future<Response> onRequest(RequestContext context) async {
  // To-do: check permission
  final sdb = await context.read<Future<SurrealDB>>();
  final userId = await context.read<Future<UserIdFromJwt>>().then((e) => e.id);
  // TO-do: Validate all required patient information

  if (context.request.method == HttpMethod.post) {
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
      isActive: true,
    );

    final patient = await sdb.create(patientTable, newPatientRec.toJson())
            as Map<String, dynamic>? ??
        {};

    // To-do: Log patient creation event

    return Response(statusCode: HttpStatus.created, body: json.encode(patient));
  } else if (context.request.method == HttpMethod.get) {
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
    return Response(body: json.encode(patients));
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
