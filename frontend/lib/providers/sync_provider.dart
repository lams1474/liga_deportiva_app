import 'package:flutter/material.dart';
import 'dart:convert';  // Para parsear JSON
import '../services/sync_service.dart';
import '../database/app_dao.dart';
import '../models/club.dart';
import '../models/jugador.dart';
import 'club_provider.dart';
import 'jugador_provider.dart';

class SyncProvider extends ChangeNotifier {
  final AppDao appDao;
  final ClubProvider clubProvider;
  final JugadorProvider jugadorProvider;
  late final SyncService syncService;

  bool _isSyncing = false;
  int _pendingOperations = 0;

  bool get isSyncing => _isSyncing;
  int get pendingOperations => _pendingOperations;

  SyncProvider({
    required this.appDao,
    required this.clubProvider,
    required this.jugadorProvider,
  }) {
    syncService = SyncService(
      appDao: appDao,
      clubProvider: clubProvider,
      jugadorProvider: jugadorProvider,
    );
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    final ops = await appDao.obtenerOperacionesPendientes();
    _pendingOperations = ops.length;
    notifyListeners();
  }

  Future<void> addPendingOperation({
    required String operacion,
    required String entidad,
    required Map<String, dynamic> datos,
  }) async {
    final idUnico = '${DateTime.now().millisecondsSinceEpoch}_${datos['nombre'] ?? datos['cedula'] ?? ''}';
    await syncService.addPendingOperation(
      operacion: operacion,
      entidad: entidad,
      datos: datos,
      idUnicoCliente: idUnico,
    );
    _pendingOperations++;
    notifyListeners();
  }

  Future<void> syncNow() async {
    if (_isSyncing) return;

    _isSyncing = true;
    notifyListeners();

    try {
      await syncService.syncAllPending();
      await _loadPendingCount();
      print('✅ Sincronización completada');
    } catch (e) {
      print('❌ Error en sincronización: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
}