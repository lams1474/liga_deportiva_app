import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import 'auth_interceptor.dart';
import 'refresh_interceptor.dart';

class DioConfig {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio createDioWithInterceptors() => instance;
  static Dio createDio() => _createDio();

  static Dio _createDio() {
    ApiConfig.printConfig();

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // 🔥 CORREGIDO: Solo aceptar 2xx como éxito
        validateStatus: (status) => status != null && status >= 200 && status < 300,
      ),
    );

    _addInterceptors(dio);

    return dio;
  }

  static void _addInterceptors(Dio dio) {
    // 1. AuthInterceptor: inyecta el token
    dio.interceptors.add(AuthInterceptor());

    // 2. RefreshInterceptor: maneja el 401 y renueva el token
    dio.interceptors.add(RefreshInterceptor());

    // 3. Log de peticiones (solo en desarrollo)
    if (ApiConfig.enableLogs) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint('📡 $obj'),
        ),
      );
    }

    // 4. Interceptor de errores del dominio
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // 🔥 NO traducir errores 422 (dejar que el service los maneje)
          if (error.response?.statusCode == 422) {
            debugPrint('⚠️ Error 422 detectado, dejando pasar al service');
            return handler.next(error);
          }

          final domainError = _translateError(error);
          debugPrint('❌ Error de dominio: ${domainError.error}');
          return handler.next(domainError);
        },
      ),
    );
  }

  static DioException _translateError(DioException error) {
    String mensaje;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        mensaje = 'Tiempo de conexión agotado. Verifica tu internet.';
        break;
      case DioExceptionType.sendTimeout:
        mensaje = 'Tiempo de envío agotado. Intenta de nuevo.';
        break;
      case DioExceptionType.receiveTimeout:
        mensaje = 'El servidor tardó demasiado en responder.';
        break;
      case DioExceptionType.transformTimeout:
        mensaje = 'Tiempo de procesamiento agotado.';
        break;
      case DioExceptionType.connectionError:
        mensaje = 'No hay conexión a internet.';
        break;
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 401) {
          mensaje = 'Sesión expirada. Inicia sesión de nuevo.';
        } else if (code == 403) {
          mensaje = 'No tienes permisos para esta acción.';
        } else if (code == 404) {
          mensaje = 'Recurso no encontrado.';
        } else if (code != null && code >= 500) {
          mensaje = 'Error del servidor. Intenta más tarde.';
        } else {
          mensaje = 'Error inesperado (${code ?? "desconocido"}).';
        }
        break;
      case DioExceptionType.cancel:
        mensaje = 'Petición cancelada.';
        break;
      case DioExceptionType.unknown:
        mensaje = 'Error desconocido de conexión.';
        break;
      case DioExceptionType.badCertificate:
        mensaje = 'Certificado de seguridad inválido.';
        break;
    }

    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      error: mensaje,
    );
  }

  static void reset() {
    _instance = null;
  }
}