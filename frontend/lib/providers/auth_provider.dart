import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _errorMessage;
  Usuario? _usuario;
  String? _token;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Usuario? get usuario => _usuario;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadToken();
  }

  // 🔥 Cargar token desde almacenamiento seguro
  Future<void> _loadToken() async {
    try {
      _token = await _storage.read(key: 'token');
      // Cargar usuario si existe
      final userJson = await _storage.read(key: 'usuario');
      if (userJson != null) {
        // TODO: Parsear usuario desde JSON
      }
      notifyListeners();
    } catch (e) {
      print('Error al cargar token: $e');
    }
  }

  // 🔥 Login - guardar token en almacenamiento seguro
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      
      _token = response.token;
      _usuario = response.usuario;
      
      // Guardar en almacenamiento seguro
      await _storage.write(key: 'token', value: response.token);
      // Guardar usuario como JSON
      // await _storage.write(key: 'usuario', value: jsonEncode(response.usuario.toJson()));
      
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

  // 🔥 Logout - eliminar todo del almacenamiento seguro
  Future<void> logout() async {
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'usuario');
    _token = null;
    _usuario = null;
    notifyListeners();
  }

  // 🔥 Obtener token para las peticiones
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}