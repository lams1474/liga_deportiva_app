import 'package:dio/dio.dart';
import '../models/disciplina.dart';

class DisciplinaService {
  final Dio _dio;

  DisciplinaService(this._dio);

  /// Obtener todas las disciplinas
  Future<List<Disciplina>> getDisciplinas() async {
    try {
      final response = await _dio.get('/disciplinas');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Disciplina.fromJson(json)).toList();
      }

      throw Exception('Error al obtener disciplinas: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión de nuevo.');
      }
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error de conexión';
      throw Exception(mensaje);
    }
  }

  /// Obtener disciplina por ID
  Future<Disciplina> getDisciplinaById(int id) async {
    try {
      final response = await _dio.get('/disciplinas/$id');

      if (response.statusCode == 200) {
        return Disciplina.fromJson(response.data);
      }

      throw Exception('Error al obtener la disciplina');
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }

  /// Crear disciplina
  Future<Disciplina> createDisciplina(Disciplina disciplina) async {
    try {
      final response = await _dio.post(
        '/disciplinas',
        data: disciplina.toJson(),
      );

      if (response.statusCode == 201) {
        return Disciplina.fromJson(response.data);
      }

      throw Exception('Error al crear la disciplina');
    } on DioException catch (e) {
      // Error 422 con campos específicos
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

  /// Actualizar disciplina
  Future<Disciplina> updateDisciplina(int id, Disciplina disciplina) async {
    try {
      final response = await _dio.put(
        '/disciplinas/$id',
        data: disciplina.toJson(),
      );

      if (response.statusCode == 200) {
        return Disciplina.fromJson(response.data);
      }

      throw Exception('Error al actualizar la disciplina');
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

  /// Eliminar disciplina
  Future<void> deleteDisciplina(int id) async {
    try {
      final response = await _dio.delete('/disciplinas/$id');

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar la disciplina');
      }
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }
}