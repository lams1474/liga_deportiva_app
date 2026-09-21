// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resultado.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resultado _$ResultadoFromJson(Map<String, dynamic> json) => Resultado(
  idResultado: (json['id_resultado'] as num?)?.toInt(),
  idPartido: (json['id_partido'] as num).toInt(),
  marcadorLocal: (json['marcador_local'] as num?)?.toInt(),
  marcadorVisitante: (json['marcador_visitante'] as num?)?.toInt(),
  registradoPor: (json['registrado_por'] as num).toInt(),
  partidoData: json['partido'] as Map<String, dynamic>?,
  registradorData: json['registrador'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$ResultadoToJson(Resultado instance) => <String, dynamic>{
  'id_partido': instance.idPartido,
  'marcador_local': instance.marcadorLocal,
  'marcador_visitante': instance.marcadorVisitante,
  'registrado_por': instance.registradoPor,
};
