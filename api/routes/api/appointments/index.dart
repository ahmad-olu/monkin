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
    final appointmentRec = CreateAppointment.fromJson(
      await context.request.json() as Map<String, dynamic>,
    );

    // ? check patient
    final checkPatientQuery = await sdb.query(
          r'SELECT * FROM type::table($table) WHERE email = $email;',
          {
            'table': patientTable,
            'email': appointmentRec.patientEmail,
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

    // ? check doctor
    final checkDoctorQuery = await sdb.query(
          r'SELECT * FROM type::table($table) WHERE email = $email;',
          {
            'table': patientTable,
            'email': appointmentRec.doctorEmail,
          },
        ) as List? ??
        [];
    final checkDoctor = SurrealQueryResult<User>.fromJson(
      checkDoctorQuery[0] as Map<String, dynamic>,
      (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    if (checkDoctor.isEmpty) {
      return Response(statusCode: HttpStatus.internalServerError);
    }

    // ? check availability
    final checkDoctorAvailabilityQuery = await sdb.query(
          r'''
    SELECT * FROM type::table($table)   
    WHERE doctorId = $doctorId
    AND (
      (appointmentDate <= $requestedEndTime AND date::add(appointmentDate, duration) >= $requestedStartTime)
    )''',
          {
            'table': appointmentTable,
            'doctorId': checkDoctor.first.id,
            'requestedStartTime': appointmentRec.appointmentDate,
            'requestedEndTime':
                appointmentRec.appointmentDate.add(appointmentRec.duration),
          },
        ) as List? ??
        [];
    final checkDoctorAvailability = SurrealQueryResult<User>.fromJson(
      checkDoctorAvailabilityQuery[0] as Map<String, dynamic>,
      (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;

    if (checkDoctorAvailability.isNotEmpty) {
      return Response(
        statusCode: HttpStatus.conflict,
        body: json.encode({
          'msg': 'pick another time. the doctor have another appointment them',
        }),
      );
    }

    final appointmentData = Appointment(
      patientId: checkPatient.first.id,
      doctorId: checkDoctor.first.id,
      appointmentDate: appointmentRec.appointmentDate,
      duration: appointmentRec.duration,
      type: appointmentRec.type,
      createdAt: DateTime.now(),
      notes: appointmentRec.notes,
      reason: appointmentRec.reason,
      reminderSent: appointmentRec.reminderSent,
      status: AppointmentStatus.scheduled,
    );
    await sdb.create(appointmentTable, appointmentData.toJson());
    // to-do: Send confirmation notifications to patient and doctor
    // to-do: Add to doctor's calendar
    return Response(body: json.encode({'msg': 'appointment scheduled'}));
  } else if (context.request.method == HttpMethod.get) {
    // to-do: Parse date range, status, and user filters
    // to-do: Apply role-based filtering (doctors see their appointments)
    // to-do: attach patient/doctor info to appointments
    // to-do: Sort by appointment date and time
    // to-do: Include appointment status and type information

    final appointmentsQuery =
        await sdb.query(r'SELECT * FROM type::table($table);', {
              'table': appointmentTable,
            }) as List? ??
            [];

    final appointments = SurrealQueryResult<Appointment>.fromJson(
      appointmentsQuery[0] as Map<String, dynamic>,
      (json) => Appointment.fromJson((json as Map<String, dynamic>?) ?? {}),
    ).result;
    return Response(body: json.encode(appointments));
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
