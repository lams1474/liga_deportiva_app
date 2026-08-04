import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {

  final AuthService _authService = AuthService();

  bool _autenticado = false;

  bool _cargando = false;

  bool get autenticado => _autenticado;

  bool get cargando => _cargando;

  Future<bool> login(
    String correo,
    String contrasena,
  ) async {

    _cargando = true;
    notifyListeners();

    try {

      final ok = await _authService.login(
        correo,
        contrasena,
      );

      _autenticado = ok;

      _cargando = false;

      notifyListeners();

      return ok;

    } catch (e) {

      _cargando = false;

      notifyListeners();

      rethrow;

    }

  }

  Future<void> logout() async {

    await _authService.logout();

    _autenticado = false;

    notifyListeners();

  }

}