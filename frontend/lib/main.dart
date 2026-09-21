import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

import 'providers/auth_provider.dart';
import 'providers/club_provider.dart';
import 'providers/jugador_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/disciplina_provider.dart';
import 'providers/categoria_provider.dart';
import 'providers/arbitro_provider.dart';
import 'providers/temporada_provider.dart';
import 'providers/partido_provider.dart';
import 'providers/resultado_provider.dart';
import 'providers/tabla_posiciones_provider.dart';

import 'services/club_service.dart';
import 'services/jugador_service.dart';
import 'services/dio_config.dart';
import 'services/disciplina_service.dart';
import 'services/categoria_service.dart';
import 'services/arbitro_service.dart';
import 'services/temporada_service.dart';
import 'services/partido_service.dart';
import 'services/resultado_service.dart';
import 'services/tabla_posiciones_service.dart';

import 'database/app_dao.dart';

import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/clubes/clubes_screen.dart';
import 'screens/clubes/crear_club_screen.dart';
import 'screens/clubes/editar_club_screen.dart';
import 'screens/jugadores/jugadores_screen.dart';
import 'screens/jugadores/editar_jugador_screen.dart';
import 'screens/disciplinas/disciplinas_screen.dart';
import 'screens/categorias/categorias_screen.dart';
import 'screens/arbitros/arbitros_screen.dart';
import 'screens/temporadas/temporadas_screen.dart';
import 'screens/partidos/partidos_screen.dart';
import 'screens/resultados/resultados_screen.dart';
import 'screens/tabla_posiciones/tabla_posiciones_screen.dart';

import 'theme/app_theme.dart';
import 'app_global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
    print('✅ sqflite configurado para web');
  }

  final appDao = AppDao();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.instance;
            return ClubProvider(ClubService(dio));
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.createDioWithInterceptors();
            return JugadorProvider(JugadorService(dio));
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.createDioWithInterceptors();
            return DisciplinaProvider(DisciplinaService(dio));
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.createDioWithInterceptors();
            return CategoriaProvider(CategoriaService(dio));
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.createDioWithInterceptors();
            return ArbitroProvider(ArbitroService(dio));
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.createDioWithInterceptors();
            return TemporadaProvider(TemporadaService(dio));
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.createDioWithInterceptors();
            return PartidoProvider(PartidoService(dio));
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.createDioWithInterceptors();
            return ResultadoProvider(ResultadoService(dio));
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.createDioWithInterceptors();
            return TablaPosicionesProvider(TablaPosicionesService(dio));
          },
        ),
        ChangeNotifierProvider(
          create: (context) => SyncProvider(
            appDao: appDao,
            clubProvider: context.read<ClubProvider>(),
            jugadorProvider: context.read<JugadorProvider>(),
          ),
        ),
      ],
      child: const LigaDeportivaApp(),
    ),
  );
}

class LigaDeportivaApp extends StatelessWidget {
  const LigaDeportivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Liga Deportiva Barrial',
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/clubes': (context) => const ClubesScreen(),
        '/clubes/crear': (context) => const CrearClubScreen(),
        '/clubes/editar': (context) => const EditarClubScreen(),
        '/jugadores': (context) => const JugadoresScreen(),
        '/jugadores/editar': (context) => const EditarJugadorScreen(),
        '/disciplinas': (context) => const DisciplinasScreen(),
        '/categorias': (context) => const CategoriasScreen(),
        '/arbitros': (context) => const ArbitrosScreen(),
        '/temporadas': (context) => const TemporadasScreen(),
        '/partidos': (context) => const PartidosScreen(),
        '/resultados': (context) => const ResultadosScreen(),
        '/tabla-posiciones': (context) => const TablaPosicionesScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Ruta no encontrada: ${settings.name}', style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                    child: const Text('Ir al inicio'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}