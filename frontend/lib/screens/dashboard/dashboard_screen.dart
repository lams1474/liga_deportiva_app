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
    // 🔥 Verificar autenticación al cargar Dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (!authProvider.isAuthenticated) {
        print('⚠️ No hay token en Dashboard, redirigiendo a login');
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    // 🔥 Si no está autenticado, mostrar carga mientras redirige
    if (!authProvider.isAuthenticated) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Verificando sesión...'),
            ],
          ),
        ),
      );
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
                      onTap: () {
                        Navigator.pushNamed(context, '/clubes');
                      },
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.person,
                      label: 'Jugadores',
                      color: Colors.green,
                      onTap: () {
                        Navigator.pushNamed(context, '/jugadores');
                      },
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.sports_baseball,
                      label: 'Disciplinas',
                      color: Colors.orange,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Módulo en desarrollo'),
                          ),
                        );
                      },
                    ),
                    _buildModuleCard(
                      context,
                      icon: Icons.calendar_today,
                      label: 'Partidos',
                      color: Colors.purple,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Módulo en desarrollo'),
                          ),
                        );
                      },
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}