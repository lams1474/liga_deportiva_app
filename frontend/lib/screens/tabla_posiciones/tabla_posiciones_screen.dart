import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tabla_posiciones_provider.dart';
import '../../providers/temporada_provider.dart';
import '../../providers/club_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/tabla_posiciones.dart';

class TablaPosicionesScreen extends StatefulWidget {
  const TablaPosicionesScreen({super.key});

  @override
  State<TablaPosicionesScreen> createState() => _TablaPosicionesScreenState();
}

class _TablaPosicionesScreenState extends State<TablaPosicionesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<TablaPosicionesProvider>().loadTabla();
        context.read<TemporadaProvider>().loadTemporadas();
        context.read<ClubProvider>().loadClubs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TablaPosicionesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Posiciones'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.loadTabla(),
            tooltip: 'Refrescar',
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
              ? _buildError(context, provider)
              : provider.posiciones.isEmpty
                  ? _buildEmpty(context)
                  : _buildTabla(context, provider.posiciones),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearPosicion,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildError(BuildContext context, TablaPosicionesProvider provider) {
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
            ElevatedButton(onPressed: provider.loadTabla, child: const Text('Reintentar')),
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
            Icon(Icons.emoji_events_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('Sin datos', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(
              'No hay registros en la tabla de posiciones.\nPresiona + para agregar uno.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabla(BuildContext context, List<TablaPosiciones> posiciones) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: const Row(
            children: [
              SizedBox(width: 30, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
              Expanded(flex: 4, child: Text('Club', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
              SizedBox(width: 30, child: Text('PJ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
              SizedBox(width: 30, child: Text('PG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
              SizedBox(width: 30, child: Text('PE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
              SizedBox(width: 30, child: Text('PP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
              SizedBox(width: 35, child: Text('GF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
              SizedBox(width: 35, child: Text('GC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center)),
              SizedBox(width: 40, child: Text('PTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green), textAlign: TextAlign.center)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: posiciones.length,
            itemBuilder: (context, index) {
              final pos = posiciones[index];
              return _buildFila(context, index + 1, pos);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFila(BuildContext context, int posicion, TablaPosiciones pos) {
    Color? colorFondo;
    if (posicion == 1) {
      colorFondo = Colors.amber.shade100;
    } else if (posicion == 2) {
      colorFondo = Colors.grey.shade300;
    } else if (posicion == 3) {
      colorFondo = Colors.brown.shade100;
    }

    return Container(
      color: colorFondo,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              '$posicion',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: posicion <= 3 ? Colors.black87 : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pos.nombreClub,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                if (pos.anioTemporada != null)
                  Text(
                    '${pos.anioTemporada}',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ),
          SizedBox(width: 30, child: Text('${pos.pj}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
          SizedBox(width: 30, child: Text('${pos.pg}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
          SizedBox(width: 30, child: Text('${pos.pe}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
          SizedBox(width: 30, child: Text('${pos.pp}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
          SizedBox(width: 35, child: Text('${pos.gf}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
          SizedBox(width: 35, child: Text('${pos.gc}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
          SizedBox(
            width: 40,
            child: Text(
              '${pos.puntos}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _crearPosicion() async {
    if (!mounted) return;
    final provider = context.read<TablaPosicionesProvider>();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const _FormularioPosicionDialog(),
    );
    if (result == true && mounted) {
      await provider.loadTabla();
    }
  }
}

// ============================================================
// DIÁLOGO DE FORMULARIO (solo crear)
// ============================================================

class _FormularioPosicionDialog extends StatefulWidget {
  const _FormularioPosicionDialog();

  @override
  State<_FormularioPosicionDialog> createState() => _FormularioPosicionDialogState();
}

class _FormularioPosicionDialogState extends State<_FormularioPosicionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _puntosController = TextEditingController();
  final _pjController = TextEditingController();
  final _pgController = TextEditingController();
  final _peController = TextEditingController();
  final _ppController = TextEditingController();
  final _gfController = TextEditingController();
  final _gcController = TextEditingController();

  int? _idTemporada;
  int? _idClub;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _puntosController.text = '0';
    _pjController.text = '0';
    _pgController.text = '0';
    _peController.text = '0';
    _ppController.text = '0';
    _gfController.text = '0';
    _gcController.text = '0';
  }

  @override
  void dispose() {
    _puntosController.dispose();
    _pjController.dispose();
    _pgController.dispose();
    _peController.dispose();
    _ppController.dispose();
    _gfController.dispose();
    _gcController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idTemporada == null || _idClub == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona temporada y club'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSaving = true);

    final provider = context.read<TablaPosicionesProvider>();

    final posicion = TablaPosiciones(
      idTemporada: _idTemporada!,
      idClub: _idClub!,
      puntos: int.tryParse(_puntosController.text.trim()) ?? 0,
      pj: int.tryParse(_pjController.text.trim()) ?? 0,
      pg: int.tryParse(_pgController.text.trim()) ?? 0,
      pe: int.tryParse(_peController.text.trim()) ?? 0,
      pp: int.tryParse(_ppController.text.trim()) ?? 0,
      gf: int.tryParse(_gfController.text.trim()) ?? 0,
      gc: int.tryParse(_gcController.text.trim()) ?? 0,
    );

    final ok = await provider.crearPosicion(posicion);

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
    final temporadaProvider = context.watch<TemporadaProvider>();
    final clubProvider = context.watch<ClubProvider>();

    return AlertDialog(
      title: const Text('Nueva Posición'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
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

                DropdownButtonFormField<int>(
                  initialValue: _idClub,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Club',
                    prefixIcon: Icon(Icons.sports),
                    border: OutlineInputBorder(),
                  ),
                  items: clubProvider.clubs.map((c) {
                    return DropdownMenuItem<int>(value: c.idClub, child: Text(c.nombre, overflow: TextOverflow.ellipsis));
                  }).toList(),
                  onChanged: (v) => setState(() => _idClub = v),
                  validator: (v) => v == null ? 'Selecciona un club' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _puntosController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Puntos',
                    prefixIcon: Icon(Icons.star),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => int.tryParse(v?.trim() ?? '') == null ? 'Número requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _pjController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Partidos Jugados (PJ)',
                    prefixIcon: Icon(Icons.sports),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => int.tryParse(v?.trim() ?? '') == null ? 'Número requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _pgController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Partidos Ganados (PG)',
                    prefixIcon: Icon(Icons.emoji_events),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => int.tryParse(v?.trim() ?? '') == null ? 'Número requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _peController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Partidos Empatados (PE)',
                    prefixIcon: Icon(Icons.handshake),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => int.tryParse(v?.trim() ?? '') == null ? 'Número requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _ppController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Partidos Perdidos (PP)',
                    prefixIcon: Icon(Icons.close),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => int.tryParse(v?.trim() ?? '') == null ? 'Número requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _gfController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Goles a Favor (GF)',
                    prefixIcon: Icon(Icons.sports_soccer),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => int.tryParse(v?.trim() ?? '') == null ? 'Número requerido' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _gcController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Goles en Contra (GC)',
                    prefixIcon: Icon(Icons.shield),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => int.tryParse(v?.trim() ?? '') == null ? 'Número requerido' : null,
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