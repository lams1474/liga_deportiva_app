import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// 🔥 Verifica si hay internet REAL (no solo interfaz de red)
  Future<bool> hasInternet() async {
    // 1. ¿Hay alguna interfaz de red activa?
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty || results.first == ConnectivityResult.none) {
      return false;
    }

    // 2. ¿Podemos llegar a internet de verdad?
    return await _checkRealInternet();
  }

  /// 🔥 Ping a un servidor para verificar conectividad real
  Future<bool> _checkRealInternet() async {
    try {
      // Intentar resolver un DNS (Google)
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// 🔥 Stream que emite true/false según internet REAL
  Stream<bool> get onInternetChanged async* {
    yield await hasInternet();
    await for (final _ in _connectivity.onConnectivityChanged) {
      yield await hasInternet();
    }
  }
}