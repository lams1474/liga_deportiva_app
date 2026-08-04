import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:3000/api",
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> login(String correo, String contrasena) async {
    try {
      final response = await dio.post(
        "/auth/login",
        data: {
          "correo": correo,
          "contrasena": contrasena,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data["token"];

        await storage.write(
          key: "token",
          value: token,
        );

        return true;
      }

      return false;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data["mensaje"]);
      }

      throw Exception("No fue posible conectar con el servidor.");
    }
  }

  Future<String?> obtenerToken() async {
    return await storage.read(key: "token");
  }

  Future<void> logout() async {
    await storage.delete(key: "token");
  }
}