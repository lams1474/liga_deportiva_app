import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/club_provider.dart';
import 'providers/jugador_provider.dart';

// Services
import 'services/club_service.dart';
import 'services/jugador_service.dart';
import 'services/dio_config.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/clubes/clubes_screen.dart';
import 'screens/clubes/crear_club_screen.dart';
import 'screens/clubes/editar_club_screen.dart';
import 'screens/jugadores/jugadores_screen.dart';

// Theme
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.createDioWithInterceptors();
            return ClubProvider(ClubService(dio));
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final dio = DioConfig.createDio();
            return JugadorProvider(JugadorService(dio));
          },
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