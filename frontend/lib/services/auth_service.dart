import 'package:dio/dio.dart';
import '../models/login_response.dart';
import 'dio_config.dart';

class AuthService {
  final Dio _dio;

  // 🔥 CORREGIDO: El login NO usa interceptores (no hay token aún)
  AuthService() : _dio = DioConfig.createDio();

  Future<LoginResponse> login(String email, String password) async {
    try {
      print('🔑 Intentando login con: $email');

      // El backend espera "correo" y "contrasena"
      final data = {
        'correo': email,
        'contrasena': password,
      };

      print('📦 Enviando data: $data');

      final response = await _dio.post(
        '/auth/login',
        data: data,
      );

      print('📥 Status: ${response.statusCode}');
      print('📦 Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(response.data);
      } else if (response.statusCode == 400) {
        final errorData = response.data;
        final mensaje = errorData['mensaje'] ?? 'Datos inválidos';
        throw Exception(mensaje);
      } else if (response.statusCode == 401) {
        throw Exception('Credenciales incorrectas');
      } else {
        throw Exception('Error al iniciar sesión: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.message}');
      print('❌ Tipo: ${e.type}');
      if (e.response != null) {
        print('❌ Status: ${e.response?.statusCode}');
        print('❌ Data: ${e.response?.data}');
      }

      if (e.response?.statusCode == 401) {
        throw Exception('Credenciales incorrectas');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Tiempo de espera agotado. Verifica que el backend esté corriendo.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No se puede conectar al servidor. Verifica que el backend esté corriendo.');
      } else if (e.type == DioExceptionType.badResponse) {
        final errorData = e.response?.data;
        if (errorData != null && errorData['mensaje'] != null) {
          throw Exception(errorData['mensaje']);
        }
        throw Exception('Error en el servidor: ${e.response?.statusCode}');
      }
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      print('❌ Error general: $e');
      throw Exception('Error inesperado: $e');
    }
  }
}