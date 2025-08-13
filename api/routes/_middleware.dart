import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';

final db = SurrealDB('ws://localhost:8050/rpc')..connect();

Handler middleware(Handler handler) {
  return handler.use(
    provider<Future<SurrealDB>>((context) async {
      await db.wait();
      await db.use('test', 'test');
      await db.signin(user: 'root', pass: 'secret');

      return db;
    }),
  );
}
