import 'package:dio/dio.dart';
import '../models/jugador.dart';

class JugadorService {
  final Dio _dio;

  JugadorService(this._dio);

  Future<List<Jugador>> getJugadores() async {
    try {
      final response = await _dio.get('/jugadores');
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
      final response = await _dio.get('/jugadores/$id');
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
      // 🔥 Usar toJson() que ya excluye idJugador y club
      final data = jugador.toJson();
      print('📦 POST /jugadores');
      print('📦 Data: $data');

      final response = await _dio.post('/jugadores', data: data);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Jugador.fromJson(response.data);
      } else {
        final errorData = response.data;
        final mensaje = errorData?['mensaje'] ?? 'Error al crear jugador: ${response.statusCode}';
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

  Future<Jugador> updateJugador(int id, Jugador jugador) async {
    try {
      final data = jugador.toJson();
      print('📦 PUT /jugadores/$id');
      print('📦 Data: $data');

      final response = await _dio.put('/jugadores/$id', data: data);

      if (response.statusCode == 200) {
        return Jugador.fromJson(response.data);
      } else {
        throw Exception('Error al actualizar jugador: ${response.statusCode}');
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

  Future<void> deleteJugador(int id) async {
    try {
      final response = await _dio.delete('/jugadores/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar jugador: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}