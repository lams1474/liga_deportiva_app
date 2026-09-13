// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usuario _$UsuarioFromJson(Map<String, dynamic> json) => Usuario(
  idUsuario: (json['id_usuario'] as num?)?.toInt(),
  nombre: json['nombre'] as String,
  correo: json['correo'] as String,
  rol: json['rol'] as String?,
);

Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
  'id_usuario': instance.idUsuario,
  'nombre': instance.nombre,
  'correo': instance.correo,
  'rol': instance.rol,
};
