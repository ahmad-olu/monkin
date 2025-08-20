import "dart:async";
import 'package:chopper/chopper.dart';
import 'package:utils/utils.dart';

part "patient.chopper.dart";

@ChopperApi(baseUrl: "/api/patient")
abstract class PatientService extends ChopperService {
  static PatientService create([ChopperClient? client]) =>
      _$PatientService(client);

  @POST(path: '/patients')
  Future<Response<Patient?>> createPatient(@Body() Map<String, dynamic> fields);

  @GET(path: '/patients')
  Future<Response<List<Patient>>> getPatients();

  @GET(path: '/patients/{id}/')
  Future<Response<Patient?>> getPatient(@Path() String id);

  @PUT(path: '/patients/{id}/')
  Future<Response<Patient?>> updatePatient(
    @Path() String id,
    @Body() Map<String, dynamic> fields,
  );
}
