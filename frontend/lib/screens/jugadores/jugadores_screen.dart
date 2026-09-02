import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/jugador_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/jugador_card.dart';
import '../../models/jugador.dart';
import '../../forms/formulario_jugador.dart';

class JugadoresScreen extends StatefulWidget {
  const JugadoresScreen({super.key});

  @override
  State<JugadoresScreen> createState() => _JugadoresScreenState();
}

class _JugadoresScreenState extends State<JugadoresScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<JugadorProvider>().loadJugadores();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final jugadorProvider = context.watch<JugadorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugadores'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: jugadorProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : jugadorProvider.errorMessage != null
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
                          jugadorProvider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: jugadorProvider.loadJugadores,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : jugadorProvider.jugadores.isEmpty
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
                              'No hay jugadores registrados.\nPresiona el botón + para agregar uno.',
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
                      itemCount: jugadorProvider.jugadores.length,
                      itemBuilder: (context, index) {
                        final jugador = jugadorProvider.jugadores[index];
                        return JugadorCard(
                          jugador: jugador,
                          onTap: () {
                            // Navegar a detalle (opcional)
                          },
                          onEdit: () {
                            Navigator.pushNamed(
                              context,
                              '/jugadores/editar',
                              arguments: jugador.idJugador,
                            ).then((result) {
                              if (result == true && mounted) {
                                context.read<JugadorProvider>().loadJugadores();
                              }
                            });
                          },
                          onDelete: () {
                            _confirmarEliminacion(context, jugador);
                          },
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormulario(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarFormulario(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FormularioJugador(
          onSuccess: () {
            context.read<JugadorProvider>().loadJugadores();
          },
        ),
      ),
    );
  }

  void _confirmarEliminacion(BuildContext context, Jugador jugador) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar jugador'),
        content: Text('¿Estás seguro de eliminar a ${jugador.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 🔥 CORREGIDO: solo se pasa el ID
              context.read<JugadorProvider>().deleteJugador(jugador.idJugador!);
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