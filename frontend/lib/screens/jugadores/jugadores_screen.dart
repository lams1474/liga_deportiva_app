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
      if (!mounted) return;
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
                          onTap: () {},
                          onEdit: () => _editarJugador(jugador),
                          onDelete: () => _confirmarEliminacion(jugador),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearJugador,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // 🔥 CORREGIDO: capturar el provider ANTES de mostrar el bottom sheet
  Future<void> _crearJugador() async {
    if (!mounted) return;
    final jugadorProvider = context.read<JugadorProvider>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: FormularioJugador(
          onSuccess: () {
            // 🔥 Usar la referencia capturada, no el context del sheet
            jugadorProvider.loadJugadores();
          },
        ),
      ),
    );
  }

  // 🔥 CORREGIDO: capturar el provider ANTES de navegar
  Future<void> _editarJugador(Jugador jugador) async {
    if (!mounted) return;
    final jugadorProvider = context.read<JugadorProvider>();

    final result = await Navigator.pushNamed(
      context,
      '/jugadores/editar',
      arguments: jugador.idJugador,
    );

    if (result == true && mounted) {
      await jugadorProvider.loadJugadores();
    }
  }

  // 🔥 CORREGIDO: capturar el provider ANTES de mostrar el diálogo
  void _confirmarEliminacion(Jugador jugador) {
    if (!mounted) return;
    final jugadorProvider = context.read<JugadorProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar jugador'),
        content: Text('¿Estás seguro de eliminar a ${jugador.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              final ok = await jugadorProvider.deleteJugador(jugador.idJugador!);

              if (!mounted) return;

              if (ok) {
                await jugadorProvider.loadJugadores();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('✅ Jugador eliminado correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      jugadorProvider.errorMessage ?? 'Error al eliminar',
                    ),
                    backgroundColor: colorScheme.error,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}