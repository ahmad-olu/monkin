import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';

import '../../../helper/get_user.dart';

Future<Response> onRequest(RequestContext context) async {
  final sdb = await context.read<Future<SurrealDB>>();
  final user = await getUser(context);

  if (context.request.method == HttpMethod.post) {
    // to-do: Validate user has bulk messaging permissions
    // to-do: Generate personalized messages for each patient
    // to-do: Queue messages with appropriate scheduling
    // to-do:Provide status updates to requesting user
    // to-do:Generate delivery report

    return Response(statusCode: HttpStatus.created);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
