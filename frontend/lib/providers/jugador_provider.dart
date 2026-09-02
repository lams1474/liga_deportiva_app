import 'package:flutter/material.dart';
import '../models/jugador.dart';
import '../services/jugador_service.dart';
import '../database/app_dao.dart';

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
      _errorMessage = e.toString();
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
      _errorMessage = e.toString();
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
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 🔥 CORREGIDO: deleteJugador ahora realmente elimina
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
      _errorMessage = e.toString();
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
  // 🔥 MÉTODOS DE SINCRONIZACIÓN
  // ============================================================

  // Sincronización: Crear jugador desde la cola
  Future<bool> syncCreateJugador(Jugador jugador) async {
    try {
      final nuevo = await _service.createJugador(jugador);
      
      // Verificar si ya existe en la lista local
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

  // Sincronización: Actualizar jugador desde la cola
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

  // Sincronización: Eliminar jugador desde la cola
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

  // Guardar jugador localmente (sin conexión)
  Future<void> _saveJugadorLocal(Jugador jugador) async {
    final db = AppDao();
    await db.insertarJugador({
      'cedula': jugador.cedula,
      'nombre': jugador.nombre,
      'ciudad': jugador.ciudad,
      'fecha_nacimiento': jugador.fechaNacimiento.toIso8601String().split('T').first,
      'id_club': jugador.idClub,
      'pendiente_envio': 1,
      'ultima_sincronizacion': null,
      'eliminado_local': 0,
    });
  }
}