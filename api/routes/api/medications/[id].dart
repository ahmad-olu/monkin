import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:surrealdb/surrealdb.dart';

import '../../../helper/get_user.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  final _ = await context.read<Future<SurrealDB>>();
  final __ = await getUser(context);

  // ignore: lines_longer_than_80_chars
  // to-do: get medication details (get )update medication (put) and deactivate medication (delete)

  if (context.request.method == HttpMethod.post) {
    return Response();
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
