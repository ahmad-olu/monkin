// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PatientService extends PatientService {
  _$PatientService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PatientService;

  @override
  Future<Response<Patient>> createPatient(Map<String, dynamic> fields) {
    final Uri $url = Uri.parse('/api/patient/patients');
    final $body = fields;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Patient, Patient>($request);
  }

  @override
  Future<Response<List<Patient>>> getPatients() {
    final Uri $url = Uri.parse('/api/patient/patients');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<List<Patient>, Patient>($request);
  }

  @override
  Future<Response<Patient>> getPatient(String id) {
    final Uri $url = Uri.parse('/api/patient/patients/${id}/');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Patient, Patient>($request);
  }

  @override
  Future<Response<Patient>> updatePatient(
    String id,
    Map<String, dynamic> fields,
  ) {
    final Uri $url = Uri.parse('/api/patient/patients/${id}/');
    final $body = fields;
    final Request $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<Patient, Patient>($request);
  }
}
