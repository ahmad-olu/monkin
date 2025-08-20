import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/api/auth.dart';

@immutable
class RegisterResponseInterceptor implements Interceptor {
  const RegisterResponseInterceptor(this._onTokenReceived);

  final Future<void> Function(String token) _onTokenReceived;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final response = await chain.proceed(chain.request);
    final path = chain.request.url.toString();
    if (path.endsWith('/api/auth/register')) {
      //final token = response.headers['auth_token'];
      final body = response.body;
      if (body is Map<String, dynamic> && body['access_token'] != null) {
        final token = body['access_token'] as String;
        await _onTokenReceived(token);
      }
    }
    return response;
  }
}

class AuthResponseInterceptor implements Interceptor {
  AuthResponseInterceptor(this._token, this._setToken, this._authService);

  final Future<(String, String)> Function() _token;
  final Future<void> Function(String newToken) _setToken;
  final AuthService _authService;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = applyHeader(
      chain.request,
      'Authorization',
      await _token().then((t) => t.$1),
      override: false,
    );

    var response = await chain.proceed(request);

    if (response.statusCode == 401) {
      final bool isRefreshed = await _refreshToken();
      if (!isRefreshed) {
        throw Exception('Token expired');
      }

      final retryRequest = applyHeader(
        chain.request,
        'Authorization',
        await _token().then((t) => t.$1),
        override: true,
      );
      response = await chain.proceed(retryRequest);
    }
    return response;
  }

  Future<bool> _refreshToken() async {
    try {
      final result = await _authService.refreshToken({
        "refresh_token": await _token().then((t) => t.$2),
      });

      if (result.isSuccessful && result.body != null) {
        final body = result.body!;
        final newToken = body['access_token'] as String;
        await _setToken(newToken);
        return true;
      }
    } catch (e) {
      print("Failed to refresh token: $e");
    }
    return false;
  }
}
