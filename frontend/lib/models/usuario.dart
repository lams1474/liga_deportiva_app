import 'package:json_annotation/json_annotation.dart';

part 'usuario.g.dart';

@JsonSerializable()
class Usuario {
  @JsonKey(name: 'id_usuario')
  final int? idUsuario;

  final String nombre;
  final String correo;
  final String? rol;

  Usuario({
    this.idUsuario,
    required this.nombre,
    required this.correo,
    this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => _$UsuarioFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);
}