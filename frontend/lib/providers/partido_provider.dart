import 'package:flutter/material.dart';
import '../models/partido.dart';
import '../services/partido_service.dart';

class PartidoProvider extends ChangeNotifier {
  final PartidoService _service;

  List<Partido> _partidos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Partido> get partidos => _partidos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PartidoProvider(this._service);

  Future<void> loadPartidos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _partidos = await _service.getPartidos();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearPartido(Partido partido) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nuevo = await _service.createPartido(partido);
      _partidos.add(nuevo);
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

  Future<bool> actualizarPartido(int id, Partido partido) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _service.updatePartido(id, partido);
      final index = _partidos.indexWhere((p) => p.idPartido == id);
      if (index != -1) {
        _partidos[index] = actualizado;
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

  Future<bool> deletePartido(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deletePartido(id);
      _partidos.removeWhere((p) => p.idPartido == id);
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