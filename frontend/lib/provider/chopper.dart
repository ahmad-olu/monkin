import 'dart:developer' show log;

import 'package:chopper/chopper.dart';
import 'package:frontend/api/auth.dart';
import 'package:frontend/api/auth_interceptor.dart';
import 'package:frontend/api/patient.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chopper.g.dart';

@riverpod
ChopperClient chopper(Ref ref) {
  final chopper = ChopperClient(
    baseUrl: Uri.parse("http://localhost:8080"),
    services: [AuthService.create(), PatientService.create()],
    interceptors: [
      RegisterResponseInterceptor((token) async {
        log("Captured access token: $token");

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);
      }),
      AuthResponseInterceptor(
        () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          final String access = prefs.getString('access_token') ?? '';
          final String refresh = prefs.getString('refresh_token') ?? '';

          return (access, refresh);
        },
        (newToken) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', newToken);
        },
        AuthService.create(),
      ),
    ],
  );
  return chopper;
}
