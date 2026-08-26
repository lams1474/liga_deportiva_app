import 'package:dio/dio.dart';

class DioConfig {
  static Dio createDio() {
    final baseUrl = 'http://localhost:3000/api';
    
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // 🔥 Importante: No validar status para manejar errores nosotros mismos 🔥
        validateStatus: (status) => status! < 500,
      ),
    );
  }

  static Dio createDioWithInterceptors() {
    final dio = createDio();
    
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🚀 Request: ${options.method} ${options.baseUrl}${options.path}');
          print('📦 Headers: ${options.headers}');
          if (options.data != null) {
            print('📦 Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ Error: ${error.message}');
          print('❌ Tipo: ${error.type}');
          if (error.response != null) {
            print('❌ Status: ${error.response?.statusCode}');
            print('❌ Data: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
    
    return dio;
  }
}