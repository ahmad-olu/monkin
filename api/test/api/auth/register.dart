import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:test/test.dart';

import '../../../routes/api/auth/register.dart' as register_route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /', () {
    test('responds with a 201 created', () async {
      // Arrange
      final db = SurrealDB('ws://localhost:8050/rpc')..connect();
      await db.wait();
      await db.use('test', 'test');
      await db.signin(user: 'root', pass: 'secret');

      final context = _MockRequestContext();
      //when(() => context.read<SurrealDB>()).thenReturn(db);
      when(() => context.read<Future<SurrealDB>>())
          .thenReturn(Future.value(db));

      // Act
      final response = await register_route.onRequest(context);

      // Assert
      expect(response.statusCode, equals(HttpStatus.created));
      //expect(response.body(), completion(equals('Hello World')));
    });
  });
}
