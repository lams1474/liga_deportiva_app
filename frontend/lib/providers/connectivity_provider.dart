import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/connectivity_service.dart';
import 'sync_provider.dart';
import '../app_global.dart';

class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _service = ConnectivityService();
  bool _hasInternet = false;
  bool _checking = false;
  StreamSubscription? _subscription;

  bool get hasInternet => _hasInternet;
  bool get checking => _checking;

  ConnectivityProvider() {
    _init();
  }

  Future<void> _init() async {
    await _checkConnectivity();
    _listenConnectivity();
  }

  Future<void> _checkConnectivity() async {
    if (_checking) return;
    _checking = true;
    notifyListeners();

    try {
      final tiene = await _service.hasInternet();
      if (_hasInternet != tiene) {
        _hasInternet = tiene;
      }
    } catch (e) {
      debugPrint('❌ Error verificando conectividad: $e');
      _hasInternet = false;
    } finally {
      _checking = false;
      notifyListeners();
    }
  }

  /// 🔥 Fuerza re-verificación y espera el resultado real
  Future<bool> refresh() async {
    await _checkConnectivity();
    return _hasInternet;
  }

  void _listenConnectivity() {
    _subscription = _service.connectivityStream.listen(
      (List<ConnectivityResult> results) async {
        final newState = await _service.hasInternet();

        if (_hasInternet != newState) {
          _hasInternet = newState;
          notifyListeners();

          if (_hasInternet) {
            _syncPendingOperations();
          }
        }
      },
      onError: (e) {
        debugPrint('❌ Error en stream de conectividad: $e');
      },
    );
  }

  Future<void> _syncPendingOperations() async {
    try {
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        final syncProvider = Provider.of<SyncProvider>(context, listen: false);
        await syncProvider.syncNow();
        debugPrint('🔄 Sincronización automática ejecutada');
      }
    } catch (e) {
      debugPrint('❌ Error en sincronización automática: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}