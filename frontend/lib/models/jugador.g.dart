// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jugador.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jugador _$JugadorFromJson(Map<String, dynamic> json) => Jugador(
  idJugador: (json['id_jugador'] as num?)?.toInt(),
  cedula: json['cedula'] as String,
  nombre: json['nombre'] as String,
  ciudad: json['ciudad'] as String,
  fechaNacimiento: DateTime.parse(json['fecha_nacimiento'] as String),
  idClub: (json['id_club'] as num).toInt(),
  fotoPath: json['foto_path'] as String?,
  clubData: json['club'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$JugadorToJson(Jugador instance) => <String, dynamic>{
  'cedula': instance.cedula,
  'nombre': instance.nombre,
  'ciudad': instance.ciudad,
  'fecha_nacimiento': instance.fechaNacimiento.toIso8601String(),
  'id_club': instance.idClub,
};
