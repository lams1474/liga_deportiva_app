import 'package:json_annotation/json_annotation.dart';
import 'usuario.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String mensaje;
  final String token;
  final String? refreshToken;
  final Usuario usuario;

  LoginResponse({
    required this.mensaje,
    required this.token,
    this.refreshToken,
    required this.usuario,
  });

  // 🔥 Generado automáticamente
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}