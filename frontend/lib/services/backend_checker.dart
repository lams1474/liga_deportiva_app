import 'dart:io';
import '../config/api_config.dart';

class BackendChecker {
  /// 🔥 Verifica si el backend responde AHORA MISMO
  static Future<bool> estaDisponible() async {
    try {
      final uri = Uri.parse(ApiConfig.apiUrl);
      print('🔍 Verificando backend en ${uri.host}:${uri.port}...');

      final socket = await Socket.connect(
        uri.host,
        uri.port,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      print('✅ Backend disponible');
      return true;
    } catch (e) {
      print('❌ Backend NO disponible: $e');
      return false;
    }
  }
}