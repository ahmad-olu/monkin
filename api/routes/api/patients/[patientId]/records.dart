import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../../consts/db_table.dart';
import '../../../../helper/get_user.dart';

Future<Response> onRequest(
  RequestContext context,
  String patientId,
) async {
  // To-do: check permission
  final sdb = await context.read<Future<SurrealDB>>();
  final user = await getUser(context);

  if (context.request.method == HttpMethod.post) {
    // to-do:Validate doctor has permission to create records for patient
    final checkPatientQuery = await sdb.query(
          r'SELECT * FROM type::table($table) WHERE id = $id;',
          {
            'table': patientTable,
            'id': patientId,
          },
        ) as List? ??
        [];
    final checkPatient = SurrealQueryResult<Patient>.fromJson(
      checkPatientQuery[0] as Map<String, dynamic>,
      (json) => Patient.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    if (checkPatient.isEmpty) {
      return Response(statusCode: HttpStatus.internalServerError);
    }

    final newPatientRecordRec = MedicalRecord.fromJson(
      await context.request.json() as Map<String, dynamic>,
    )..copyWith(
        updatedAt: DateTime.now(),
        visitDate: DateTime.now(),
        patientId: patientId,
        doctorId: user.id,
      );

    await sdb.create(medicalRecordTable, newPatientRecordRec.toJson());
    // to-do: Send notification to relevant staff
    return Response(
      statusCode: HttpStatus.created,
    );
  } else if (context.request.method == HttpMethod.get) {
    // to-do: Verify user has permission to view patient records

    final medicalRecordQuery = await sdb.query(
          r'SELECT * FROM type::table($table) WHERE id = $id ORDER BY visitDate DESC;',
          {
            'table': medicalRecordTable,
          },
        ) as List? ??
        [];
    final medicalRecord = SurrealQueryResult<MedicalRecord>.fromJson(
      medicalRecordQuery[0] as Map<String, dynamic>,
      (json) => MedicalRecord.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    // to-do: Apply date range filters if provided
    // to-do: Include doctor information and attachment metadata
    // to-do: Implement pagination for large record sets

    return Response(body: json.encode(medicalRecord));
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
