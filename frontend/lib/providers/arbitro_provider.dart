import 'package:flutter/material.dart';
import '../models/arbitro.dart';
import '../services/arbitro_service.dart';

class ArbitroProvider extends ChangeNotifier {
  final ArbitroService _service;

  List<Arbitro> _arbitros = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Arbitro> get arbitros => _arbitros;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ArbitroProvider(this._service);

  Future<void> loadArbitros() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _arbitros = await _service.getArbitros();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearArbitro(Arbitro arbitro) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nuevo = await _service.createArbitro(arbitro);
      _arbitros.add(nuevo);
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

  Future<bool> actualizarArbitro(int id, Arbitro arbitro) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _service.updateArbitro(id, arbitro);
      final index = _arbitros.indexWhere((a) => a.idArbitro == id);
      if (index != -1) {
        _arbitros[index] = actualizado;
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

  Future<bool> deleteArbitro(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteArbitro(id);
      _arbitros.removeWhere((a) => a.idArbitro == id);
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