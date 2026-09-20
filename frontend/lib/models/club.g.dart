// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Club _$ClubFromJson(Map<String, dynamic> json) => Club(
  idClub: (json['id_club'] as num?)?.toInt(),
  nombre: json['nombre'] as String,
  ciudad: json['ciudad'] as String,
  presidente: json['presidente'] as String?,
  fechaFundacion: DateTime.parse(json['fecha_fundacion'] as String),
  latitud: (json['latitud'] as num?)?.toDouble(),
  longitud: (json['longitud'] as num?)?.toDouble(),
  precisionUbicacion: json['precision_ubicacion'] as String?,
);

Map<String, dynamic> _$ClubToJson(Club instance) => <String, dynamic>{
  'nombre': instance.nombre,
  'ciudad': instance.ciudad,
  'presidente': instance.presidente,
  'fecha_fundacion': instance.fechaFundacion.toIso8601String(),
  'latitud': instance.latitud,
  'longitud': instance.longitud,
  'precision_ubicacion': instance.precisionUbicacion,
};
