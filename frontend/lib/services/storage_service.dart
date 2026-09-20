import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> setString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      final preview = value.length > 20 ? '${value.substring(0, 20)}...' : value;
      print('✅ Guardado "$key": $preview');
    } catch (e) {
      print('❌ Error guardando "$key": $e');
    }
  }

  static Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      if (value != null && value.isNotEmpty) {
        final preview = value.length > 20 ? '${value.substring(0, 20)}...' : value;
        print('✅ Leído "$key": $preview');
      } else {
        print('❌ No hay valor para "$key"');
      }
      return value;
    } catch (e) {
      print('❌ Error leyendo "$key": $e');
      return null;
    }
  }

  static Future<void> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      print('✅ Eliminado "$key"');
    } catch (e) {
      print('❌ Error eliminando "$key": $e');
    }
  }
}