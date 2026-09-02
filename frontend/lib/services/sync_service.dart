import 'dart:convert';  // Para parsear JSON
import '../database/app_dao.dart';
import '../models/club.dart';
import '../models/jugador.dart';
import '../providers/club_provider.dart';
import '../providers/jugador_provider.dart';

class SyncService {
  final AppDao appDao;
  final ClubProvider clubProvider;
  final JugadorProvider jugadorProvider;

  SyncService({
    required this.appDao,
    required this.clubProvider,
    required this.jugadorProvider,
  });

  Future<void> syncAllPending() async {
    final operaciones = await appDao.obtenerOperacionesListasParaReintentar();

    for (var op in operaciones) {
      try {
        switch (op['entidad']) {
          case 'club':
            await _syncClub(op);
            break;
          case 'jugador':
            await _syncJugador(op);
            break;
          default:
            await appDao.marcarComoCompletada(op['id'] as int);
            break;
        }
      } catch (e) {
        await appDao.registrarIntentoFallido(
          op['id'] as int,
          segundosEspera: 5,
        );
        print('❌ Error sincronizando operación ${op['id']}: $e');
      }
    }
  }

  Future<void> _syncClub(Map<String, dynamic> op) async {
    final datos = op['datos'] as String;
    final operacion = op['operacion'] as String;

    try {
      // CORREGIDO: Parsear el JSON String a Map
      final Map<String, dynamic> jsonData = jsonDecode(datos);
      
      switch (operacion) {
        case 'crear':
          final club = Club.fromJson(jsonData);
          await clubProvider.syncCreateClub(club);
          break;
        case 'actualizar':
          final club = Club.fromJson(jsonData);
          await clubProvider.syncUpdateClub(club);
          break;
        case 'eliminar':
          final id = jsonData['id'] ?? int.parse(datos);
          await clubProvider.syncDeleteClub(id);
          break;
      }
      await appDao.marcarComoCompletada(op['id'] as int);
      print('✅ Sincronizado club: $operacion');
    } catch (e) {
      throw Exception('Error sincronizando club: $e');
    }
  }

  Future<void> _syncJugador(Map<String, dynamic> op) async {
    final datos = op['datos'] as String;
    final operacion = op['operacion'] as String;

    try {
      // CORREGIDO: Parsear el JSON String a Map
      final Map<String, dynamic> jsonData = jsonDecode(datos);
      
      switch (operacion) {
        case 'crear':
          final jugador = Jugador.fromJson(jsonData);
          await jugadorProvider.syncCreateJugador(jugador);
          break;
        case 'actualizar':
          final jugador = Jugador.fromJson(jsonData);
          await jugadorProvider.syncUpdateJugador(jugador);
          break;
        case 'eliminar':
          final id = jsonData['id'] ?? int.parse(datos);
          await jugadorProvider.syncDeleteJugador(id);
          break;
      }
      await appDao.marcarComoCompletada(op['id'] as int);
      print('✅ Sincronizado jugador: $operacion');
    } catch (e) {
      throw Exception('Error sincronizando jugador: $e');
    }
  }

  Future<void> addPendingOperation({
    required String operacion,
    required String entidad,
    required Map<String, dynamic> datos,
    required String idUnicoCliente,
  }) async {
    // CORREGIDO: Convertir Map a String JSON
    await appDao.agregarOperacion(
      operacion: operacion,
      entidad: entidad,
      datos: jsonEncode(datos),  // ← Convertir a String
      idUnicoCliente: idUnicoCliente,
    );
  }
}