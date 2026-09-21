import 'package:flutter/material.dart';
import '../models/tabla_posiciones.dart';
import '../services/tabla_posiciones_service.dart';

class TablaPosicionesProvider extends ChangeNotifier {
  final TablaPosicionesService _service;

  List<TablaPosiciones> _posiciones = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TablaPosiciones> get posiciones => _posiciones;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TablaPosicionesProvider(this._service);

  Future<void> loadTabla() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _posiciones = await _service.getTablaPosiciones();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearPosicion(TablaPosiciones posicion) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nueva = await _service.createPosicion(posicion);
      _posiciones.add(nueva);
      // Reordenar por puntos desc
      _posiciones.sort((a, b) => b.puntos.compareTo(a.puntos));
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

  Future<bool> actualizarPosicion(int id, TablaPosiciones posicion) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizada = await _service.updatePosicion(id, posicion);
      final index = _posiciones.indexWhere((p) => p.idPosicion == id);
      if (index != -1) {
        _posiciones[index] = actualizada;
      }
      _posiciones.sort((a, b) => b.puntos.compareTo(a.puntos));
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

  Future<bool> deletePosicion(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deletePosicion(id);
      _posiciones.removeWhere((p) => p.idPosicion == id);
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}