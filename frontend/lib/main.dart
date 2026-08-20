import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'providers/auth_provider.dart';
import 'providers/club_provider.dart';
import 'screens/clubes/clubes_screen.dart';
import 'screens/clubes/crear_club_screen.dart';

import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ClubProvider(),
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

      initialRoute: "/",

      routes: {
        "/": (context) => const LoginScreen(),
        "/dashboard": (context) => const DashboardScreen(),
        "/clubes": (context) => const ClubesScreen(),
        "/clubes/crear": (context) => const CrearClubScreen(),
      },
    );
  }
}