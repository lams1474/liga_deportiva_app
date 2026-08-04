import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/club.dart';

class ClubService {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:3000/api",
    ),
  );

  final FlutterSecureStorage storage =
      const FlutterSecureStorage();

  // ============================
  // Obtener clubes
  // ============================

  Future<List<Club>> obtenerClubes() async {

    final token = await storage.read(key: "token");

    final response = await dio.get(

      "/clubes",

      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),

    );

    final List datos = response.data;

    return datos
        .map((e) => Club.fromJson(e))
        .toList();

  }

  // ============================
  // Crear club
  // ============================

  Future<void> crearClub({

    required String nombre,
    required String ciudad,
    required String fechaFundacion,

  }) async {

    final token = await storage.read(key: "token");

    await dio.post(

      "/clubes",

      data: {
        "nombre": nombre,
        "ciudad": ciudad,
        "fecha_fundacion": fechaFundacion,
      },

      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),

    );

  }

  // ============================
  // Actualizar club
  // ============================

  Future<void> actualizarClub({

    required int idClub,
    required String nombre,
    required String ciudad,
    required String fechaFundacion,

  }) async {

    final token = await storage.read(key: "token");

    await dio.put(

      "/clubes/$idClub",

      data: {
        "nombre": nombre,
        "ciudad": ciudad,
        "fecha_fundacion": fechaFundacion,
      },

      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),

    );

  }

  // ============================
  // Eliminar club
  // ============================

  Future<void> eliminarClub(int idClub) async {

    final token = await storage.read(key: "token");

    await dio.delete(

      "/clubes/$idClub",

      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),

    );

  }

}