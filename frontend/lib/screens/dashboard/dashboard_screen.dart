import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authProvider = context.read<AuthProvider>();
      if (!authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    if (!authProvider.isAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido, ${authProvider.usuario?.nombre ?? 'Usuario'}',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Rol: ${authProvider.usuario?.rol ?? 'Sin rol'}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              const Text(
                'Módulos disponibles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildModuleCard(
                      context,
                      icon: Icons.sports,
                      label: 'Clubes',
                      color: Colors.blue,
                      onTap: () => Navigator.pushNamed(context, '/clubes'),
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.person,
                      label: 'Jugadores',
                      color: Colors.green,
                      onTap: () => Navigator.pushNamed(context, '/jugadores'),
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.sports_baseball,
                      label: 'Disciplinas',
                      color: Colors.orange,
                      onTap: () => Navigator.pushNamed(context, '/disciplinas'),
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.category,
                      label: 'Categorías',
                      color: Colors.purple,
                      onTap: () => Navigator.pushNamed(context, '/categorias'),
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.sports,
                      label: 'Árbitros',
                      color: Colors.teal,
                      onTap: () => Navigator.pushNamed(context, '/arbitros'),
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.calendar_month,
                      label: 'Temporadas',
                      color: Colors.indigo,
                      onTap: () => Navigator.pushNamed(context, '/temporadas'),
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.calendar_today,
                      label: 'Partidos',
                      color: Colors.red,
                      onTap: () => Navigator.pushNamed(context, '/partidos'),
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.scoreboard,
                      label: 'Resultados',
                      color: Colors.amber,
                      onTap: () => Navigator.pushNamed(context, '/resultados'),
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.emoji_events,
                      label: 'Tabla Posiciones',
                      color: Colors.brown,
                      onTap: () => Navigator.pushNamed(context, '/tabla-posiciones'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}