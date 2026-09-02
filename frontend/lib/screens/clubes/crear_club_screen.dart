import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/club_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/sync_provider.dart';
import '../../models/club.dart';
import '../../database/app_dao.dart';

class CrearClubScreen extends StatefulWidget {
  const CrearClubScreen({super.key});

  @override
  State<CrearClubScreen> createState() => _CrearClubScreenState();
}

class _CrearClubScreenState extends State<CrearClubScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ciudadController = TextEditingController();
  late DateTime _fechaFundacion;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fechaFundacion = DateTime.now();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Club'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del club',
                  prefixIcon: Icon(Icons.sports),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
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
                    labelText: 'Fecha de fundación',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_fechaFundacion.day}/${_fechaFundacion.month}/${_fechaFundacion.year}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
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
      ),
    );
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaFundacion,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (fecha != null) {
      setState(() {
        _fechaFundacion = fecha;
      });
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final club = Club(
      nombre: _nombreController.text.trim(),
      ciudad: _ciudadController.text.trim(),
      fechaFundacion: _fechaFundacion,
    );

    final connectivityProvider = context.read<ConnectivityProvider>();
    final hasInternet = connectivityProvider.hasInternet;

    bool ok;

    if (hasInternet) {
      ok = await context.read<ClubProvider>().crearClub(club);
    } else {
      final syncProvider = context.read<SyncProvider>();
      
      final db = AppDao();
      await db.insertarClub({
        'nombre': club.nombre,
        'ciudad': club.ciudad,
        'fecha_fundacion': club.fechaFundacion.toIso8601String().split('T').first,
        'pendiente_envio': 1,
        'ultima_sincronizacion': null,
        'eliminado_local': 0,
      });

      await syncProvider.addPendingOperation(
        operacion: 'crear',
        entidad: 'club',
        datos: club.toJson(),
      );

      // 🔥 CORREGIDO: Usar método público para agregar a la lista
      final clubProvider = context.read<ClubProvider>();
      // Recargar la lista para mostrar el nuevo club
      await clubProvider.loadClubs();

      ok = true;
    }

    setState(() => _isSaving = false);

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hasInternet 
              ? '✅ Club creado exitosamente' 
              : '📱 Club guardado localmente (se sincronizará automáticamente)',
          ),
          backgroundColor: hasInternet ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      await context.read<ClubProvider>().loadClubs();
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Error al crear el club'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}