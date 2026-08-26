import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/jugador.dart';

class JugadorService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  JugadorService(this._dio);

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Jugador>> getJugadores() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.get(
        '/jugadores',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => Jugador.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar jugadores: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Jugador> getJugadorById(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.get(
        '/jugadores/$id',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return Jugador.fromJson(response.data);
      } else {
        throw Exception('Error al cargar jugador: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Jugador> createJugador(Jugador jugador) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.post(
        '/jugadores',
        data: jugador.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Jugador.fromJson(response.data);
      } else {
        throw Exception('Error al crear jugador: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Jugador> updateJugador(int id, Jugador jugador) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.put(
        '/jugadores/$id',
        data: jugador.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return Jugador.fromJson(response.data);
      } else {
        throw Exception('Error al actualizar jugador: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> deleteJugador(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.delete(
        '/jugadores/$id',
        options: Options(headers: headers),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar jugador: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}