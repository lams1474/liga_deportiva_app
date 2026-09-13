// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      mensaje: json['mensaje'] as String,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      usuario: Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'mensaje': instance.mensaje,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'usuario': instance.usuario,
    };
