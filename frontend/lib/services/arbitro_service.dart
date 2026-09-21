import 'package:dio/dio.dart';
import '../models/arbitro.dart';

class ArbitroService {
  final Dio _dio;

  ArbitroService(this._dio);

  Future<List<Arbitro>> getArbitros() async {
    try {
      final response = await _dio.get('/arbitros');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Arbitro.fromJson(json)).toList();
      }
      throw Exception('Error al obtener árbitros: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión de nuevo.');
      }
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error de conexión';
      throw Exception(mensaje);
    }
  }

  Future<Arbitro> getArbitroById(int id) async {
    try {
      final response = await _dio.get('/arbitros/$id');
      if (response.statusCode == 200) {
        return Arbitro.fromJson(response.data);
      }
      throw Exception('Error al obtener el árbitro');
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }

  Future<Arbitro> createArbitro(Arbitro arbitro) async {
    try {
      final response = await _dio.post('/arbitros', data: arbitro.toJson());
      if (response.statusCode == 201) {
        return Arbitro.fromJson(response.data);
      }
      throw Exception('Error al crear el árbitro');
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

  Future<Arbitro> updateArbitro(int id, Arbitro arbitro) async {
    try {
      final response = await _dio.put('/arbitros/$id', data: arbitro.toJson());
      if (response.statusCode == 200) {
        return Arbitro.fromJson(response.data);
      }
      throw Exception('Error al actualizar el árbitro');
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

  Future<void> deleteArbitro(int id) async {
    try {
      final response = await _dio.delete('/arbitros/$id');
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el árbitro');
      }
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }
}