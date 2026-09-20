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

import 'services/club_service.dart';
import 'services/jugador_service.dart';
import 'services/dio_config.dart';

import 'database/app_dao.dart';

import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/clubes/clubes_screen.dart';
import 'screens/clubes/crear_club_screen.dart';
import 'screens/clubes/editar_club_screen.dart';
import 'screens/jugadores/jugadores_screen.dart';
import 'screens/jugadores/editar_jugador_screen.dart';

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
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ruta no encontrada: ${settings.name}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
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