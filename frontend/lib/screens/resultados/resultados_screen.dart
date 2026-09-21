import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/resultado_provider.dart';
import '../../providers/partido_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/resultado.dart';

class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({super.key});

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      if (auth.isAuthenticated) {
        context.read<ResultadoProvider>().loadResultados();
        context.read<PartidoProvider>().loadPartidos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResultadoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
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
              : provider.resultados.isEmpty
                  ? _buildEmpty(context)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: provider.resultados.length,
                      itemBuilder: (context, index) {
                        return _buildResultadoCard(context, provider.resultados[index]);
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearResultado,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildError(BuildContext context, ResultadoProvider provider) {
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
            ElevatedButton(onPressed: provider.loadResultados, child: const Text('Reintentar')),
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
            Icon(Icons.scoreboard_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('Sin datos', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(
              'No hay resultados registrados.\nPresiona el botón + para agregar uno.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultadoCard(BuildContext context, Resultado resultado) {
    final partido = resultado.partidoData;
    final clubLocal = partido?['club_local']?['nombre'] ?? 'Local';
    final clubVisitante = partido?['club_visitante']?['nombre'] ?? 'Visitante';
    final fechaPartido = partido?['fecha'];
    final fechaStr = fechaPartido != null
        ? DateTime.parse(fechaPartido.toString()).toLocal().toString().split(' ')[0]
        : '';

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    clubLocal,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    resultado.descripcionMarcador,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    clubVisitante,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (fechaStr.isNotEmpty) _buildInfoRow(Icons.calendar_today, 'Fecha del partido: $fechaStr'),
            const SizedBox(height: 4),
            _buildInfoRow(Icons.person, 'Registrado por: ${resultado.nombreRegistrador}'),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editarResultado(resultado),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmarEliminacion(resultado),
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

  Future<void> _crearResultado() async {
    if (!mounted) return;
    final provider = context.read<ResultadoProvider>();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const _FormularioResultadoDialog(),
    );
    if (result == true && mounted) {
      await provider.loadResultados();
    }
  }

  Future<void> _editarResultado(Resultado resultado) async {
    if (!mounted) return;
    final provider = context.read<ResultadoProvider>();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _FormularioResultadoDialog(resultado: resultado),
    );
    if (result == true && mounted) {
      await provider.loadResultados();
    }
  }

  void _confirmarEliminacion(Resultado resultado) {
    if (!mounted) return;
    final provider = context.read<ResultadoProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar resultado'),
        content: const Text('¿Estás seguro de eliminar este resultado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final ok = await provider.deleteResultado(resultado.idResultado!);
              if (!mounted) return;
              if (ok) {
                await provider.loadResultados();
                messenger.showSnackBar(
                  const SnackBar(content: Text('✅ Resultado eliminado correctamente'), backgroundColor: Colors.green),
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

class _FormularioResultadoDialog extends StatefulWidget {
  final Resultado? resultado;
  const _FormularioResultadoDialog({this.resultado});

  @override
  State<_FormularioResultadoDialog> createState() => _FormularioResultadoDialogState();
}

class _FormularioResultadoDialogState extends State<_FormularioResultadoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _marcadorLocalController = TextEditingController();
  final _marcadorVisitanteController = TextEditingController();

  int? _idPartido;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.resultado != null) {
      _idPartido = widget.resultado!.idPartido;
      _marcadorLocalController.text = widget.resultado!.marcadorLocal?.toString() ?? '';
      _marcadorVisitanteController.text = widget.resultado!.marcadorVisitante?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _marcadorLocalController.dispose();
    _marcadorVisitanteController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idPartido == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un partido'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSaving = true);

    final authProvider = context.read<AuthProvider>();
    final provider = context.read<ResultadoProvider>();

    final idUsuario = authProvider.usuario?.idUsuario;
    if (idUsuario == null) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo identificar al usuario'), backgroundColor: Colors.red),
      );
      return;
    }

    final resultado = Resultado(
      idResultado: widget.resultado?.idResultado,
      idPartido: _idPartido!,
      marcadorLocal: int.tryParse(_marcadorLocalController.text.trim()),
      marcadorVisitante: int.tryParse(_marcadorVisitanteController.text.trim()),
      registradoPor: idUsuario,
    );

    bool ok;
    if (widget.resultado == null) {
      ok = await provider.crearResultado(resultado);
    } else {
      ok = await provider.actualizarResultado(widget.resultado!.idResultado!, resultado);
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
    final partidoProvider = context.watch<PartidoProvider>();

    return AlertDialog(
      title: Text(widget.resultado == null ? 'Nuevo Resultado' : 'Editar Resultado'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.resultado == null)
                  DropdownButtonFormField<int>(
                    // 🔥 CORREGIDO: initialValue
                    initialValue: _idPartido,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Partido',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    items: partidoProvider.partidos.map((p) {
                      final local = p.nombreClubLocal;
                      final visitante = p.nombreClubVisitante;
                      return DropdownMenuItem<int>(
                        value: p.idPartido,
                        child: Text('$local vs $visitante', overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _idPartido = v),
                    validator: (v) => v == null ? 'Selecciona un partido' : null,
                  )
                else
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Partido',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    child: Text('ID: $_idPartido'),
                  ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _marcadorLocalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Marcador Local',
                    prefixIcon: Icon(Icons.sports),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Obligatorio';
                    final num = int.tryParse(v.trim());
                    if (num == null) return 'Debe ser un número';
                    if (num < 0) return 'No puede ser negativo';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _marcadorVisitanteController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Marcador Visitante',
                    prefixIcon: Icon(Icons.sports),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Obligatorio';
                    final num = int.tryParse(v.trim());
                    if (num == null) return 'Debe ser un número';
                    if (num < 0) return 'No puede ser negativo';
                    return null;
                  },
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