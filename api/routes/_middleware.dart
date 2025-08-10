import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:utils/utils.dart' show UserIdFromJwt;

Handler middleware(Handler handler) {
  return handler.use(
    bearerAuthentication<UserIdFromJwt>(
      authenticator: (context, token) async {
        try {
          final payload = JWT.verify(token, SecretKey('secret passphrase'));
          // To-do: pass secret from .environment
          final payloadData = payload.payload as Map<String, dynamic>;
          final id = payloadData['id'] as String;

          return UserIdFromJwt(id: id);
        } catch (e) {
          // To-do: catch error and return unauthenticated if null is not enough
          return null;
        }
      },
    ),
  );
}
