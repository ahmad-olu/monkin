import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

Future<User> getUser(RequestContext context) async {
  final sdb = await context.read<Future<SurrealDB>>();
  final userId = await context.read<Future<UserIdFromJwt>>().then((e) => e.id);
  // ignore: inference_failure_on_function_invocation
  final user = (await sdb.select(userId))
      .map((u) => User.fromJson(u as Map<String, dynamic>))
      .toList()
      .first;
  return user;
}
