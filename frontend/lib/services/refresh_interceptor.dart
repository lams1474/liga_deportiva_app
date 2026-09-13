import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import '../config/api_config.dart';

class RefreshInterceptor extends Interceptor {
  final Dio _dio;

  RefreshInterceptor()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.apiUrl,
            connectTimeout: ApiConfig.connectTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            // 🔥 Aceptar 4xx como respuestas normales para que el service las maneje
            validateStatus: (status) => status != null && status < 500,
          ),
        );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 🔥 Solo manejar errores 401
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final yaReintentado = err.requestOptions.extra['reintentado'] == true;
    if (yaReintentado) {
      debugPrint('⚠️ Ya se reintentó, cerrando sesión');
      await _cerrarSesion();
      return handler.next(err);
    }

    debugPrint('🔄 Token expirado, intentando renovar...');

    try {
      final refreshToken = await StorageService.getString('refresh_token');
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('❌ No hay refresh token');
        await _cerrarSesion();
        return handler.next(err);
      }

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final nuevoToken = response.data['token'];
        if (nuevoToken != null && nuevoToken.isNotEmpty) {
          await StorageService.setString('token', nuevoToken);
          debugPrint('✅ Token renovado correctamente');

          err.requestOptions.extra['reintentado'] = true;
          err.requestOptions.headers['Authorization'] = 'Bearer $nuevoToken';

          // 🔥 Reintentar la petición original
          try {
            final respuestaReintentada = await _dio.fetch(err.requestOptions);
            debugPrint('✅ Petición reintentada: ${respuestaReintentada.statusCode}');
            return handler.resolve(respuestaReintentada);
          } catch (e) {
            // 🔥 Si el reintento falla con 422 (validación), devolver ese error
            debugPrint('⚠️ Reintento falló con error de validación: $e');
            return handler.next(err);
          }
        }
      }

      debugPrint('❌ Refresh falló');
      await _cerrarSesion();
      return handler.next(err);
    } catch (e) {
      debugPrint('❌ Error al renovar: $e');
      await _cerrarSesion();
      return handler.next(err);
    }
  }

  Future<void> _cerrarSesion() async {
    await StorageService.remove('token');
    await StorageService.remove('refresh_token');
    debugPrint('👋 Sesión cerrada');
  }
}