import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/club_provider.dart';
import '../../models/club.dart';

class EditarClubScreen extends StatefulWidget {
  const EditarClubScreen({super.key});

  @override
  State<EditarClubScreen> createState() => _EditarClubScreenState();
}

class _EditarClubScreenState extends State<EditarClubScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ciudadController = TextEditingController();
  late DateTime _fechaFundacion;
  late int _clubId;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  bool _datosCargados = false;

  @override
  void initState() {
    super.initState();
    // Inicializar fecha por defecto
    _fechaFundacion = DateTime.now();
    _clubId = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🔥 CORREGIDO: Cargar los datos aquí, después de que el contexto esté listo
    if (!_datosCargados) {
      _cargarClub();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _ciudadController.dispose();
    super.dispose();
  }

  Future<void> _cargarClub() async {
    try {
      // Obtener el ID de los argumentos de la ruta
      final args = ModalRoute.of(context)?.settings.arguments;
      
      if (args == null) {
        setState(() {
          _errorMessage = 'No se recibió el ID del club';
          _isLoading = false;
          _datosCargados = true;
        });
        return;
      }

      // Verificar que el argumento sea un int
      if (args is! int) {
        setState(() {
          _errorMessage = 'El ID del club no es válido';
          _isLoading = false;
          _datosCargados = true;
        });
        return;
      }

      _clubId = args;
      
      // 🔥 CORREGIDO: Primero cargar la lista de clubes si está vacía
      final provider = context.read<ClubProvider>();
      
      // Si la lista está vacía, cargar los clubes primero
      if (provider.clubs.isEmpty) {
        await provider.loadClubs();
      }
      
      // Buscar el club en el provider
      final club = provider.getClubById(_clubId);
      
      if (club != null) {
        _nombreController.text = club.nombre;
        _ciudadController.text = club.ciudad;
        _fechaFundacion = club.fechaFundacion;
      } else {
        // Si no está en la lista, intentar cargar todos los clubes y buscar de nuevo
        await provider.loadClubs();
        final clubReloaded = provider.getClubById(_clubId);
        if (clubReloaded != null) {
          _nombreController.text = clubReloaded.nombre;
          _ciudadController.text = clubReloaded.ciudad;
          _fechaFundacion = clubReloaded.fechaFundacion;
        } else {
          setState(() {
            _errorMessage = 'Club no encontrado';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar el club: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _datosCargados = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Estado de carga
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Club'),
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
              Text('Cargando club...'),
            ],
          ),
        ),
      );
    }

    // Estado de error
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Club'),
          backgroundColor: theme.colorScheme.primary,
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
                  'Error',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
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

    // Formulario de edición
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Club'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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

    try {
      final club = Club(
        idClub: _clubId,
        nombre: _nombreController.text.trim(),
        ciudad: _ciudadController.text.trim(),
        fechaFundacion: _fechaFundacion,
      );

      final ok = await context.read<ClubProvider>().actualizarClub(_clubId, club);

      setState(() => _isSaving = false);

      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Club actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        // Recargar la lista y volver
        await context.read<ClubProvider>().loadClubs();
        if (mounted) {
          Navigator.pop(context, true); // true indica que hubo cambios
        }
      } else if (mounted) {
        final errorMsg = context.read<ClubProvider>().errorMessage ?? 'Error al actualizar el club';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMsg'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}