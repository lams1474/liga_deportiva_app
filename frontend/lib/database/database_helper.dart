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
  static const int _dbVersion = 2;

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
  // CREACIÓN INICIAL (instalaciones nuevas)
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
  // MIGRACIONES (cuando la versión sube)
  // ============================================================
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 🔥 v1 → v2: agregar presidente, latitud, longitud, precision_ubicacion y foto_path
    if (oldVersion < 2) {
      // Clubes
      try {
        await db.execute('ALTER TABLE clubes ADD COLUMN presidente TEXT');
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE clubes ADD COLUMN latitud REAL');
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE clubes ADD COLUMN longitud REAL');
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE clubes ADD COLUMN precision_ubicacion TEXT');
      } catch (_) {}

      // Jugadores
      try {
        await db.execute('ALTER TABLE jugadores ADD COLUMN foto_path TEXT');
      } catch (_) {}
    }
  }

  // ============================================================
  // LIMPIAR TODA LA BASE DE DATOS
  // ============================================================
  Future<void> limpiarTodaLaBaseDeDatos() async {
    final db = await database;
    await db.delete('clubes');
    await db.delete('jugadores');
    await db.delete('operaciones_pendientes');
  }

  // ============================================================
  // OPERACIONES CON CLUBES
  // ============================================================
  Future<int> insertarClub(Map<String, dynamic> club) async {
    final db = await database;
    return await db.insert('clubes', club);
  }

  Future<List<Map<String, dynamic>>> obtenerTodosLosClubes() async {
    final db = await database;
    return await db.query('clubes', where: 'eliminado_local = 0');
  }

  Future<List<Map<String, dynamic>>> obtenerClubesPendientes() async {
    final db = await database;
    return await db.query('clubes', where: 'pendiente_envio = 1');
  }

  Future<int> actualizarClub(Map<String, dynamic> club) async {
    final db = await database;
    return await db.update(
      'clubes',
      club,
      where: 'id_club = ?',
      whereArgs: [club['id_club']],
    );
  }

  Future<void> eliminarClubLocalmente(int id) async {
    final db = await database;
    await db.update(
      'clubes',
      {'eliminado_local': 1, 'pendiente_envio': 1},
      where: 'id_club = ?',
      whereArgs: [id],
    );
  }

  // ============================================================
  // OPERACIONES CON JUGADORES
  // ============================================================
  Future<int> insertarJugador(Map<String, dynamic> jugador) async {
    final db = await database;
    return await db.insert('jugadores', jugador);
  }

  Future<List<Map<String, dynamic>>> obtenerTodosLosJugadores() async {
    final db = await database;
    return await db.query('jugadores', where: 'eliminado_local = 0');
  }

  Future<List<Map<String, dynamic>>> obtenerJugadoresPendientes() async {
    final db = await database;
    return await db.query('jugadores', where: 'pendiente_envio = 1');
  }

  Future<int> actualizarJugador(Map<String, dynamic> jugador) async {
    final db = await database;
    return await db.update(
      'jugadores',
      jugador,
      where: 'id_jugador = ?',
      whereArgs: [jugador['id_jugador']],
    );
  }

  Future<void> eliminarJugadorLocalmente(int id) async {
    final db = await database;
    await db.update(
      'jugadores',
      {'eliminado_local': 1, 'pendiente_envio': 1},
      where: 'id_jugador = ?',
      whereArgs: [id],
    );
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

  Future<List<Map<String, dynamic>>> obtenerOperacionesPendientes() async {
    final db = await database;
    return await db.query(
      'operaciones_pendientes',
      where: 'proximo_intento IS NULL',
    );
  }

  Future<List<Map<String, dynamic>>> obtenerOperacionesListasParaReintentar() async {
    final db = await database;
    final ahora = DateTime.now().toIso8601String();
    return await db.query(
      'operaciones_pendientes',
      where: 'proximo_intento IS NULL OR proximo_intento <= ?',
      whereArgs: [ahora],
    );
  }

  Future<void> marcarComoCompletada(int id) async {
    final db = await database;
    await db.delete(
      'operaciones_pendientes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> registrarIntentoFallido(int id, {int? segundosEspera}) async {
    final db = await database;
    final operacion = await db.query(
      'operaciones_pendientes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (operacion.isEmpty) return;

    final intentos = (operacion.first['intentos'] as int? ?? 0) + 1;
    final espera = segundosEspera ?? (intentos * 2);
    final proximoIntento = DateTime.now().add(Duration(seconds: espera));

    await db.update(
      'operaciones_pendientes',
      {
        'intentos': intentos,
        'proximo_intento': proximoIntento.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> obtenerPorIdUnico(String idUnico) async {
    final db = await database;
    final result = await db.query(
      'operaciones_pendientes',
      where: 'id_unico_cliente = ?',
      whereArgs: [idUnico],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> limpiarTodasLasOperaciones() async {
    final db = await database;
    await db.delete('operaciones_pendientes');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}