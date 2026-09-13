import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // 🔥 Verificar si hay conexión a internet
  Future<bool> hasInternet() async {
    try {
      final result = await _connectivity.checkConnectivity();
      // 🔥 CORREGIDO: result es List<ConnectivityResult>
      return result.isNotEmpty && !result.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  // 🔥 Stream de cambios de conectividad
  Stream<List<ConnectivityResult>> get connectivityStream {
    return _connectivity.onConnectivityChanged;
  }
}