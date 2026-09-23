// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedResponse<T> _$PaginatedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _PaginatedResponse<T>(
  currentPage: (json['current_page'] as num).toInt(),
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
  lastPage: (json['last_page'] as num).toInt(),
  perPage: json['per_page'],
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$PaginatedResponseToJson<T>(
  _PaginatedResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'data': instance.data.map(toJsonT).toList(),
  'last_page': instance.lastPage,
  'per_page': instance.perPage,
  'total': instance.total,
};
