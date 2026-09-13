import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // 🔥 Leer el token del almacenamiento
      final token = await StorageService.getString('token');

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        debugPrint('🔑 Token inyectado en ${options.method} ${options.path}');
      } else {
        debugPrint('⚠️ No hay token para inyectar en ${options.method} ${options.path}');
      }
    } catch (e) {
      debugPrint('❌ Error al leer token: $e');
    }

    return handler.next(options);
  }
}