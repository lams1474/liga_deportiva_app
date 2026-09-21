import 'database_helper.dart';

class AppDao {
  final DatabaseHelper db = DatabaseHelper();

  Future<void> limpiarTodaLaBaseDeDatos() async => await db.limpiarTodaLaBaseDeDatos();
  Future<void> close() async => await db.close();

  // CLUBES
  Future<int> insertarClub(Map<String, dynamic> c) async => await db.insertarClub(c);
  Future<List<Map<String, dynamic>>> obtenerTodosLosClubes() async => await db.obtenerTodosLosClubes();
  Future<List<Map<String, dynamic>>> obtenerClubesPendientes() async => await db.obtenerClubesPendientes();
  Future<int> actualizarClub(Map<String, dynamic> c) async => await db.actualizarClub(c);
  Future<void> eliminarClubLocalmente(int id) async => await db.eliminarClubLocalmente(id);

  // JUGADORES
  Future<int> insertarJugador(Map<String, dynamic> j) async => await db.insertarJugador(j);
  Future<List<Map<String, dynamic>>> obtenerTodosLosJugadores() async => await db.obtenerTodosLosJugadores();
  Future<List<Map<String, dynamic>>> obtenerJugadoresPendientes() async => await db.obtenerJugadoresPendientes();
  Future<int> actualizarJugador(Map<String, dynamic> j) async => await db.actualizarJugador(j);
  Future<void> eliminarJugadorLocalmente(int id) async => await db.eliminarJugadorLocalmente(id);

  // DISCIPLINAS
  Future<int> insertarDisciplina(Map<String, dynamic> d) async => await db.insertarDisciplina(d);
  Future<List<Map<String, dynamic>>> obtenerTodasLasDisciplinas() async => await db.obtenerTodasLasDisciplinas();
  Future<List<Map<String, dynamic>>> obtenerDisciplinasPendientes() async => await db.obtenerDisciplinasPendientes();
  Future<int> actualizarDisciplina(Map<String, dynamic> d) async => await db.actualizarDisciplina(d);
  Future<void> eliminarDisciplinaLocalmente(int id) async => await db.eliminarDisciplinaLocalmente(id);

  // CATEGORÍAS
  Future<int> insertarCategoria(Map<String, dynamic> c) async => await db.insertarCategoria(c);
  Future<List<Map<String, dynamic>>> obtenerTodasLasCategorias() async => await db.obtenerTodasLasCategorias();
  Future<List<Map<String, dynamic>>> obtenerCategoriasPendientes() async => await db.obtenerCategoriasPendientes();
  Future<int> actualizarCategoria(Map<String, dynamic> c) async => await db.actualizarCategoria(c);
  Future<void> eliminarCategoriaLocalmente(int id) async => await db.eliminarCategoriaLocalmente(id);

  // ÁRBITROS
  Future<int> insertarArbitro(Map<String, dynamic> a) async => await db.insertarArbitro(a);
  Future<List<Map<String, dynamic>>> obtenerTodosLosArbitros() async => await db.obtenerTodosLosArbitros();
  Future<List<Map<String, dynamic>>> obtenerArbitrosPendientes() async => await db.obtenerArbitrosPendientes();
  Future<int> actualizarArbitro(Map<String, dynamic> a) async => await db.actualizarArbitro(a);
  Future<void> eliminarArbitroLocalmente(int id) async => await db.eliminarArbitroLocalmente(id);

  // TEMPORADAS
  Future<int> insertarTemporada(Map<String, dynamic> t) async => await db.insertarTemporada(t);
  Future<List<Map<String, dynamic>>> obtenerTodasLasTemporadas() async => await db.obtenerTodasLasTemporadas();
  Future<List<Map<String, dynamic>>> obtenerTemporadasPendientes() async => await db.obtenerTemporadasPendientes();
  Future<int> actualizarTemporada(Map<String, dynamic> t) async => await db.actualizarTemporada(t);
  Future<void> eliminarTemporadaLocalmente(int id) async => await db.eliminarTemporadaLocalmente(id);

  // PARTIDOS
  Future<int> insertarPartido(Map<String, dynamic> p) async => await db.insertarPartido(p);
  Future<List<Map<String, dynamic>>> obtenerTodosLosPartidos() async => await db.obtenerTodosLosPartidos();
  Future<List<Map<String, dynamic>>> obtenerPartidosPendientes() async => await db.obtenerPartidosPendientes();
  Future<int> actualizarPartido(Map<String, dynamic> p) async => await db.actualizarPartido(p);
  Future<void> eliminarPartidoLocalmente(int id) async => await db.eliminarPartidoLocalmente(id);

  // RESULTADOS
  Future<int> insertarResultado(Map<String, dynamic> r) async => await db.insertarResultado(r);
  Future<List<Map<String, dynamic>>> obtenerTodosLosResultados() async => await db.obtenerTodosLosResultados();
  Future<List<Map<String, dynamic>>> obtenerResultadosPendientes() async => await db.obtenerResultadosPendientes();
  Future<int> actualizarResultado(Map<String, dynamic> r) async => await db.actualizarResultado(r);
  Future<void> eliminarResultadoLocalmente(int id) async => await db.eliminarResultadoLocalmente(id);

  // TABLA POSICIONES
  Future<int> insertarTablaPosicion(Map<String, dynamic> t) async => await db.insertarTablaPosicion(t);
  Future<List<Map<String, dynamic>>> obtenerTodasLasTablaPosiciones() async => await db.obtenerTodasLasTablaPosiciones();
  Future<List<Map<String, dynamic>>> obtenerTablaPosicionesPendientes() async => await db.obtenerTablaPosicionesPendientes();
  Future<int> actualizarTablaPosicion(Map<String, dynamic> t) async => await db.actualizarTablaPosicion(t);
  Future<void> eliminarTablaPosicionLocalmente(int id) async => await db.eliminarTablaPosicionLocalmente(id);

  // OPERACIONES PENDIENTES
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

  Future<List<Map<String, dynamic>>> obtenerOperacionesPendientes() async => await db.obtenerOperacionesPendientes();
  Future<List<Map<String, dynamic>>> obtenerOperacionesListasParaReintentar() async => await db.obtenerOperacionesListasParaReintentar();
  Future<void> marcarComoCompletada(int id) async => await db.marcarComoCompletada(id);
  Future<void> registrarIntentoFallido(int id, {int? segundosEspera}) async => await db.registrarIntentoFallido(id, segundosEspera: segundosEspera);
  Future<Map<String, dynamic>?> obtenerPorIdUnico(String idUnico) async => await db.obtenerPorIdUnico(idUnico);
  Future<void> limpiarTodasLasOperaciones() async => await db.limpiarTodasLasOperaciones();
}