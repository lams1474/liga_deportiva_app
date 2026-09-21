import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../services/categoria_service.dart';

class CategoriaProvider extends ChangeNotifier {
  final CategoriaService _service;

  List<Categoria> _categorias = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Categoria> get categorias => _categorias;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CategoriaProvider(this._service);

  // ============================================================
  // OPERACIONES CRUD
  // ============================================================

  Future<void> loadCategorias() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categorias = await _service.getCategorias();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearCategoria(Categoria categoria) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nueva = await _service.createCategoria(categoria);
      _categorias.add(nueva);
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

  Future<bool> actualizarCategoria(int id, Categoria categoria) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizada = await _service.updateCategoria(id, categoria);
      final index = _categorias.indexWhere((c) => c.idCategoria == id);
      if (index != -1) {
        _categorias[index] = actualizada;
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

  Future<bool> deleteCategoria(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteCategoria(id);
      _categorias.removeWhere((c) => c.idCategoria == id);
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

  Categoria? getCategoriaById(int id) {
    try {
      return _categorias.firstWhere((c) => c.idCategoria == id);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}