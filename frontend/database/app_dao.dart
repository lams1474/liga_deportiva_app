import 'database_helper.dart';

class AppDao {
  final DatabaseHelper db = DatabaseHelper();

  // ============================================================
  // LIMPIAR TODA LA BASE DE DATOS
  // ============================================================

  Future<void> limpiarTodaLaBaseDeDatos() async {
    await db.limpiarTodaLaBaseDeDatos();
  }

  Future<void> close() async {
    await db.close();
  }

  // ============================================================
  // CLUBES
  // ============================================================

  Future<int> insertarClub(Map<String, dynamic> club) async {
    return await db.insertarClub(club);
  }

  Future<List<Map<String, dynamic>>> obtenerTodosLosClubes() async {
    return await db.obtenerTodosLosClubes();
  }

  Future<List<Map<String, dynamic>>> obtenerClubesPendientes() async {
    return await db.obtenerClubesPendientes();
  }

  Future<int> actualizarClub(Map<String, dynamic> club) async {
    return await db.actualizarClub(club);
  }

  Future<void> eliminarClubLocalmente(int id) async {
    await db.eliminarClubLocalmente(id);
  }

  // ============================================================
  // JUGADORES
  // ============================================================

  Future<int> insertarJugador(Map<String, dynamic> jugador) async {
    return await db.insertarJugador(jugador);
  }

  Future<List<Map<String, dynamic>>> obtenerTodosLosJugadores() async {
    return await db.obtenerTodosLosJugadores();
  }

  Future<List<Map<String, dynamic>>> obtenerJugadoresPendientes() async {
    return await db.obtenerJugadoresPendientes();
  }

  Future<int> actualizarJugador(Map<String, dynamic> jugador) async {
    return await db.actualizarJugador(jugador);
  }

  Future<void> eliminarJugadorLocalmente(int id) async {
    await db.eliminarJugadorLocalmente(id);
  }

  // ============================================================
  // OPERACIONES PENDIENTES
  // ============================================================

  Future<int> agregarOperacion({
    required String operacion,
    required String entidad,
    required String datos,
    required String idUnicoCliente,
  }) async {
    return await db.agregarOperacion(
      operacion: operacion,
      entidad: entidad,
      datos: datos,
      idUnicoCliente: idUnicoCliente,
    );
  }

  Future<List<Map<String, dynamic>>> obtenerOperacionesPendientes() async {
    return await db.obtenerOperacionesPendientes();
  }

  Future<List<Map<String, dynamic>>> obtenerOperacionesListasParaReintentar() async {
    return await db.obtenerOperacionesListasParaReintentar();
  }

  Future<void> marcarComoCompletada(int id) async {
    await db.marcarComoCompletada(id);
  }

  Future<void> registrarIntentoFallido(int id, {int? segundosEspera}) async {
    await db.registrarIntentoFallido(id, segundosEspera: segundosEspera);
  }

  Future<Map<String, dynamic>?> obtenerPorIdUnico(String idUnico) async {
    return await db.obtenerPorIdUnico(idUnico);
  }

  Future<void> limpiarTodasLasOperaciones() async {
    await db.limpiarTodasLasOperaciones();
  }
}