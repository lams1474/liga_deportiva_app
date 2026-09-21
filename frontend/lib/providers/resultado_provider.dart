import 'package:flutter/material.dart';
import '../models/resultado.dart';
import '../services/resultado_service.dart';

class ResultadoProvider extends ChangeNotifier {
  final ResultadoService _service;

  List<Resultado> _resultados = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Resultado> get resultados => _resultados;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ResultadoProvider(this._service);

  Future<void> loadResultados() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _resultados = await _service.getResultados();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearResultado(Resultado resultado) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nuevo = await _service.createResultado(resultado);
      _resultados.add(nuevo);
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

  Future<bool> actualizarResultado(int id, Resultado resultado) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _service.updateResultado(id, resultado);
      final index = _resultados.indexWhere((r) => r.idResultado == id);
      if (index != -1) {
        _resultados[index] = actualizado;
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

  Future<bool> deleteResultado(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteResultado(id);
      _resultados.removeWhere((r) => r.idResultado == id);
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