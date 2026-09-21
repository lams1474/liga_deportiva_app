import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../providers/club_provider.dart';
import '../../providers/sync_provider.dart';
import '../../models/club.dart';
import '../../database/app_dao.dart';
import '../../services/permission_service.dart';
import '../../services/backend_checker.dart';

class CrearClubScreen extends StatefulWidget {
  const CrearClubScreen({super.key});

  @override
  State<CrearClubScreen> createState() => _CrearClubScreenState();
}

class _CrearClubScreenState extends State<CrearClubScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _presidenteController = TextEditingController();
  late DateTime _fechaFundacion;
  bool _isSaving = false;

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
    _presidenteController.dispose();
    super.dispose();
  }

  Future<void> _obtenerUbicacion() async {
    final result = await PermissionService.solicitarUbicacion(context);

    switch (result) {
      case PermissionResult.granted:
        break;
      case PermissionResult.denied:
      case PermissionResult.permanentlyDenied:
      case PermissionResult.serviceDisabled:
        return;
    }

    setState(() => _cargandoUbicacion = true);

    try {
      // 🔥 CORREGIDO: usar LocationSettings en vez de desiredAccuracy
      final posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final precision = posicion.accuracy < 100 ? 'precisa' : 'aproximada';

      if (!mounted) return;
      setState(() {
        _latitud = posicion.latitude;
        _longitud = posicion.longitude;
        _precisionUbicacion = precision;
        _cargandoUbicacion = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('📍 Ubicación obtenida ($precision)'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargandoUbicacion = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error al obtener ubicación: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
          child: SingleChildScrollView(
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
                TextFormField(
                  controller: _presidenteController,
                  decoration: const InputDecoration(
                    labelText: 'Presidente',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El presidente es obligatorio';
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
                            onPressed: _cargandoUbicacion
                                ? null
                                : _obtenerUbicacion,
                            icon: _cargandoUbicacion
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
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

    // 🔥 CORREGIDO: capturar referencias ANTES de cualquier await
    final clubProvider = context.read<ClubProvider>();
    final syncProvider = context.read<SyncProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final club = Club(
      nombre: _nombreController.text.trim(),
      ciudad: _ciudadController.text.trim(),
      presidente: _presidenteController.text.trim(),
      fechaFundacion: _fechaFundacion,
      latitud: _latitud,
      longitud: _longitud,
      precisionUbicacion: _precisionUbicacion,
    );

    // 🔥 BackendChecker ya no depende del context
    final hasInternet = await BackendChecker.estaDisponible();

    bool ok;
    String? errorMsg;

    if (hasInternet) {
      try {
        ok = await clubProvider.crearClub(club);
        errorMsg = clubProvider.errorMessage;
      } catch (e) {
        ok = false;
        errorMsg = e.toString();
      }
    } else {
      try {
        final db = AppDao();
        await db.insertarClub({
          'nombre': club.nombre,
          'ciudad': club.ciudad,
          'presidente': club.presidente,
          'fecha_fundacion': club.fechaFundacion
              .toIso8601String()
              .split('T')
              .first,
          'latitud': club.latitud,
          'longitud': club.longitud,
          'precision_ubicacion': club.precisionUbicacion,
          'pendiente_envio': 1,
          'ultima_sincronizacion': null,
          'eliminado_local': 0,
        });

        await syncProvider.addPendingOperation(
          operacion: 'crear',
          entidad: 'club',
          datos: club.toJson(),
        );

        await clubProvider.loadClubs();
        ok = true;
      } catch (e) {
        ok = false;
        errorMsg = 'Error al guardar local: $e';
      }
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (ok) {
      // 🔥 Usar referencias capturadas
      scaffoldMessenger.showSnackBar(
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
      await clubProvider.loadClubs();
      navigator.pop(true);
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? '❌ Error al crear el club'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
