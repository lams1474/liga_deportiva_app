import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/temporada_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/temporada.dart';

class TemporadasScreen extends StatefulWidget {
  const TemporadasScreen({super.key});

  @override
  State<TemporadasScreen> createState() => _TemporadasScreenState();
}

class _TemporadasScreenState extends State<TemporadasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<TemporadaProvider>().loadTemporadas();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final temporadaProvider = context.watch<TemporadaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temporadas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: temporadaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : temporadaProvider.errorMessage != null
              ? _buildError(context, temporadaProvider)
              : temporadaProvider.temporadas.isEmpty
                  ? _buildEmpty(context)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: temporadaProvider.temporadas.length,
                      itemBuilder: (context, index) {
                        final temporada = temporadaProvider.temporadas[index];
                        return _buildTemporadaCard(context, temporada);
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearTemporada,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildError(BuildContext context, TemporadaProvider provider) {
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
            ElevatedButton(onPressed: provider.loadTemporadas, child: const Text('Reintentar')),
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
            Icon(Icons.calendar_month_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('Sin datos', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(
              'No hay temporadas registradas.\nPresiona el botón + para agregar una.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemporadaCard(BuildContext context, Temporada temporada) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: Icon(Icons.calendar_month, color: Colors.indigo.shade800),
        ),
        title: Text('Temporada ${temporada.anio}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text('ID: ${temporada.idTemporada}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editarTemporada(temporada),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmarEliminacion(temporada),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _crearTemporada() async {
    if (!mounted) return;
    final provider = context.read<TemporadaProvider>();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const _FormularioTemporadaDialog(),
    );
    if (result == true && mounted) {
      await provider.loadTemporadas();
    }
  }

  Future<void> _editarTemporada(Temporada temporada) async {
    if (!mounted) return;
    final provider = context.read<TemporadaProvider>();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _FormularioTemporadaDialog(temporada: temporada),
    );
    if (result == true && mounted) {
      await provider.loadTemporadas();
    }
  }

  void _confirmarEliminacion(Temporada temporada) {
    if (!mounted) return;
    final provider = context.read<TemporadaProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar temporada'),
        content: Text('¿Estás seguro de eliminar la temporada ${temporada.anio}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final ok = await provider.deleteTemporada(temporada.idTemporada!);
              if (!mounted) return;
              if (ok) {
                await provider.loadTemporadas();
                messenger.showSnackBar(
                  const SnackBar(content: Text('✅ Temporada eliminada correctamente'), backgroundColor: Colors.green),
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

class _FormularioTemporadaDialog extends StatefulWidget {
  final Temporada? temporada;
  const _FormularioTemporadaDialog({this.temporada});

  @override
  State<_FormularioTemporadaDialog> createState() => _FormularioTemporadaDialogState();
}

class _FormularioTemporadaDialogState extends State<_FormularioTemporadaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _anioController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.temporada != null) {
      _anioController.text = widget.temporada!.anio.toString();
    } else {
      _anioController.text = DateTime.now().year.toString();
    }
  }

  @override
  void dispose() {
    _anioController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final provider = context.read<TemporadaProvider>();
    final anio = int.parse(_anioController.text.trim());
    final temporada = Temporada(
      idTemporada: widget.temporada?.idTemporada,
      anio: anio,
    );

    bool ok;
    if (widget.temporada == null) {
      ok = await provider.crearTemporada(temporada);
    } else {
      ok = await provider.actualizarTemporada(widget.temporada!.idTemporada!, temporada);
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
    return AlertDialog(
      title: Text(widget.temporada == null ? 'Nueva Temporada' : 'Editar Temporada'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _anioController,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Año de la temporada',
            prefixIcon: Icon(Icons.calendar_month),
            border: OutlineInputBorder(),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'El año es obligatorio';
            final anio = int.tryParse(v.trim());
            if (anio == null) return 'Debe ser un número';
            if (anio < 1900 || anio > 2100) return 'Año fuera de rango (1900-2100)';
            return null;
          },
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