import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/jugador_provider.dart';
import '../../widgets/jugador_card.dart';
import '../../widgets/async_state_view.dart';
import '../../forms/formulario_jugador.dart';
import '../../models/jugador.dart';

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
      context.read<JugadorProvider>().loadJugadores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugadores'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<JugadorProvider>(
        builder: (context, provider, child) {
          return AsyncStateView(
            isLoading: provider.isLoading,
            errorMessage: provider.errorMessage,
            isEmpty: provider.jugadores.isEmpty,
            emptyMessage: 'No hay jugadores registrados.\nPresiona el botón + para agregar uno.',
            onRetry: provider.loadJugadores,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.jugadores.length,
              itemBuilder: (context, index) {
                final jugador = provider.jugadores[index];
                return JugadorCard(
                  jugador: jugador,
                  onTap: () {
                    // Navegar a detalle (lo haremos después)
                  },
                  onEdit: () {
                    _mostrarFormulario(context, jugador: jugador);
                  },
                  onDelete: () {
                    _confirmarEliminacion(context, jugador);
                  },
                );
              },
            ),
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

  void _mostrarFormulario(BuildContext context, {Jugador? jugador}) {
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
          jugador: jugador,
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