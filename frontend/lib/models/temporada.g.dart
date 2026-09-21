// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporada.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temporada _$TemporadaFromJson(Map<String, dynamic> json) => Temporada(
  idTemporada: (json['id_temporada'] as num?)?.toInt(),
  anio: (json['año'] as num).toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$TemporadaToJson(Temporada instance) => <String, dynamic>{
  'año': instance.anio,
};
