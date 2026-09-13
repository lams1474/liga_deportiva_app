import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/connectivity_service.dart';
import 'sync_provider.dart';
import '../app_global.dart';  // 🔥 IMPORTAR EL NAVIGATORKEY

class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _service = ConnectivityService();
  bool _hasInternet = false;
  
  bool get hasInternet => _hasInternet;

  ConnectivityProvider() {
    _checkConnectivity();
    _listenConnectivity();
  }

  Future<void> _checkConnectivity() async {
    _hasInternet = await _service.hasInternet();
    notifyListeners();
  }

  void _listenConnectivity() {
    _service.connectivityStream.listen((List<ConnectivityResult> results) {
      final newState = results.isNotEmpty && results.first != ConnectivityResult.none;
      
      if (_hasInternet != newState) {
        _hasInternet = newState;
        notifyListeners();
        
        if (_hasInternet) {
          _syncPendingOperations();
        }
      }
    });
  }

  Future<void> _syncPendingOperations() async {
    try {
      // 🔥 Usar navigatorKey de app_global.dart
      final context = navigatorKey.currentContext;
      if (context != null) {
        final syncProvider = Provider.of<SyncProvider>(context, listen: false);
        await syncProvider.syncNow();
        print('🔄 Sincronización automática ejecutada');
      }
    } catch (e) {
      print('❌ Error en sincronización automática: $e');
    }
  }
}