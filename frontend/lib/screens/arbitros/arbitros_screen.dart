import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/arbitro_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/arbitro.dart';

class ArbitrosScreen extends StatefulWidget {
  const ArbitrosScreen({super.key});

  @override
  State<ArbitrosScreen> createState() => _ArbitrosScreenState();
}

class _ArbitrosScreenState extends State<ArbitrosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<ArbitroProvider>().loadArbitros();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final arbitroProvider = context.watch<ArbitroProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Árbitros'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: arbitroProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : arbitroProvider.errorMessage != null
              ? _buildError(context, arbitroProvider)
              : arbitroProvider.arbitros.isEmpty
                  ? _buildEmpty(context)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: arbitroProvider.arbitros.length,
                      itemBuilder: (context, index) {
                        final arbitro = arbitroProvider.arbitros[index];
                        return _buildArbitroCard(context, arbitro);
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearArbitro,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildError(BuildContext context, ArbitroProvider provider) {
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
            ElevatedButton(onPressed: provider.loadArbitros, child: const Text('Reintentar')),
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
            Icon(Icons.sports_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('Sin datos', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(
              'No hay árbitros registrados.\nPresiona el botón + para agregar uno.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArbitroCard(BuildContext context, Arbitro arbitro) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Icon(Icons.sports, color: Colors.teal.shade800),
        ),
        title: Text(arbitro.nombre, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text('Categoría: ${arbitro.categoria}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editarArbitro(arbitro),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmarEliminacion(arbitro),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _crearArbitro() async {
    if (!mounted) return;
    final provider = context.read<ArbitroProvider>();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const _FormularioArbitroDialog(),
    );
    if (result == true && mounted) {
      await provider.loadArbitros();
    }
  }

  Future<void> _editarArbitro(Arbitro arbitro) async {
    if (!mounted) return;
    final provider = context.read<ArbitroProvider>();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _FormularioArbitroDialog(arbitro: arbitro),
    );
    if (result == true && mounted) {
      await provider.loadArbitros();
    }
  }

  void _confirmarEliminacion(Arbitro arbitro) {
    if (!mounted) return;
    final provider = context.read<ArbitroProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar árbitro'),
        content: Text('¿Estás seguro de eliminar a "${arbitro.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final ok = await provider.deleteArbitro(arbitro.idArbitro!);
              if (!mounted) return;
              if (ok) {
                await provider.loadArbitros();
                messenger.showSnackBar(
                  const SnackBar(content: Text('✅ Árbitro eliminado correctamente'), backgroundColor: Colors.green),
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

class _FormularioArbitroDialog extends StatefulWidget {
  final Arbitro? arbitro;
  const _FormularioArbitroDialog({this.arbitro});

  @override
  State<_FormularioArbitroDialog> createState() => _FormularioArbitroDialogState();
}

class _FormularioArbitroDialogState extends State<_FormularioArbitroDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _categoriaController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.arbitro != null) {
      _nombreController.text = widget.arbitro!.nombre;
      _categoriaController.text = widget.arbitro!.categoria;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _categoriaController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final provider = context.read<ArbitroProvider>();
    final arbitro = Arbitro(
      idArbitro: widget.arbitro?.idArbitro,
      nombre: _nombreController.text.trim(),
      categoria: _categoriaController.text.trim(),
    );

    bool ok;
    if (widget.arbitro == null) {
      ok = await provider.crearArbitro(arbitro);
    } else {
      ok = await provider.actualizarArbitro(widget.arbitro!.idArbitro!, arbitro);
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
      title: Text(widget.arbitro == null ? 'Nuevo Árbitro' : 'Editar Árbitro'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nombre del árbitro',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'El nombre es obligatorio';
                if (v.trim().length < 3) return 'Debe tener al menos 3 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoriaController,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'La categoría es obligatoria';
                return null;
              },
            ),
          ],
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