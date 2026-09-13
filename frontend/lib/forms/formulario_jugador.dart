import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/jugador.dart';
import '../providers/jugador_provider.dart';
import '../providers/club_provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/sync_provider.dart';
import '../database/app_dao.dart';

class FormularioJugador extends StatefulWidget {
  final Jugador? jugador;
  final VoidCallback? onSuccess;

  const FormularioJugador({
    super.key,
    this.jugador,
    this.onSuccess,
  });

  @override
  State<FormularioJugador> createState() => _FormularioJugadorState();
}

class _FormularioJugadorState extends State<FormularioJugador> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _ciudadController = TextEditingController();
  late DateTime _fechaNacimiento;
  late int? _clubSeleccionado;
  bool _isSaving = false;
  bool _existeJugador = false;

  @override
  void initState() {
    super.initState();
    if (widget.jugador != null) {
      _cedulaController.text = widget.jugador!.cedula;
      _nombreController.text = widget.jugador!.nombre;
      _ciudadController.text = widget.jugador!.ciudad;
      _fechaNacimiento = widget.jugador!.fechaNacimiento;
      _clubSeleccionado = widget.jugador!.idClub;
    } else {
      _fechaNacimiento = DateTime.now().subtract(const Duration(days: 365 * 18));
      _clubSeleccionado = null;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clubProvider = context.read<ClubProvider>();
      if (clubProvider.clubs.isEmpty && !clubProvider.isLoading) {
        clubProvider.loadClubs();
      }
    });
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _ciudadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clubProvider = context.watch<ClubProvider>();

    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.jugador == null ? 'Nuevo Jugador' : 'Editar Jugador',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cedulaController,
                    decoration: const InputDecoration(
                      labelText: 'Número de cédula',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La cédula es obligatoria';
                      }
                      if (value.trim().length < 10) {
                        return 'La cédula debe tener al menos 10 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      if (value.trim().length < 3) {
                        return 'El nombre debe tener al menos 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ciudadController,
                    decoration: const InputDecoration(
                      labelText: 'Ciudad',
                      prefixIcon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La ciudad es obligatoria';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _seleccionarFecha,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Fecha de nacimiento',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_fechaNacimiento.day}/${_fechaNacimiento.month}/${_fechaNacimiento.year}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const Icon(Icons.arrow_drop_down, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _clubSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Club',
                      prefixIcon: Icon(Icons.sports),
                      border: OutlineInputBorder(),
                    ),
                    items: clubProvider.clubs.map((club) {
                      return DropdownMenuItem<int>(
                        value: club.idClub,
                        child: Text(club.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _clubSeleccionado = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Debes seleccionar un club';
                      }
                      return null;
                    },
                  ),
                  if (_existeJugador) ...[
                    const SizedBox(height: 8),
                    Text(
                      '⚠️ Ya existe un jugador con esta cédula en el club seleccionado',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _guardar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(_isSaving ? 'Guardando...' : 'Guardar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (fecha != null) {
      setState(() {
        _fechaNacimiento = fecha;
      });
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_clubSeleccionado == null) return;

    setState(() {
      _isSaving = true;
      _existeJugador = false;
    });

    final jugador = Jugador(
      idJugador: widget.jugador?.idJugador,
      cedula: _cedulaController.text.trim(),
      nombre: _nombreController.text.trim(),
      ciudad: _ciudadController.text.trim(),
      fechaNacimiento: _fechaNacimiento,
      idClub: _clubSeleccionado!,
    );

    // 🔥 Obtener providers ANTES de operaciones asíncronas
    final provider = context.read<JugadorProvider>();
    final connectivityProvider = context.read<ConnectivityProvider>();
    final syncProvider = context.read<SyncProvider>();

    final hasInternet = connectivityProvider.hasInternet;

    bool success = false;
    String? errorMensaje;

    try {
      if (hasInternet) {
        if (widget.jugador == null) {
          success = await provider.createJugador(jugador);
        } else {
          success = await provider.updateJugador(widget.jugador!.idJugador!, jugador);
        }
        errorMensaje = provider.errorMessage;
      } else {
        final db = AppDao();

        await db.insertarJugador({
          'cedula': jugador.cedula,
          'nombre': jugador.nombre,
          'ciudad': jugador.ciudad,
          'fecha_nacimiento': jugador.fechaNacimiento.toIso8601String().split('T').first,
          'id_club': jugador.idClub,
          'pendiente_envio': 1,
          'ultima_sincronizacion': null,
          'eliminado_local': 0,
        });

        await syncProvider.addPendingOperation(
          operacion: widget.jugador == null ? 'crear' : 'actualizar',
          entidad: 'jugador',
          datos: jugador.toJson(),
        );

        await provider.loadJugadores();

        success = true;
      }
    } catch (e) {
      success = false;
      errorMensaje = e.toString();
    }

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hasInternet
                ? '✅ Jugador guardado exitosamente'
                : '📱 Jugador guardado localmente (se sincronizará automáticamente)',
          ),
          backgroundColor: hasInternet ? Colors.green : Colors.orange,
        ),
      );
      widget.onSuccess?.call();
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMensaje ?? 'Error al guardar'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}