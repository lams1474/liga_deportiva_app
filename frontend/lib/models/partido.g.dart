// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partido.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Partido _$PartidoFromJson(Map<String, dynamic> json) => Partido(
  idPartido: (json['id_partido'] as num?)?.toInt(),
  fecha: DateTime.parse(json['fecha'] as String),
  hora: json['hora'] as String,
  lugar: json['lugar'] as String,
  idCategoria: (json['id_categoria'] as num).toInt(),
  idClubLocal: (json['id_club_local'] as num).toInt(),
  idClubVisitante: (json['id_club_visitante'] as num).toInt(),
  idTemporada: (json['id_temporada'] as num).toInt(),
  idArbitro: (json['id_arbitro'] as num).toInt(),
  programadoPor: (json['programado_por'] as num).toInt(),
  categoriaData: json['categoria'] as Map<String, dynamic>?,
  clubLocalData: json['club_local'] as Map<String, dynamic>?,
  clubVisitanteData: json['club_visitante'] as Map<String, dynamic>?,
  temporadaData: json['temporada'] as Map<String, dynamic>?,
  arbitroData: json['arbitro'] as Map<String, dynamic>?,
  programadorData: json['programador'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$PartidoToJson(Partido instance) => <String, dynamic>{
  'fecha': instance.fecha.toIso8601String(),
  'hora': instance.hora,
  'lugar': instance.lugar,
  'id_categoria': instance.idCategoria,
  'id_club_local': instance.idClubLocal,
  'id_club_visitante': instance.idClubVisitante,
  'id_temporada': instance.idTemporada,
  'id_arbitro': instance.idArbitro,
  'programado_por': instance.programadoPor,
};
