import 'package:dio/dio.dart';
import '../models/categoria.dart';

class CategoriaService {
  final Dio _dio;

  CategoriaService(this._dio);

  Future<List<Categoria>> getCategorias() async {
    try {
      final response = await _dio.get('/categorias');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Categoria.fromJson(json)).toList();
      }

      throw Exception('Error al obtener categorías: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sesión expirada. Inicia sesión de nuevo.');
      }
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error de conexión';
      throw Exception(mensaje);
    }
  }

  Future<Categoria> getCategoriaById(int id) async {
    try {
      final response = await _dio.get('/categorias/$id');

      if (response.statusCode == 200) {
        return Categoria.fromJson(response.data);
      }

      throw Exception('Error al obtener la categoría');
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }

  Future<Categoria> createCategoria(Categoria categoria) async {
    try {
      final response = await _dio.post(
        '/categorias',
        data: categoria.toJson(),
      );

      if (response.statusCode == 201) {
        return Categoria.fromJson(response.data);
      }

      throw Exception('Error al crear la categoría');
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

  Future<Categoria> updateCategoria(int id, Categoria categoria) async {
    try {
      final response = await _dio.put(
        '/categorias/$id',
        data: categoria.toJson(),
      );

      if (response.statusCode == 200) {
        return Categoria.fromJson(response.data);
      }

      throw Exception('Error al actualizar la categoría');
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

  Future<void> deleteCategoria(int id) async {
    try {
      final response = await _dio.delete('/categorias/$id');

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar la categoría');
      }
    } on DioException catch (e) {
      final mensaje = e.response?.data?['mensaje'] ?? e.message ?? 'Error';
      throw Exception(mensaje);
    }
  }
}