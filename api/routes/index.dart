import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';
import 'package:utils/utils.dart';

Future<Response> onRequest(RequestContext context) async {
  final db = SurrealDB('ws://localhost:8050/rpc')..connect();
  await db.wait();
  await db.use('test', 'test');
  await db.signin(user: 'root', pass: 'secret');

  //create data 1.

  final one = await db.query('''
          CREATE user SET
            email = "user@example.com",
            password = "hashed_password_here",
            name = "John Doe";
    ''') as List? ?? [];
  final oneRes = SurrealQueryResult<User>.fromJson(
    one[0] as Map<String, dynamic>? ?? {},
    (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
  );
  print('one :${oneRes.result.first.email}');
  print('====> \n \n \n');

  final two = await db.create('user', {
        'email': 'user1@gmail.com',
        'password': 'hashed_password_here',
        'name': 'jamie done',
      }) as Map<String, dynamic>? ??
      {};

  print('two :${User.fromJson(two).name}');
  print('====> \n \n \n');

  final three = await db
          .query(r'SELECT * FROM type::table($table) WHERE email = $email;', {
        'table': 'user',
        'email': 'user1@gmail.com',
      }) as List? ??
      [];

  final threeRes = SurrealQueryResult<User>.fromJson(
    three[0] as Map<String, dynamic>,
    (json) => User.fromJson((json as Map<String, dynamic>?) ?? {}),
  );
  print('three :${threeRes.result}');
  print('====> \n');

  return Response(body: 'Welcome to Dart Frog!');
}

class User {
  const User({required this.email, required this.password, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );
  }
  final String email;
  final String password;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
    };
  }
}
