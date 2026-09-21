import 'package:dio/dio.dart';
import '../models/tabla_posiciones.dart';

class TablaPosicionesService {
  final Dio _dio;

  TablaPosicionesService(this._dio);

  Future<List<TablaPosiciones>> getTablaPosiciones() async {
    try {
      final response = await _dio.get('/tabla-posiciones');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TablaPosiciones.fromJson(json)).toList();
      }
      throw Exception('Error al obtener la tabla: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión de nuevo.');
      }
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error de conexión';
      throw Exception(mensaje);
    }
  }

  Future<TablaPosiciones> getPosicionById(int id) async {
    try {
      final response = await _dio.get('/tabla-posiciones/$id');
      if (response.statusCode == 200) {
        return TablaPosiciones.fromJson(response.data);
      }
      throw Exception('Error al obtener la posición');
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }

  Future<TablaPosiciones> createPosicion(TablaPosiciones posicion) async {
    try {
      final response = await _dio.post('/tabla-posiciones', data: posicion.toJson());
      if (response.statusCode == 201) {
        return TablaPosiciones.fromJson(response.data);
      }
      throw Exception('Error al crear el registro');
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

  Future<TablaPosiciones> updatePosicion(int id, TablaPosiciones posicion) async {
    try {
      final response = await _dio.put('/tabla-posiciones/$id', data: posicion.toJson());
      if (response.statusCode == 200) {
        return TablaPosiciones.fromJson(response.data);
      }
      throw Exception('Error al actualizar el registro');
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

  Future<void> deletePosicion(int id) async {
    try {
      final response = await _dio.delete('/tabla-posiciones/$id');
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el registro');
      }
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }
}