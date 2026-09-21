import 'package:dio/dio.dart';
import '../models/resultado.dart';

class ResultadoService {
  final Dio _dio;

  ResultadoService(this._dio);

  Future<List<Resultado>> getResultados() async {
    try {
      final response = await _dio.get('/resultados');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Resultado.fromJson(json)).toList();
      }
      throw Exception('Error al obtener resultados: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión de nuevo.');
      }
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error de conexión';
      throw Exception(mensaje);
    }
  }

  Future<Resultado> getResultadoById(int id) async {
    try {
      final response = await _dio.get('/resultados/$id');
      if (response.statusCode == 200) {
        return Resultado.fromJson(response.data);
      }
      throw Exception('Error al obtener el resultado');
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }

  Future<Resultado> createResultado(Resultado resultado) async {
    try {
      final response = await _dio.post('/resultados', data: resultado.toJson());
      if (response.statusCode == 201) {
        return Resultado.fromJson(response.data);
      }
      throw Exception('Error al crear el resultado');
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

  Future<Resultado> updateResultado(int id, Resultado resultado) async {
    try {
      final response = await _dio.put('/resultados/$id', data: resultado.toJson());
      if (response.statusCode == 200) {
        return Resultado.fromJson(response.data);
      }
      throw Exception('Error al actualizar el resultado');
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

  Future<void> deleteResultado(int id) async {
    try {
      final response = await _dio.delete('/resultados/$id');
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el resultado');
      }
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }
}