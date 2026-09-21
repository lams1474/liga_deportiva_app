// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabla_posiciones.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TablaPosiciones _$TablaPosicionesFromJson(Map<String, dynamic> json) =>
    TablaPosiciones(
      idPosicion: (json['id_posicion'] as num?)?.toInt(),
      idTemporada: (json['id_temporada'] as num).toInt(),
      idClub: (json['id_club'] as num).toInt(),
      puntos: (json['puntos'] as num?)?.toInt() ?? 0,
      pj: (json['pj'] as num?)?.toInt() ?? 0,
      pg: (json['pg'] as num?)?.toInt() ?? 0,
      pe: (json['pe'] as num?)?.toInt() ?? 0,
      pp: (json['pp'] as num?)?.toInt() ?? 0,
      gf: (json['gf'] as num?)?.toInt() ?? 0,
      gc: (json['gc'] as num?)?.toInt() ?? 0,
      temporadaData: json['temporada'] as Map<String, dynamic>?,
      clubData: json['club'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TablaPosicionesToJson(TablaPosiciones instance) =>
    <String, dynamic>{
      'id_temporada': instance.idTemporada,
      'id_club': instance.idClub,
      'puntos': instance.puntos,
      'pj': instance.pj,
      'pg': instance.pg,
      'pe': instance.pe,
      'pp': instance.pp,
      'gf': instance.gf,
      'gc': instance.gc,
    };
