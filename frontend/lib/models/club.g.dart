// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Club _$ClubFromJson(Map<String, dynamic> json) => Club(
  idClub: (json['id_club'] as num?)?.toInt(),
  nombre: json['nombre'] as String,
  ciudad: json['ciudad'] as String,
  fechaFundacion: DateTime.parse(json['fecha_fundacion'] as String),
);

Map<String, dynamic> _$ClubToJson(Club instance) => <String, dynamic>{
  'nombre': instance.nombre,
  'ciudad': instance.ciudad,
  'fecha_fundacion': instance.fechaFundacion.toIso8601String(),
};
