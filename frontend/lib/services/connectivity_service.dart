import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Verificar si hay conexión a internet
  Future<bool> hasInternet() async {
    try {
      final result = await _connectivity.checkConnectivity();
      // CORREGIDO: connectivity_plus v6 devuelve List<ConnectivityResult>
      return result != ConnectivityResult.none && result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // CORREGIDO: El stream ahora es de List<ConnectivityResult>
  Stream<List<ConnectivityResult>> get connectivityStream {
    return _connectivity.onConnectivityChanged;
  }
}