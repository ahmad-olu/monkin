import "dart:async";
import 'package:chopper/chopper.dart';
import 'package:utils/utils.dart';

part "auth.chopper.dart";

@ChopperApi(baseUrl: "/api/auth")
abstract class AuthService extends ChopperService {
  static AuthService create([ChopperClient? client]) => _$AuthService(client);

  @POST(path: '/register')
  @formUrlEncoded
  Future<Response> register(@Body() Map<String, String> fields);

  @POST(path: '/refresh')
  Future<Response> refreshToken(@Body() Map<String, String> fields);

  @POST(path: '/login')
  @formUrlEncoded
  Future<Response> login(@Body() Map<String, String> fields);

  @PUT(path: '/profile')
  @formUrlEncoded
  Future<Response> updateProfile(@Body() Map<String, String> fields);

  @GET(path: '/profile')
  @formUrlEncoded
  Future<Response<User?>> getProfile();

  @PUT(path: '/change_password')
  @formUrlEncoded
  Future<Response> updatePassword(@Body() Map<String, String> fields);
}
