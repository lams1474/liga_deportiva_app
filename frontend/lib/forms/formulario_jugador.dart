import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/jugador.dart';
import '../providers/jugador_provider.dart';
import '../providers/club_provider.dart';
import '../widgets/app_button.dart';

class FormularioJugador extends StatefulWidget {
  final Jugador? jugador;
  final VoidCallback onSuccess;

  const FormularioJugador({
    super.key,
    this.jugador,
    required this.onSuccess,
  });

  @override
  State<FormularioJugador> createState() => _FormularioJugadorState();
}

class _FormularioJugadorState extends State<FormularioJugador> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ciudadController = TextEditingController();
  late DateTime _fechaNacimiento;
  late int? _clubSeleccionado;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.jugador != null) {
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
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person),
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
                    ),
                    child: Text(
                      '${_fechaNacimiento.day}/${_fechaNacimiento.month}/${_fechaNacimiento.year}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _clubSeleccionado,  // ← Cambiado de value a initialValue
                  decoration: const InputDecoration(
                    labelText: 'Club',
                    prefixIcon: Icon(Icons.sports),
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Cancelar',
                        onPressed: () => Navigator.pop(context),
                        variant: ButtonVariant.outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppButton(
                        label: _isSaving ? 'Guardando...' : 'Guardar',
                        onPressed: _isSaving ? null : _guardar,
                        variant: ButtonVariant.primary,
                        isLoading: _isSaving,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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

    setState(() => _isSaving = true);

    final jugador = Jugador(
      idJugador: widget.jugador?.idJugador,
      nombre: _nombreController.text.trim(),
      ciudad: _ciudadController.text.trim(),
      fechaNacimiento: _fechaNacimiento,
      idClub: _clubSeleccionado!,
    );

    final provider = context.read<JugadorProvider>();
    bool success;

    if (widget.jugador == null) {
      success = await provider.createJugador(jugador);
    } else {
      success = await provider.updateJugador(widget.jugador!.idJugador!, jugador);
    }

    setState(() => _isSaving = false);

    if (success && mounted) {
      widget.onSuccess();
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Error al guardar'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}