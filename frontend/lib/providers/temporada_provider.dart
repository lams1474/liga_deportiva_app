import 'package:flutter/material.dart';
import '../models/temporada.dart';
import '../services/temporada_service.dart';

class TemporadaProvider extends ChangeNotifier {
  final TemporadaService _service;

  List<Temporada> _temporadas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Temporada> get temporadas => _temporadas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TemporadaProvider(this._service);

  Future<void> loadTemporadas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _temporadas = await _service.getTemporadas();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearTemporada(Temporada temporada) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nueva = await _service.createTemporada(temporada);
      _temporadas.add(nueva);
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

  Future<bool> actualizarTemporada(int id, Temporada temporada) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizada = await _service.updateTemporada(id, temporada);
      final index = _temporadas.indexWhere((t) => t.idTemporada == id);
      if (index != -1) {
        _temporadas[index] = actualizada;
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

  Future<bool> deleteTemporada(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteTemporada(id);
      _temporadas.removeWhere((t) => t.idTemporada == id);
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