import 'package:dio/dio.dart';
import '../models/club.dart';

class ClubService {
  final Dio _dio;

  ClubService(this._dio);

  Future<List<Club>> getClubs() async {
    try {
      final response = await _dio.get('/clubes');
      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => Club.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar clubes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Club> getClubById(int id) async {
    try {
      final response = await _dio.get('/clubes/$id');
      if (response.statusCode == 200) {
        return Club.fromJson(response.data);
      } else {
        throw Exception('Error al cargar club: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Club> createClub(Club club) async {
    try {
      final response = await _dio.post('/clubes', data: club.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Club.fromJson(response.data);
      } else {
        final errorData = response.data;
        final mensaje = errorData?['mensaje'] ?? 'Error al crear club: ${response.statusCode}';
        throw Exception(mensaje);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData['errores'] is List) {
          final errores = errorData['errores'] as List;
          if (errores.isNotEmpty) {
            throw Exception(errores.first['mensaje'] ?? 'Datos inválidos');
          }
        }
        throw Exception(errorData?['mensaje'] ?? 'Los datos enviados no son válidos');
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Club> updateClub(int id, Club club) async {
    try {
      final response = await _dio.put('/clubes/$id', data: club.toJson());
      if (response.statusCode == 200) {
        return Club.fromJson(response.data);
      } else {
        throw Exception('Error al actualizar club: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData['errores'] is List) {
          final errores = errorData['errores'] as List;
          if (errores.isNotEmpty) {
            throw Exception(errores.first['mensaje'] ?? 'Datos inválidos');
          }
        }
        throw Exception(errorData?['mensaje'] ?? 'Los datos enviados no son válidos');
      }
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> deleteClub(int id) async {
    try {
      final response = await _dio.delete('/clubes/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar club: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}