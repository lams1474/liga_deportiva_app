import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> setString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      print('✅ Token guardado en SharedPreferences: ${value.substring(0, 20)}...');
    } catch (e) {
      print('❌ Error guardando token: $e');
    }
  }

  static Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      if (value != null && value.isNotEmpty) {
        print('✅ Token leído de SharedPreferences: ${value.substring(0, 20)}...');
      } else {
        print('❌ No hay token en SharedPreferences');
      }
      return value;
    } catch (e) {
      print('❌ Error leyendo token: $e');
      return null;
    }
  }

  static Future<void> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      print('✅ Token eliminado de SharedPreferences');
    } catch (e) {
      print('❌ Error eliminando token: $e');
    }
  }
}