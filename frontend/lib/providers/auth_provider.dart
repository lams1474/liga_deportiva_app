import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  Usuario? _usuario;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Usuario? get usuario => _usuario;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      _token = await StorageService.getString('token');
      if (_token != null && _token!.isNotEmpty) {
        print('✅ Token cargado: ${_token!.substring(0, 20)}...');
      } else {
        print('❌ No hay token guardado');
        _token = null;
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error al cargar token: $e');
      _token = null;
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

      // 🔥 Guardar access token
      await StorageService.setString('token', response.token);

      // 🔥 Guardar refresh token (si viene en la respuesta)
      if (response.refreshToken != null && response.refreshToken!.isNotEmpty) {
        await StorageService.setString('refresh_token', response.refreshToken!);
        print('✅ Refresh token guardado');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await StorageService.remove('token');
    await StorageService.remove('refresh_token');
    _token = null;
    _usuario = null;
    print('✅ Sesión cerrada');
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}