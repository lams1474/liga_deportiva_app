// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arbitro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Arbitro _$ArbitroFromJson(Map<String, dynamic> json) => Arbitro(
  idArbitro: (json['id_arbitro'] as num?)?.toInt(),
  nombre: json['nombre'] as String,
  categoria: json['categoria'] as String,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$ArbitroToJson(Arbitro instance) => <String, dynamic>{
  'nombre': instance.nombre,
  'categoria': instance.categoria,
};
