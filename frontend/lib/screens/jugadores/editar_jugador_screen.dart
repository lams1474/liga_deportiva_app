import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/jugador_provider.dart';
import '../../models/jugador.dart';
import '../../forms/formulario_jugador.dart';

class EditarJugadorScreen extends StatefulWidget {
  const EditarJugadorScreen({super.key});

  @override
  State<EditarJugadorScreen> createState() => _EditarJugadorScreenState();
}

class _EditarJugadorScreenState extends State<EditarJugadorScreen> {
  late int _jugadorId;
  bool _isLoading = true;
  String? _errorMessage;
  Jugador? _jugador;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is int) {
      _jugadorId = args;
      _cargarJugador();
    } else {
      setState(() {
        _errorMessage = 'ID de jugador no válido';
        _isLoading = false;
      });
    }
  }

  Future<void> _cargarJugador() async {
    try {
      final provider = context.read<JugadorProvider>();
      
      if (provider.jugadores.isEmpty) {
        await provider.loadJugadores();
      }
      
      final jugador = provider.getJugadorById(_jugadorId);
      if (jugador != null) {
        setState(() {
          _jugador = jugador;
          _isLoading = false;
        });
      } else {
        await provider.loadJugadores();
        final reloaded = provider.getJugadorById(_jugadorId);
        if (reloaded != null) {
          setState(() {
            _jugador = reloaded;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Jugador no encontrado';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Jugador'),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando jugador...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: theme.colorScheme.error,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Jugador'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FormularioJugador(
        jugador: _jugador,
        onSuccess: () {
          context.read<JugadorProvider>().loadJugadores();
          Navigator.pop(context, true);
        },
      ),
    );
  }
}