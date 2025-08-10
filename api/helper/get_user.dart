import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

Future<User> getUser(RequestContext context) async {
  final sdb = await context.read<Future<SurrealDB>>();
  final userId = await context.read<Future<UserIdFromJwt>>().then((e) => e.id);
  final user = await sdb.select<User>(userId).then((e) => e.first);

  return user;
}
