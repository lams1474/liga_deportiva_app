import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioConfig {
  static const String baseUrl = 'http://localhost:3000/api';
  
  static Dio createDio() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  // 🔥 Versión con interceptores
  static Dio createDioWithInterceptors() {
    final dio = createDio();
    
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Obtener token del almacenamiento seguro
          const storage = FlutterSecureStorage();
          final token = await storage.read(key: 'token');
          
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            // ignore: avoid_print
            print('🔑 Token adjuntado a la solicitud');
          } else {
            // ignore: avoid_print
            print('⚠️ No hay token disponible');
          }
          
          // ignore: avoid_print
          print('🚀 Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // ignore: avoid_print
          print('✅ Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          // Si el token expiró (401)
          if (error.response?.statusCode == 401) {
            // ignore: avoid_print
            print('⚠️ Token expirado o inválido');
          }
          // ignore: avoid_print
          print('❌ Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
    
    return dio;
  }
}