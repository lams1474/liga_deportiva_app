import 'package:flutter/material.dart';
import '../models/disciplina.dart';
import '../services/disciplina_service.dart';

class DisciplinaProvider extends ChangeNotifier {
  final DisciplinaService _service;

  List<Disciplina> _disciplinas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Disciplina> get disciplinas => _disciplinas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DisciplinaProvider(this._service);

  // ============================================================
  // OPERACIONES CRUD
  // ============================================================

  Future<void> loadDisciplinas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _disciplinas = await _service.getDisciplinas();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearDisciplina(Disciplina disciplina) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nueva = await _service.createDisciplina(disciplina);
      _disciplinas.add(nueva);
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

  Future<bool> actualizarDisciplina(int id, Disciplina disciplina) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizada = await _service.updateDisciplina(id, disciplina);
      final index = _disciplinas.indexWhere((d) => d.idDisciplina == id);
      if (index != -1) {
        _disciplinas[index] = actualizada;
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

  Future<bool> deleteDisciplina(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteDisciplina(id);
      _disciplinas.removeWhere((d) => d.idDisciplina == id);
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

  Disciplina? getDisciplinaById(int id) {
    try {
      return _disciplinas.firstWhere((d) => d.idDisciplina == id);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ============================================================
  // 🔥 MÉTODOS DE SINCRONIZACIÓN (para modo offline)
  // ============================================================

  Future<bool> syncCreateDisciplina(Disciplina disciplina) async {
    try {
      final nueva = await _service.createDisciplina(disciplina);
      final exists = _disciplinas.any((d) => d.idDisciplina == nueva.idDisciplina);
      if (!exists) {
        _disciplinas.add(nueva);
      }
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Error syncCreateDisciplina: $e');
    }
  }

  Future<bool> syncUpdateDisciplina(Disciplina disciplina) async {
    try {
      final actualizada = await _service.updateDisciplina(
        disciplina.idDisciplina!,
        disciplina,
      );
      final index = _disciplinas.indexWhere(
        (d) => d.idDisciplina == disciplina.idDisciplina,
      );
      if (index != -1) {
        _disciplinas[index] = actualizada;
      }
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Error syncUpdateDisciplina: $e');
    }
  }

  Future<bool> syncDeleteDisciplina(int id) async {
    try {
      await _service.deleteDisciplina(id);
      _disciplinas.removeWhere((d) => d.idDisciplina == id);
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception('Error syncDeleteDisciplina: $e');
    }
  }
}