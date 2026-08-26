import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/club.dart';

class ClubService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ClubService(this._dio);

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'token');
    print('🔑 Token recuperado: ${token != null ? '✅ Sí' : '❌ No'}');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<Club>> getClubs() async {
    try {
      final headers = await _getAuthHeaders();
      print('📦 Headers para GET: $headers');
      
      final response = await _dio.get(
        '/clubes',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => Club.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar clubes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Error GET: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Club> getClubById(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.get(
        '/clubes/$id',
        options: Options(headers: headers),
      );

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
      final headers = await _getAuthHeaders();
      final data = club.toJson();
      
      print('📦 Enviando club: $data');
      print('📦 Headers: $headers');

      // 🔥 CORREGIDO: Asegurar que los headers van en el lugar correcto 🔥
      final response = await _dio.post(
        '/clubes',
        data: data,
        options: Options(
          headers: headers,
          validateStatus: (status) => status! < 500,
        ),
      );

      print('📥 Status: ${response.statusCode}');
      print('📦 Response: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Club.fromJson(response.data);
      } else {
        final errorData = response.data;
        final mensaje = errorData?['mensaje'] ?? 'Error al crear club: ${response.statusCode}';
        throw Exception(mensaje);
      }
    } on DioException catch (e) {
      print('❌ Error: ${e.message}');
      print('❌ Tipo: ${e.type}');
      print('❌ Request: ${e.requestOptions.method} ${e.requestOptions.path}');
      print('❌ Headers enviados: ${e.requestOptions.headers}');
      print('❌ Data enviada: ${e.requestOptions.data}');
      print('❌ Response: ${e.response?.data}');
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<Club> updateClub(int id, Club club) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.put(
        '/clubes/$id',
        data: club.toJson(),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return Club.fromJson(response.data);
      } else {
        throw Exception('Error al actualizar club: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }

  Future<void> deleteClub(int id) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _dio.delete(
        '/clubes/$id',
        options: Options(headers: headers),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar club: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}