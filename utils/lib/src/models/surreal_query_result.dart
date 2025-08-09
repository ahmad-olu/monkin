// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'surreal_query_result.g.dart';

@immutable
@JsonSerializable(genericArgumentFactories: true)
class SurrealQueryResult<T> {
  const SurrealQueryResult({
    required this.result,
    this.status,
    this.time,
  });

  factory SurrealQueryResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$SurrealQueryResultFromJson(json, fromJsonT);

  final String? status;
  final String? time;
  final List<T> result;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$SurrealQueryResultToJson(this, toJsonT);
}
