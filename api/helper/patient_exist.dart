import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

import '../consts/db_table.dart';

Future<Patient?> doesPatientWithIdExist(SurrealDB sdb, String patientId) async {
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

  return checkPatient.isNotEmpty ? checkPatient.first : null;
}

Future<User?> doesUserWithIdExist(SurrealDB sdb, String patientId) async {
  final checkPatientQuery = await sdb.query(
        r'SELECT * FROM type::table($table) WHERE id = $id;',
        {
          'table': userTable,
          'id': patientId,
        },
      ) as List? ??
      [];
  final checkPatient = SurrealQueryResult<User>.fromJson(
    checkPatientQuery[0] as Map<String, dynamic>,
    (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
  ).result;

  return checkPatient.isNotEmpty ? checkPatient.first : null;
}
