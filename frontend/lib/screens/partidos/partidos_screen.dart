import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/partido_provider.dart';
import '../../providers/categoria_provider.dart';
import '../../providers/club_provider.dart';
import '../../providers/temporada_provider.dart';
import '../../providers/arbitro_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/partido.dart';

class PartidosScreen extends StatefulWidget {
  const PartidosScreen({super.key});

  @override
  State<PartidosScreen> createState() => _PartidosScreenState();
}

class _PartidosScreenState extends State<PartidosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<PartidoProvider>().loadPartidos();
        context.read<CategoriaProvider>().loadCategorias();
        context.read<ClubProvider>().loadClubs();
        context.read<TemporadaProvider>().loadTemporadas();
        context.read<ArbitroProvider>().loadArbitros();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PartidoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Partidos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
              ? _buildError(context, provider)
              : provider.partidos.isEmpty
                  ? _buildEmpty(context)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: provider.partidos.length,
                      itemBuilder: (context, index) {
                        return _buildPartidoCard(context, provider.partidos[index]);
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearPartido,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildError(BuildContext context, PartidoProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Error', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 8),
            Text(provider.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: provider.loadPartidos, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('Sin datos', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(
              'No hay partidos registrados.\nPresiona el botón + para agregar uno.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartidoCard(BuildContext context, Partido partido) {
    final fecha = partido.fecha;
    final fechaStr = '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    final anio = partido.anioTemporada;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.red),
                const SizedBox(width: 6),
                Text(
                  '$fechaStr  •  ${partido.hora}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                if (anio != null)
                  Chip(
                    label: Text('$anio', style: const TextStyle(fontSize: 11)),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    partido.nombreClubLocal,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('vs', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                Expanded(
                  child: Text(
                    partido.nombreClubVisitante,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, partido.lugar),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.category, partido.nombreCategoria),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.sports, partido.nombreArbitro),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editarPartido(partido),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmarEliminacion(partido),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _crearPartido() async {
    if (!mounted) return;
    final provider = context.read<PartidoProvider>();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const _FormularioPartidoDialog(),
    );
    if (result == true && mounted) {
      await provider.loadPartidos();
    }
  }

  Future<void> _editarPartido(Partido partido) async {
    if (!mounted) return;
    final provider = context.read<PartidoProvider>();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _FormularioPartidoDialog(partido: partido),
    );
    if (result == true && mounted) {
      await provider.loadPartidos();
    }
  }

  void _confirmarEliminacion(Partido partido) {
    if (!mounted) return;
    final provider = context.read<PartidoProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar partido'),
        content: Text('¿Estás seguro de eliminar el partido entre "${partido.nombreClubLocal}" y "${partido.nombreClubVisitante}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final ok = await provider.deletePartido(partido.idPartido!);
              if (!mounted) return;
              if (ok) {
                await provider.loadPartidos();
                messenger.showSnackBar(
                  const SnackBar(content: Text('✅ Partido eliminado correctamente'), backgroundColor: Colors.green),
                );
              } else {
                messenger.showSnackBar(
                  SnackBar(content: Text(provider.errorMessage ?? 'Error al eliminar'), backgroundColor: colorScheme.error),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// DIÁLOGO DE FORMULARIO
// ============================================================

class _FormularioPartidoDialog extends StatefulWidget {
  final Partido? partido;
  const _FormularioPartidoDialog({this.partido});

  @override
  State<_FormularioPartidoDialog> createState() => _FormularioPartidoDialogState();
}

class _FormularioPartidoDialogState extends State<_FormularioPartidoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _horaController = TextEditingController();
  final _lugarController = TextEditingController();

  late DateTime _fecha;
  int? _idCategoria;
  int? _idClubLocal;
  int? _idClubVisitante;
  int? _idTemporada;
  int? _idArbitro;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.partido != null) {
      _fecha = widget.partido!.fecha;
      _horaController.text = widget.partido!.hora;
      _lugarController.text = widget.partido!.lugar;
      _idCategoria = widget.partido!.idCategoria;
      _idClubLocal = widget.partido!.idClubLocal;
      _idClubVisitante = widget.partido!.idClubVisitante;
      _idTemporada = widget.partido!.idTemporada;
      _idArbitro = widget.partido!.idArbitro;
    } else {
      _fecha = DateTime.now();
    }
  }

  @override
  void dispose() {
    _horaController.dispose();
    _lugarController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (fecha != null) {
      setState(() => _fecha = fecha);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idCategoria == null || _idClubLocal == null || _idClubVisitante == null || _idTemporada == null || _idArbitro == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_idClubLocal == _idClubVisitante) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El club local y visitante no pueden ser el mismo'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSaving = true);

    final authProvider = context.read<AuthProvider>();
    final provider = context.read<PartidoProvider>();

    final idUsuario = authProvider.usuario?.idUsuario;
    if (idUsuario == null) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo identificar al usuario'), backgroundColor: Colors.red),
      );
      return;
    }

    final partido = Partido(
      idPartido: widget.partido?.idPartido,
      fecha: _fecha,
      hora: _horaController.text.trim(),
      lugar: _lugarController.text.trim(),
      idCategoria: _idCategoria!,
      idClubLocal: _idClubLocal!,
      idClubVisitante: _idClubVisitante!,
      idTemporada: _idTemporada!,
      idArbitro: _idArbitro!,
      programadoPor: idUsuario,
    );

    bool ok;
    if (widget.partido == null) {
      ok = await provider.crearPartido(partido);
    } else {
      ok = await provider.actualizarPartido(widget.partido!.idPartido!, partido);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Error al guardar'), backgroundColor: Theme.of(context).colorScheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriaProvider = context.watch<CategoriaProvider>();
    final clubProvider = context.watch<ClubProvider>();
    final temporadaProvider = context.watch<TemporadaProvider>();
    final arbitroProvider = context.watch<ArbitroProvider>();

    return AlertDialog(
      title: Text(widget.partido == null ? 'Nuevo Partido' : 'Editar Partido'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fecha
                InkWell(
                  onTap: _seleccionarFecha,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    child: Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
                  ),
                ),
                const SizedBox(height: 12),

                // Hora
                TextFormField(
                  controller: _horaController,
                  decoration: const InputDecoration(
                    labelText: 'Hora (HH:MM)',
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                    hintText: '15:30',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'La hora es obligatoria';
                    if (!RegExp(r'^\d{1,2}:\d{2}$').hasMatch(v.trim())) return 'Formato inválido (HH:MM)';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Lugar
                TextFormField(
                  controller: _lugarController,
                  decoration: const InputDecoration(
                    labelText: 'Lugar',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'El lugar es obligatorio';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Categoría
                DropdownButtonFormField<int>(
                  // 🔥 CORREGIDO: initialValue
                  initialValue: _idCategoria,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: categoriaProvider.categorias.map((c) {
                    return DropdownMenuItem<int>(value: c.idCategoria, child: Text(c.nombre, overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (v) => setState(() => _idCategoria = v),
                  validator: (v) => v == null ? 'Selecciona una categoría' : null,
                ),
                const SizedBox(height: 12),

                // Club Local
                DropdownButtonFormField<int>(
                  // 🔥 CORREGIDO: initialValue
                  initialValue: _idClubLocal,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Club Local',
                    prefixIcon: Icon(Icons.sports),
                    border: OutlineInputBorder(),
                  ),
                  items: clubProvider.clubs.map((c) {
                    return DropdownMenuItem<int>(value: c.idClub, child: Text(c.nombre, overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (v) => setState(() => _idClubLocal = v),
                  validator: (v) => v == null ? 'Selecciona el club local' : null,
                ),
                const SizedBox(height: 12),

                // Club Visitante
                DropdownButtonFormField<int>(
                  // 🔥 CORREGIDO: initialValue
                  initialValue: _idClubVisitante,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Club Visitante',
                    prefixIcon: Icon(Icons.sports),
                    border: OutlineInputBorder(),
                  ),
                  items: clubProvider.clubs.map((c) {
                    return DropdownMenuItem<int>(value: c.idClub, child: Text(c.nombre, overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (v) => setState(() => _idClubVisitante = v),
                  validator: (v) => v == null ? 'Selecciona el club visitante' : null,
                ),
                const SizedBox(height: 12),

                // Temporada
                DropdownButtonFormField<int>(
                  // 🔥 CORREGIDO: initialValue
                  initialValue: _idTemporada,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Temporada',
                    prefixIcon: Icon(Icons.calendar_month),
                    border: OutlineInputBorder(),
                  ),
                  items: temporadaProvider.temporadas.map((t) {
                    return DropdownMenuItem<int>(value: t.idTemporada, child: Text('${t.anio}'));
                  }).toList(),
                  onChanged: (v) => setState(() => _idTemporada = v),
                  validator: (v) => v == null ? 'Selecciona una temporada' : null,
                ),
                const SizedBox(height: 12),

                // Árbitro
                DropdownButtonFormField<int>(
                  // 🔥 CORREGIDO: initialValue
                  initialValue: _idArbitro,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Árbitro',
                    prefixIcon: Icon(Icons.sports),
                    border: OutlineInputBorder(),
                  ),
                  items: arbitroProvider.arbitros.map((a) {
                    return DropdownMenuItem<int>(value: a.idArbitro, child: Text(a.nombre, overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (v) => setState(() => _idArbitro = v),
                  validator: (v) => v == null ? 'Selecciona un árbitro' : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _guardar,
          child: Text(_isSaving ? 'Guardando...' : 'Guardar'),
        ),
      ],
    );
  }
}