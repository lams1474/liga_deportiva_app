import 'package:flutter/material.dart';
import '../models/club.dart';
import '../services/club_service.dart';

class ClubProvider extends ChangeNotifier {

  final ClubService _service = ClubService();

  List<Club> _clubes = [];

  bool _cargando = false;

  String? _error;

  List<Club> get clubes => _clubes;

  bool get cargando => _cargando;

  String? get error => _error;

  // ============================
  // Obtener clubes
  // ============================

  Future<void> cargarClubes() async {

    _cargando = true;
    _error = null;

    notifyListeners();

    try {

      _clubes = await _service.obtenerClubes();

    } catch (e) {

      _error = e.toString();

    }

    _cargando = false;

    notifyListeners();

  }

  // ============================
  // Crear club
  // ============================

  Future<bool> crearClub({

    required String nombre,
    required String ciudad,
    required String fechaFundacion,

  }) async {

    try {

      await _service.crearClub(

        nombre: nombre,
        ciudad: ciudad,
        fechaFundacion: fechaFundacion,

      );

      await cargarClubes();

      return true;

    } catch (e) {

      _error = e.toString();

      notifyListeners();

      return false;

    }

  }

  // ============================
  // Actualizar club
  // ============================

  Future<bool> actualizarClub({

    required int idClub,
    required String nombre,
    required String ciudad,
    required String fechaFundacion,

  }) async {

    try {

      await _service.actualizarClub(

        idClub: idClub,
        nombre: nombre,
        ciudad: ciudad,
        fechaFundacion: fechaFundacion,

      );

      await cargarClubes();

      return true;

    } catch (e) {

      _error = e.toString();

      notifyListeners();

      return false;

    }

  }

  // ============================
  // Eliminar club
  // ============================

  Future<bool> eliminarClub(int idClub) async {

    try {

      await _service.eliminarClub(idClub);

      await cargarClubes();

      return true;

    } catch (e) {

      _error = e.toString();

      notifyListeners();

      return false;

    }

  }

}