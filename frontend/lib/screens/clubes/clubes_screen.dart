import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/club_provider.dart';
import '../../providers/auth_provider.dart'; // ← IMPORTANTE: Ya lo tienes
import '../../widgets/club_card.dart';
import '../../models/club.dart';

class ClubesScreen extends StatefulWidget {
  const ClubesScreen({super.key});

  @override
  State<ClubesScreen> createState() => _ClubesScreenState();
}

class _ClubesScreenState extends State<ClubesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<ClubProvider>().loadClubs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final clubProvider = context.watch<ClubProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clubes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: clubProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : clubProvider.errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          clubProvider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: clubProvider.loadClubs,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : clubProvider.clubs.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Sin datos',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No hay clubes registrados.\nPresiona el botón + para agregar uno.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: clubProvider.clubs.length,
                      itemBuilder: (context, index) {
                        final club = clubProvider.clubs[index];
                        return ClubCard(
                          club: club,
                          onTap: () {
                            // Navegar a detalle (opcional)
                          },
                          onEdit: () {
                            Navigator.pushNamed(
                              context,
                              '/clubes/editar',
                              arguments: club.idClub,
                            ).then((result) {
                              if (result == true && mounted) {
                                context.read<ClubProvider>().loadClubs();
                              }
                            });
                          },
                          onDelete: () {
                            _confirmarEliminacion(context, club);
                          },
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/clubes/crear').then((result) {
            if (result == true && mounted) {
              context.read<ClubProvider>().loadClubs();
            }
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmarEliminacion(BuildContext context, Club club) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar club'),
        content: Text('¿Estás seguro de eliminar ${club.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ClubProvider>().deleteClub(club.idClub!).then((_) {
                if (mounted) {
                  context.read<ClubProvider>().loadClubs();
                }
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}