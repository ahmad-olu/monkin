// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surreal_query_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurrealQueryResult<T> _$SurrealQueryResultFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => SurrealQueryResult<T>(
  result: (json['result'] as List<dynamic>).map(fromJsonT).toList(),
  status: json['status'] as String?,
  time: json['time'] as String?,
);

Map<String, dynamic> _$SurrealQueryResultToJson<T>(
  SurrealQueryResult<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'status': instance.status,
  'time': instance.time,
  'result': instance.result.map(toJsonT).toList(),
};
