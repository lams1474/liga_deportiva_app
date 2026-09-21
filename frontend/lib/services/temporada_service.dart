import 'package:dio/dio.dart';
import '../models/temporada.dart';

class TemporadaService {
  final Dio _dio;

  TemporadaService(this._dio);

  Future<List<Temporada>> getTemporadas() async {
    try {
      final response = await _dio.get('/temporadas');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Temporada.fromJson(json)).toList();
      }
      throw Exception('Error al obtener temporadas: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión de nuevo.');
      }
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error de conexión';
      throw Exception(mensaje);
    }
  }

  Future<Temporada> getTemporadaById(int id) async {
    try {
      final response = await _dio.get('/temporadas/$id');
      if (response.statusCode == 200) {
        return Temporada.fromJson(response.data);
      }
      throw Exception('Error al obtener la temporada');
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }

  Future<Temporada> createTemporada(Temporada temporada) async {
    try {
      final response = await _dio.post('/temporadas', data: temporada.toJson());
      if (response.statusCode == 201) {
        return Temporada.fromJson(response.data);
      }
      throw Exception('Error al crear la temporada');
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

  Future<Temporada> updateTemporada(int id, Temporada temporada) async {
    try {
      final response = await _dio.put('/temporadas/$id', data: temporada.toJson());
      if (response.statusCode == 200) {
        return Temporada.fromJson(response.data);
      }
      throw Exception('Error al actualizar la temporada');
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

  Future<void> deleteTemporada(int id) async {
    try {
      final response = await _dio.delete('/temporadas/$id');
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar la temporada');
      }
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }
}