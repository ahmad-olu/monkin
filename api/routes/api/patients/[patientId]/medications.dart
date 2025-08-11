import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../../../../consts/db_table.dart';
import '../../../../helper/get_user.dart';
import '../../../../helper/patient_exist.dart';

Future<Response> onRequest(
  RequestContext context,
  String patientId,
) async {
  // To-do: check permission
  final sdb = await context.read<Future<SurrealDB>>();
  final user = await getUser(context);

  if (context.request.method == HttpMethod.post) {
    // to-do: Verify doctor has prescribing rights
    final patients = await doesPatientWithIdExist(sdb, patientId);

    if (patients == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'msg': 'patient does not exist'},
      );
    }
    final req = PatientMedication.fromJson(
      await context.request.json() as Map<String, dynamic>,
    );

    final checkMedicationQuery = await sdb.query(
          r'''
          SELECT * FROM type::table($table) where id = $id;
          ''',
          {
            'table': medicationTable,
            'id': req.id,
          },
        ) as List? ??
        [];

    final checkMedication = SurrealQueryResult<Medication>.fromJson(
      checkMedicationQuery[0] as Map<String, dynamic>,
      (json) => Medication.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    if (checkMedication.isEmpty) {
      return Response(
        statusCode: HttpStatus.conflict,
        body: json.encode(
          {'msg': 'medication ${checkMedication.first.name} does not exist'},
        ),
      );
    }
    // to-do:Set prescription dates and duration
    final newMed = req.copyWith(createdAt: DateTime.now(), isActive: true);
    await sdb.create(patientMedicationTable, newMed.toJson());
    // to-do: Send medication instructions to patient
    // to-do: Schedule medication reminders if requested
    // to-do: Log prescription creation

    return Response.json(
      statusCode: HttpStatus.created,
      body: {'msg': 'patient medication created'},
    );
  } else if (context.request.method == HttpMethod.get) {
    // to-do: Verify user has permission to view patient medications
    // to-do: Query active and historical prescriptions
    // to-do: Include medication details and prescribing doctor info
    // to-do: Sort by prescription date or medication name
    // to-do: Flag expired or discontinued medications
    // to-do: Calculate adherence metrics if tracked

    //   final medicationQuery = await sdb.query(
    //         r'''
    // SELECT *,
    //   time::now() > expiredDate AS is_expired,
    //   discontinued = true AS is_discontinued
    // FROM type::table($table)
    // WHERE status INSIDE ['active', 'historical']
    // ORDER BY prescription_date DESC, medication_name ASC;
    // ''',
    //         {
    //           'table': patientMedicationTable,
    //         },
    //       ) as List? ??
    //       [];
    final medicationQuery = await sdb.query(
          r'''
  SELECT *
  FROM type::table($table);
  ''',
          {
            'table': patientMedicationTable,
          },
        ) as List? ??
        [];

    final medication = SurrealQueryResult<PatientMedication>.fromJson(
      medicationQuery[0] as Map<String, dynamic>,
      (json) =>
          PatientMedication.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    return Response.json(body: medication);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
