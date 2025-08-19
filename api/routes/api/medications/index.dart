import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';
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

Future<Response> _post(RequestContext context) async {
  try {
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
    final req = Medication.fromJson(
        await context.request.json() as Map<String, dynamic>);
    final checkMedicationQuery = await sdb.query(
          r'''
          SELECT * FROM type::table($table) where name = $name;
          ''',
          {
            'table': medicationTable,
            'name': req.name,
          },
        ) as List? ??
        [];

    final checkMedication = SurrealQueryResult<Medication>.fromJson(
      checkMedicationQuery[0] as Map<String, dynamic>,
      (json) => Medication.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    if (checkMedication.isNotEmpty) {
      return Response(
        statusCode: HttpStatus.conflict,
        body: json.encode(
            {'msg': 'medication ${checkMedication.first.name} already exist'}),
      );
    }
    final newMed = req.copyWith(
      createdAt: DateTime.now(),
      isActive: true,
    );

    await sdb.create(medicalRecordTable, newMed.toJson());
    // to-do: Index for search functionality
    // to-do: Log medication creation

    return Response(statusCode: HttpStatus.created);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}

Future<Response> _get(RequestContext context) async {
  try {
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
    // to-do: Parse search query for medication names
    // to-do: Apply filters for dosage form and active status
    // to-do: Implement fuzzy search for medication names
    // to-do: Sort results by relevance or alphabetically
    // to-do: Include usage statistics if requested
    // to-do: Return paginated results

    final medicationQuery = await sdb.query(
          r'''
          SELECT * FROM type::table($table);
          ''',
          {
            'table': medicationTable,
          },
        ) as List? ??
        [];

    final medication = SurrealQueryResult<Medication>.fromJson(
      medicationQuery[0] as Map<String, dynamic>,
      (json) => Medication.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    return Response.json(body: medication);
  } catch (e) {
    return Response(statusCode: HttpStatus.internalServerError);
  }
}
