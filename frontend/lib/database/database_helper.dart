import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // 🔥 Versión actual de la BD local
  static const int _dbVersion = 8;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      return await openDatabase(
        inMemoryDatabasePath,
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'liga_deportiva.db');
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ============================================================
  // CREACIÓN INICIAL
  // ============================================================
  Future<void> _onCreate(Database db, int version) async {
    // Tabla de CLUBES
    await db.execute('''
      CREATE TABLE clubes (
        id_club INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        ciudad TEXT NOT NULL,
        presidente TEXT,
        fecha_fundacion TEXT NOT NULL,
        latitud REAL,
        longitud REAL,
        precision_ubicacion TEXT,
        ultima_sincronizacion TEXT,
        pendiente_envio INTEGER DEFAULT 0,
        eliminado_local INTEGER DEFAULT 0,
        id_unico_cliente TEXT
      )
    ''');

    // Tabla de JUGADORES
    await db.execute('''
      CREATE TABLE jugadores (
        id_jugador INTEGER PRIMARY KEY AUTOINCREMENT,
        cedula TEXT NOT NULL,
        nombre TEXT NOT NULL,
        ciudad TEXT NOT NULL,
        fecha_nacimiento TEXT NOT NULL,
        id_club INTEGER NOT NULL,
        foto_path TEXT,
        ultima_sincronizacion TEXT,
        pendiente_envio INTEGER DEFAULT 0,
        eliminado_local INTEGER DEFAULT 0,
        id_unico_cliente TEXT
      )
    ''');

    // Tabla de DISCIPLINAS
    await db.execute('''
      CREATE TABLE disciplinas (
        id_disciplina INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        ultima_sincronizacion TEXT,
        pendiente_envio INTEGER DEFAULT 0,
        eliminado_local INTEGER DEFAULT 0,
        id_unico_cliente TEXT
      )
    ''');

    // Tabla de CATEGORÍAS
    await db.execute('''
      CREATE TABLE categorias (
        id_categoria INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        id_disciplina INTEGER NOT NULL,
        ultima_sincronizacion TEXT,
        pendiente_envio INTEGER DEFAULT 0,
        eliminado_local INTEGER DEFAULT 0,
        id_unico_cliente TEXT
      )
    ''');

    // Tabla de ÁRBITROS
    await db.execute('''
      CREATE TABLE arbitros (
        id_arbitro INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        categoria TEXT NOT NULL,
        ultima_sincronizacion TEXT,
        pendiente_envio INTEGER DEFAULT 0,
        eliminado_local INTEGER DEFAULT 0,
        id_unico_cliente TEXT
      )
    ''');

    // Tabla de TEMPORADAS
    await db.execute('''
      CREATE TABLE temporadas (
        id_temporada INTEGER PRIMARY KEY AUTOINCREMENT,
        anio INTEGER NOT NULL,
        ultima_sincronizacion TEXT,
        pendiente_envio INTEGER DEFAULT 0,
        eliminado_local INTEGER DEFAULT 0,
        id_unico_cliente TEXT
      )
    ''');

    // Tabla de PARTIDOS
    await db.execute('''
      CREATE TABLE partidos (
        id_partido INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL,
        hora TEXT NOT NULL,
        lugar TEXT NOT NULL,
        id_categoria INTEGER NOT NULL,
        id_club_local INTEGER NOT NULL,
        id_club_visitante INTEGER NOT NULL,
        id_temporada INTEGER NOT NULL,
        id_arbitro INTEGER NOT NULL,
        programado_por INTEGER NOT NULL,
        ultima_sincronizacion TEXT,
        pendiente_envio INTEGER DEFAULT 0,
        eliminado_local INTEGER DEFAULT 0,
        id_unico_cliente TEXT
      )
    ''');

    // Tabla de RESULTADOS
    await db.execute('''
      CREATE TABLE resultados (
        id_resultado INTEGER PRIMARY KEY AUTOINCREMENT,
        id_partido INTEGER NOT NULL,
        marcador_local INTEGER,
        marcador_visitante INTEGER,
        registrado_por INTEGER NOT NULL,
        ultima_sincronizacion TEXT,
        pendiente_envio INTEGER DEFAULT 0,
        eliminado_local INTEGER DEFAULT 0,
        id_unico_cliente TEXT
      )
    ''');

    // Tabla de TABLA_POSICIONES
    await db.execute('''
      CREATE TABLE tabla_posiciones (
        id_posicion INTEGER PRIMARY KEY AUTOINCREMENT,
        id_temporada INTEGER NOT NULL,
        id_club INTEGER NOT NULL,
        puntos INTEGER DEFAULT 0,
        pj INTEGER DEFAULT 0,
        pg INTEGER DEFAULT 0,
        pe INTEGER DEFAULT 0,
        pp INTEGER DEFAULT 0,
        gf INTEGER DEFAULT 0,
        gc INTEGER DEFAULT 0,
        ultima_sincronizacion TEXT,
        pendiente_envio INTEGER DEFAULT 0,
        eliminado_local INTEGER DEFAULT 0,
        id_unico_cliente TEXT
      )
    ''');

    // Tabla de OPERACIONES PENDIENTES
    await db.execute('''
      CREATE TABLE operaciones_pendientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operacion TEXT NOT NULL,
        entidad TEXT NOT NULL,
        datos TEXT NOT NULL,
        id_unico_cliente TEXT NOT NULL,
        intentos INTEGER DEFAULT 0,
        fecha_creacion TEXT NOT NULL,
        proximo_intento TEXT
      )
    ''');
  }

  // ============================================================
  // MIGRACIONES
  // ============================================================
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try { await db.execute('ALTER TABLE clubes ADD COLUMN presidente TEXT'); } catch (_) {}
      try { await db.execute('ALTER TABLE clubes ADD COLUMN latitud REAL'); } catch (_) {}
      try { await db.execute('ALTER TABLE clubes ADD COLUMN longitud REAL'); } catch (_) {}
      try { await db.execute('ALTER TABLE clubes ADD COLUMN precision_ubicacion TEXT'); } catch (_) {}
      try { await db.execute('ALTER TABLE jugadores ADD COLUMN foto_path TEXT'); } catch (_) {}
    }
    if (oldVersion < 3) {
      await db.execute('''CREATE TABLE IF NOT EXISTS disciplinas (id_disciplina INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, ultima_sincronizacion TEXT, pendiente_envio INTEGER DEFAULT 0, eliminado_local INTEGER DEFAULT 0, id_unico_cliente TEXT)''');
    }
    if (oldVersion < 4) {
      await db.execute('''CREATE TABLE IF NOT EXISTS categorias (id_categoria INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, id_disciplina INTEGER NOT NULL, ultima_sincronizacion TEXT, pendiente_envio INTEGER DEFAULT 0, eliminado_local INTEGER DEFAULT 0, id_unico_cliente TEXT)''');
    }
    if (oldVersion < 5) {
      await db.execute('''CREATE TABLE IF NOT EXISTS arbitros (id_arbitro INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT NOT NULL, categoria TEXT NOT NULL, ultima_sincronizacion TEXT, pendiente_envio INTEGER DEFAULT 0, eliminado_local INTEGER DEFAULT 0, id_unico_cliente TEXT)''');
      await db.execute('''CREATE TABLE IF NOT EXISTS temporadas (id_temporada INTEGER PRIMARY KEY AUTOINCREMENT, anio INTEGER NOT NULL, ultima_sincronizacion TEXT, pendiente_envio INTEGER DEFAULT 0, eliminado_local INTEGER DEFAULT 0, id_unico_cliente TEXT)''');
    }
    if (oldVersion < 6) {
      await db.execute('''CREATE TABLE IF NOT EXISTS partidos (id_partido INTEGER PRIMARY KEY AUTOINCREMENT, fecha TEXT NOT NULL, hora TEXT NOT NULL, lugar TEXT NOT NULL, id_categoria INTEGER NOT NULL, id_club_local INTEGER NOT NULL, id_club_visitante INTEGER NOT NULL, id_temporada INTEGER NOT NULL, id_arbitro INTEGER NOT NULL, programado_por INTEGER NOT NULL, ultima_sincronizacion TEXT, pendiente_envio INTEGER DEFAULT 0, eliminado_local INTEGER DEFAULT 0, id_unico_cliente TEXT)''');
    }
    if (oldVersion < 7) {
      await db.execute('''CREATE TABLE IF NOT EXISTS resultados (id_resultado INTEGER PRIMARY KEY AUTOINCREMENT, id_partido INTEGER NOT NULL, marcador_local INTEGER, marcador_visitante INTEGER, registrado_por INTEGER NOT NULL, ultima_sincronizacion TEXT, pendiente_envio INTEGER DEFAULT 0, eliminado_local INTEGER DEFAULT 0, id_unico_cliente TEXT)''');
    }
    if (oldVersion < 8) {
      await db.execute('''CREATE TABLE IF NOT EXISTS tabla_posiciones (id_posicion INTEGER PRIMARY KEY AUTOINCREMENT, id_temporada INTEGER NOT NULL, id_club INTEGER NOT NULL, puntos INTEGER DEFAULT 0, pj INTEGER DEFAULT 0, pg INTEGER DEFAULT 0, pe INTEGER DEFAULT 0, pp INTEGER DEFAULT 0, gf INTEGER DEFAULT 0, gc INTEGER DEFAULT 0, ultima_sincronizacion TEXT, pendiente_envio INTEGER DEFAULT 0, eliminado_local INTEGER DEFAULT 0, id_unico_cliente TEXT)''');
    }
  }

  // ============================================================
  // LIMPIAR
  // ============================================================
  Future<void> limpiarTodaLaBaseDeDatos() async {
    final db = await database;
    await db.delete('clubes');
    await db.delete('jugadores');
    await db.delete('disciplinas');
    await db.delete('categorias');
    await db.delete('arbitros');
    await db.delete('temporadas');
    await db.delete('partidos');
    await db.delete('resultados');
    await db.delete('tabla_posiciones');
    await db.delete('operaciones_pendientes');
  }

  // CLUBES
  Future<int> insertarClub(Map<String, dynamic> c) async => await (await database).insert('clubes', c);
  Future<List<Map<String, dynamic>>> obtenerTodosLosClubes() async => await (await database).query('clubes', where: 'eliminado_local = 0');
  Future<List<Map<String, dynamic>>> obtenerClubesPendientes() async => await (await database).query('clubes', where: 'pendiente_envio = 1');
  Future<int> actualizarClub(Map<String, dynamic> c) async => await (await database).update('clubes', c, where: 'id_club = ?', whereArgs: [c['id_club']]);
  Future<void> eliminarClubLocalmente(int id) async => await (await database).update('clubes', {'eliminado_local': 1, 'pendiente_envio': 1}, where: 'id_club = ?', whereArgs: [id]);

  // JUGADORES
  Future<int> insertarJugador(Map<String, dynamic> j) async => await (await database).insert('jugadores', j);
  Future<List<Map<String, dynamic>>> obtenerTodosLosJugadores() async => await (await database).query('jugadores', where: 'eliminado_local = 0');
  Future<List<Map<String, dynamic>>> obtenerJugadoresPendientes() async => await (await database).query('jugadores', where: 'pendiente_envio = 1');
  Future<int> actualizarJugador(Map<String, dynamic> j) async => await (await database).update('jugadores', j, where: 'id_jugador = ?', whereArgs: [j['id_jugador']]);
  Future<void> eliminarJugadorLocalmente(int id) async => await (await database).update('jugadores', {'eliminado_local': 1, 'pendiente_envio': 1}, where: 'id_jugador = ?', whereArgs: [id]);

  // DISCIPLINAS
  Future<int> insertarDisciplina(Map<String, dynamic> d) async => await (await database).insert('disciplinas', d);
  Future<List<Map<String, dynamic>>> obtenerTodasLasDisciplinas() async => await (await database).query('disciplinas', where: 'eliminado_local = 0');
  Future<List<Map<String, dynamic>>> obtenerDisciplinasPendientes() async => await (await database).query('disciplinas', where: 'pendiente_envio = 1');
  Future<int> actualizarDisciplina(Map<String, dynamic> d) async => await (await database).update('disciplinas', d, where: 'id_disciplina = ?', whereArgs: [d['id_disciplina']]);
  Future<void> eliminarDisciplinaLocalmente(int id) async => await (await database).update('disciplinas', {'eliminado_local': 1, 'pendiente_envio': 1}, where: 'id_disciplina = ?', whereArgs: [id]);

  // CATEGORÍAS
  Future<int> insertarCategoria(Map<String, dynamic> c) async => await (await database).insert('categorias', c);
  Future<List<Map<String, dynamic>>> obtenerTodasLasCategorias() async => await (await database).query('categorias', where: 'eliminado_local = 0');
  Future<List<Map<String, dynamic>>> obtenerCategoriasPendientes() async => await (await database).query('categorias', where: 'pendiente_envio = 1');
  Future<int> actualizarCategoria(Map<String, dynamic> c) async => await (await database).update('categorias', c, where: 'id_categoria = ?', whereArgs: [c['id_categoria']]);
  Future<void> eliminarCategoriaLocalmente(int id) async => await (await database).update('categorias', {'eliminado_local': 1, 'pendiente_envio': 1}, where: 'id_categoria = ?', whereArgs: [id]);

  // ÁRBITROS
  Future<int> insertarArbitro(Map<String, dynamic> a) async => await (await database).insert('arbitros', a);
  Future<List<Map<String, dynamic>>> obtenerTodosLosArbitros() async => await (await database).query('arbitros', where: 'eliminado_local = 0');
  Future<List<Map<String, dynamic>>> obtenerArbitrosPendientes() async => await (await database).query('arbitros', where: 'pendiente_envio = 1');
  Future<int> actualizarArbitro(Map<String, dynamic> a) async => await (await database).update('arbitros', a, where: 'id_arbitro = ?', whereArgs: [a['id_arbitro']]);
  Future<void> eliminarArbitroLocalmente(int id) async => await (await database).update('arbitros', {'eliminado_local': 1, 'pendiente_envio': 1}, where: 'id_arbitro = ?', whereArgs: [id]);

  // TEMPORADAS
  Future<int> insertarTemporada(Map<String, dynamic> t) async => await (await database).insert('temporadas', t);
  Future<List<Map<String, dynamic>>> obtenerTodasLasTemporadas() async => await (await database).query('temporadas', where: 'eliminado_local = 0');
  Future<List<Map<String, dynamic>>> obtenerTemporadasPendientes() async => await (await database).query('temporadas', where: 'pendiente_envio = 1');
  Future<int> actualizarTemporada(Map<String, dynamic> t) async => await (await database).update('temporadas', t, where: 'id_temporada = ?', whereArgs: [t['id_temporada']]);
  Future<void> eliminarTemporadaLocalmente(int id) async => await (await database).update('temporadas', {'eliminado_local': 1, 'pendiente_envio': 1}, where: 'id_temporada = ?', whereArgs: [id]);

  // PARTIDOS
  Future<int> insertarPartido(Map<String, dynamic> p) async => await (await database).insert('partidos', p);
  Future<List<Map<String, dynamic>>> obtenerTodosLosPartidos() async => await (await database).query('partidos', where: 'eliminado_local = 0');
  Future<List<Map<String, dynamic>>> obtenerPartidosPendientes() async => await (await database).query('partidos', where: 'pendiente_envio = 1');
  Future<int> actualizarPartido(Map<String, dynamic> p) async => await (await database).update('partidos', p, where: 'id_partido = ?', whereArgs: [p['id_partido']]);
  Future<void> eliminarPartidoLocalmente(int id) async => await (await database).update('partidos', {'eliminado_local': 1, 'pendiente_envio': 1}, where: 'id_partido = ?', whereArgs: [id]);

  // RESULTADOS
  Future<int> insertarResultado(Map<String, dynamic> r) async => await (await database).insert('resultados', r);
  Future<List<Map<String, dynamic>>> obtenerTodosLosResultados() async => await (await database).query('resultados', where: 'eliminado_local = 0');
  Future<List<Map<String, dynamic>>> obtenerResultadosPendientes() async => await (await database).query('resultados', where: 'pendiente_envio = 1');
  Future<int> actualizarResultado(Map<String, dynamic> r) async => await (await database).update('resultados', r, where: 'id_resultado = ?', whereArgs: [r['id_resultado']]);
  Future<void> eliminarResultadoLocalmente(int id) async => await (await database).update('resultados', {'eliminado_local': 1, 'pendiente_envio': 1}, where: 'id_resultado = ?', whereArgs: [id]);

  // TABLA POSICIONES
  Future<int> insertarTablaPosicion(Map<String, dynamic> t) async => await (await database).insert('tabla_posiciones', t);
  Future<List<Map<String, dynamic>>> obtenerTodasLasTablaPosiciones() async => await (await database).query('tabla_posiciones', where: 'eliminado_local = 0');
  Future<List<Map<String, dynamic>>> obtenerTablaPosicionesPendientes() async => await (await database).query('tabla_posiciones', where: 'pendiente_envio = 1');
  Future<int> actualizarTablaPosicion(Map<String, dynamic> t) async => await (await database).update('tabla_posiciones', t, where: 'id_posicion = ?', whereArgs: [t['id_posicion']]);
  Future<void> eliminarTablaPosicionLocalmente(int id) async => await (await database).update('tabla_posiciones', {'eliminado_local': 1, 'pendiente_envio': 1}, where: 'id_posicion = ?', whereArgs: [id]);

  // OPERACIONES PENDIENTES
  Future<int> agregarOperacion({
    required String operacion,
    required String entidad,
    required String datos,
    required String idUnicoCliente,
  }) async {
    final db = await database;
    return await db.insert('operaciones_pendientes', {
      'operacion': operacion,
      'entidad': entidad,
      'datos': datos,
      'id_unico_cliente': idUnicoCliente,
      'intentos': 0,
      'fecha_creacion': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> obtenerOperacionesPendientes() async => await (await database).query('operaciones_pendientes', where: 'proximo_intento IS NULL');

  Future<List<Map<String, dynamic>>> obtenerOperacionesListasParaReintentar() async {
    final db = await database;
    final ahora = DateTime.now().toIso8601String();
    return await db.query('operaciones_pendientes', where: 'proximo_intento IS NULL OR proximo_intento <= ?', whereArgs: [ahora]);
  }

  Future<void> marcarComoCompletada(int id) async => await (await database).delete('operaciones_pendientes', where: 'id = ?', whereArgs: [id]);

  Future<void> registrarIntentoFallido(int id, {int? segundosEspera}) async {
    final db = await database;
    final operacion = await db.query('operaciones_pendientes', where: 'id = ?', whereArgs: [id]);
    if (operacion.isEmpty) return;
    final intentos = (operacion.first['intentos'] as int? ?? 0) + 1;
    final espera = segundosEspera ?? (intentos * 2);
    final proximoIntento = DateTime.now().add(Duration(seconds: espera));
    await db.update('operaciones_pendientes', {'intentos': intentos, 'proximo_intento': proximoIntento.toIso8601String()}, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> obtenerPorIdUnico(String idUnico) async {
    final result = await (await database).query('operaciones_pendientes', where: 'id_unico_cliente = ?', whereArgs: [idUnico]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> limpiarTodasLasOperaciones() async => await (await database).delete('operaciones_pendientes');

  Future<void> close() async => await (await database).close();
}