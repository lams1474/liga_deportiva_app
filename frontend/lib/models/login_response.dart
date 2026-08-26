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
    print('📦 Parseando LoginResponse: $json'); // Log para depurar
    
    return LoginResponse(
      mensaje: json["mensaje"] ?? '',
      token: json["token"] ?? '',
      usuario: Usuario.fromJson(json["usuario"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mensaje': mensaje,
      'token': token,
      'usuario': usuario.toJson(),
    };
  }
}