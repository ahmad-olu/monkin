import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../consts/db_table.dart';
import '../../../helper/get_user.dart';

Future<Response> onRequest(RequestContext context) async {
  final sdb = await context.read<Future<SurrealDB>>();
  final user = await getUser(context);

  if (context.request.method == HttpMethod.post) {
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
  } else if (context.request.method == HttpMethod.get) {
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
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
