import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';

import '../../../../helper/get_user.dart';

Future<Response> onRequest(
  RequestContext context,
  String patientId,
) async {
  // To-do: check permission
  final _ = await context.read<Future<SurrealDB>>();
  final __ = await getUser(context);
  // to-do: patient appointment (get)

  if (context.request.method == HttpMethod.post) {
    return Response();
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
