import 'package:dio/dio.dart';
import '../models/partido.dart';

class PartidoService {
  final Dio _dio;

  PartidoService(this._dio);

  Future<List<Partido>> getPartidos() async {
    try {
      final response = await _dio.get('/partidos');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Partido.fromJson(json)).toList();
      }
      throw Exception('Error al obtener partidos: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión de nuevo.');
      }
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error de conexión';
      throw Exception(mensaje);
    }
  }

  Future<Partido> getPartidoById(int id) async {
    try {
      final response = await _dio.get('/partidos/$id');
      if (response.statusCode == 200) {
        return Partido.fromJson(response.data);
      }
      throw Exception('Error al obtener el partido');
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }

  Future<Partido> createPartido(Partido partido) async {
    try {
      final response = await _dio.post('/partidos', data: partido.toJson());
      if (response.statusCode == 201) {
        return Partido.fromJson(response.data);
      }
      throw Exception('Error al crear el partido');
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errores = e.response?.data?['errores'];
        if (errores != null && errores is List && errores.isNotEmpty) {
          throw Exception(errores.first['mensaje']);
        }
        throw Exception(e.response?.data?['mensaje'] ?? 'Datos inválidos');
      }
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }

  Future<Partido> updatePartido(int id, Partido partido) async {
    try {
      final response = await _dio.put('/partidos/$id', data: partido.toJson());
      if (response.statusCode == 200) {
        return Partido.fromJson(response.data);
      }
      throw Exception('Error al actualizar el partido');
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errores = e.response?.data?['errores'];
        if (errores != null && errores is List && errores.isNotEmpty) {
          throw Exception(errores.first['mensaje']);
        }
        throw Exception(e.response?.data?['mensaje'] ?? 'Datos inválidos');
      }
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }

  Future<void> deletePartido(int id) async {
    try {
      final response = await _dio.delete('/partidos/$id');
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el partido');
      }
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }
}