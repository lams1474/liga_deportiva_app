import 'usuario.dart';

class LoginResponse {

  final String mensaje;
  final String token;
  final Usuario usuario;

  LoginResponse({
    required this.mensaje,
    required this.token,
    required this.usuario,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {

    return LoginResponse(
      mensaje: json["mensaje"],
      token: json["token"],
      usuario: Usuario.fromJson(json["usuario"]),
    );

  }

}