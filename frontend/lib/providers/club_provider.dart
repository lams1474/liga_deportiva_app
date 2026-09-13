import 'package:flutter/material.dart';
import '../models/club.dart';
import '../services/club_service.dart';
import '../database/app_dao.dart';

class ClubProvider extends ChangeNotifier {
  final ClubService _service;

  List<Club> _clubs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Club> get clubs => _clubs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ClubProvider(this._service);

  // ============================================================
  // OPERACIONES CRUD
  // ============================================================

  Future<void> loadClubs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _clubs = await _service.getClubs();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearClub(Club club) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nuevo = await _service.createClub(club);
      _clubs.add(nuevo);
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

  // Alias para mantener compatibilidad
  Future<bool> createClub(Club club) => crearClub(club);

  Future<bool> actualizarClub(int id, Club club) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _service.updateClub(id, club);
      final index = _clubs.indexWhere((c) => c.idClub == id);
      if (index != -1) {
        _clubs[index] = actualizado;
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

  Future<bool> updateClub(int id, Club club) => actualizarClub(id, club);

  Future<bool> deleteClub(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteClub(id);
      _clubs.removeWhere((c) => c.idClub == id);
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

  Club? getClubById(int id) {
    try {
      return _clubs.firstWhere((c) => c.idClub == id);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ============================================================
  // 🔥 MÉTODOS DE SINCRONIZACIÓN (restaurados)
  // ============================================================

  Future<bool> syncCreateClub(Club club) async {
    try {
      final nuevo = await _service.createClub(club);

      final exists = _clubs.any((c) => c.idClub == nuevo.idClub);
      if (!exists) {
        _clubs.add(nuevo);
      }
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Error syncCreateClub: $e');
    }
  }

  Future<bool> syncUpdateClub(Club club) async {
    try {
      final actualizado = await _service.updateClub(club.idClub!, club);
      final index = _clubs.indexWhere((c) => c.idClub == club.idClub);
      if (index != -1) {
        _clubs[index] = actualizado;
      }
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Error syncUpdateClub: $e');
    }
  }

  Future<bool> syncDeleteClub(int id) async {
    try {
      await _service.deleteClub(id);
      _clubs.removeWhere((c) => c.idClub == id);
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Error syncDeleteClub: $e');
    }
  }

  // Guardar club localmente (sin conexión)
  Future<void> saveClubLocal(Club club) async {
    final db = AppDao();
    await db.insertarClub({
      'nombre': club.nombre,
      'ciudad': club.ciudad,
      'fecha_fundacion': club.fechaFundacion.toIso8601String().split('T').first,
      'pendiente_envio': 1,
      'ultima_sincronizacion': null,
      'eliminado_local': 0,
    });
  }
}