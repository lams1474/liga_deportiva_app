import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../providers/club_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/sync_provider.dart';
import '../../models/club.dart';
import '../../database/app_dao.dart';
import '../../services/permission_service.dart';

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

  // NUEVO: Campos de ubicación
  double? _latitud;
  double? _longitud;
  String? _precisionUbicacion;
  bool _cargandoUbicacion = false;

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

  // NUEVO: Obtener ubicación del club
  Future<void> _obtenerUbicacion() async {
    // 1. Solicitar permiso con explicación previa
    final ok = await PermissionService.solicitarUbicacion(context);
    if (!ok) return;

    setState(() => _cargandoUbicacion = true);

    try {
      // 2. Verificar que el servicio de ubicación esté activo
      final servicioActivo = await Geolocator.isLocationServiceEnabled();
      if (!servicioActivo) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El servicio de ubicación está desactivado. Actívelo en los ajustes del dispositivo.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        setState(() => _cargandoUbicacion = false);
        return;
      }

      // 3. Obtener la posición actual
      final posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. Determinar si es precisa o aproximada
      final precision = posicion.accuracy < 100 ? 'precisa' : 'aproximada';

      setState(() {
        _latitud = posicion.latitude;
        _longitud = posicion.longitude;
        _precisionUbicacion = precision;
        _cargandoUbicacion = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📍 Ubicación obtenida ($precision)'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _cargandoUbicacion = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al obtener ubicación: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
              const SizedBox(height: 16),

              // NUEVO: Sección de ubicación
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _latitud == null
                                  ? 'Sin ubicación registrada'
                                  : 'Lat: ${_latitud!.toStringAsFixed(6)}\n'
                                    'Lng: ${_longitud!.toStringAsFixed(6)}\n'
                                    'Precisión: $_precisionUbicacion',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _cargandoUbicacion ? null : _obtenerUbicacion,
                          icon: _cargandoUbicacion
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.my_location),
                          label: Text(
                            _cargandoUbicacion
                                ? 'Obteniendo...'
                                : 'Obtener ubicación',
                          ),
                        ),
                      ),
                    ],
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
      latitud: _latitud,                      // NUEVO
      longitud: _longitud,                    // NUEVO
      precisionUbicacion: _precisionUbicacion,// NUEVO
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
        'latitud': club.latitud,                     // NUEVO
        'longitud': club.longitud,                   // NUEVO
        'precision_ubicacion': club.precisionUbicacion, // NUEVO
        'pendiente_envio': 1,
        'ultima_sincronizacion': null,
        'eliminado_local': 0,
      });

      await syncProvider.addPendingOperation(
        operacion: 'crear',
        entidad: 'club',
        datos: club.toJson(),
      );

      final clubProvider = context.read<ClubProvider>();
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