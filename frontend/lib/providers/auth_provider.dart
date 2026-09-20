import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  static const String _tokenKey = 'token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _usuarioKey = 'usuario_actual';

  bool _isLoading = false;
  bool _initialized = false;
  String? _errorMessage;
  Usuario? _usuario;
  String? _token;

  bool get isLoading => _isLoading;
  bool get initialized => _initialized;
  String? get errorMessage => _errorMessage;
  Usuario? get usuario => _usuario;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  AuthProvider() {
    _loadSession();
  }

  /// 🔥 Carga token + usuario desde storage
  Future<void> _loadSession() async {
    try {
      _token = await StorageService.getString(_tokenKey);
      final usuarioJson = await StorageService.getString(_usuarioKey);

      if (_token != null && _token!.isNotEmpty) {
        debugPrint('✅ Token cargado');

        // 🔥 Restaurar usuario desde storage
        if (usuarioJson != null && usuarioJson.isNotEmpty) {
          try {
            _usuario = Usuario.fromJson(jsonDecode(usuarioJson));
            debugPrint('✅ Usuario restaurado: ${_usuario?.correo} (rol: ${_usuario?.rol})');
          } catch (e) {
            debugPrint('⚠️ Error parseando usuario guardado: $e');
            _usuario = null;
          }
        }
      } else {
        debugPrint('❌ No hay token guardado');
        _token = null;
        _usuario = null;
      }
    } catch (e) {
      debugPrint('❌ Error al cargar sesión: $e');
      _token = null;
      _usuario = null;
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);

      _token = response.token;
      _usuario = response.usuario;

      // 🔥 Guardar token
      await StorageService.setString(_tokenKey, response.token);

      // 🔥 Guardar refresh token
      if (response.refreshToken != null && response.refreshToken!.isNotEmpty) {
        await StorageService.setString(_refreshTokenKey, response.refreshToken!);
        debugPrint('✅ Refresh token guardado');
      }

      // 🔥 Guardar usuario completo (para restaurar el rol)
      if (_usuario != null) {
        await StorageService.setString(
          _usuarioKey,
          jsonEncode(_usuario!.toJson()),
        );
        debugPrint('✅ Usuario guardado: rol=${_usuario!.rol}');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await StorageService.remove(_tokenKey);
    await StorageService.remove(_refreshTokenKey);
    await StorageService.remove(_usuarioKey);
    _token = null;
    _usuario = null;
    debugPrint('✅ Sesión cerrada');
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}