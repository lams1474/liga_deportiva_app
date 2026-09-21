import 'package:flutter/material.dart';
import '../models/jugador.dart';
import '../services/jugador_service.dart';

class JugadorProvider extends ChangeNotifier {
  final JugadorService _service;

  List<Jugador> _jugadores = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Jugador> get jugadores => _jugadores;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  JugadorProvider(this._service);

  Future<void> loadJugadores() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _jugadores = await _service.getJugadores();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createJugador(Jugador jugador) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nuevo = await _service.createJugador(jugador);
      _jugadores.add(nuevo);
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

  Future<bool> updateJugador(int id, Jugador jugador) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _service.updateJugador(id, jugador);
      final index = _jugadores.indexWhere((j) => j.idJugador == id);
      if (index != -1) {
        _jugadores[index] = actualizado;
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

  Future<bool> deleteJugador(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteJugador(id);
      _jugadores.removeWhere((j) => j.idJugador == id);
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

  Jugador? getJugadorById(int id) {
    try {
      return _jugadores.firstWhere((j) => j.idJugador == id);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ============================================================
  // MÉTODOS DE SINCRONIZACIÓN
  // ============================================================

  Future<bool> syncCreateJugador(Jugador jugador) async {
    try {
      final nuevo = await _service.createJugador(jugador);

      final exists = _jugadores.any((j) => j.idJugador == nuevo.idJugador);
      if (!exists) {
        _jugadores.add(nuevo);
      }
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Error syncCreateJugador: $e');
    }
  }

  Future<bool> syncUpdateJugador(Jugador jugador) async {
    try {
      final actualizado = await _service.updateJugador(jugador.idJugador!, jugador);
      final index = _jugadores.indexWhere((j) => j.idJugador == jugador.idJugador);
      if (index != -1) {
        _jugadores[index] = actualizado;
      }
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Error syncUpdateJugador: $e');
    }
  }

  Future<bool> syncDeleteJugador(int id) async {
    try {
      await _service.deleteJugador(id);
      _jugadores.removeWhere((j) => j.idJugador == id);
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Error syncDeleteJugador: $e');
    }
  }
}