import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/categoria_provider.dart';
import '../../providers/disciplina_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/categoria.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<CategoriaProvider>().loadCategorias();
        context.read<DisciplinaProvider>().loadDisciplinas();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriaProvider = context.watch<CategoriaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: categoriaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : categoriaProvider.errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categoriaProvider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: categoriaProvider.loadCategorias,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : categoriaProvider.categorias.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Sin datos',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No hay categorías registradas.\nPresiona el botón + para agregar una.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: categoriaProvider.categorias.length,
                      itemBuilder: (context, index) {
                        final categoria = categoriaProvider.categorias[index];
                        return _buildCategoriaCard(context, categoria);
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearCategoria,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoriaCard(BuildContext context, Categoria categoria) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          child: Icon(
            Icons.category,
            color: Colors.purple.shade800,
          ),
        ),
        title: Text(
          categoria.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Disciplina: ${categoria.nombreDisciplina ?? "Sin disciplina"}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editarCategoria(categoria),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmarEliminacion(categoria),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _crearCategoria() async {
    if (!mounted) return;
    final categoriaProvider = context.read<CategoriaProvider>();
    final disciplinaProvider = context.read<DisciplinaProvider>();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const _FormularioCategoriaDialog(),
    );

    if (result == true && mounted) {
      await categoriaProvider.loadCategorias();
      if (disciplinaProvider.disciplinas.isEmpty) {
        await disciplinaProvider.loadDisciplinas();
      }
    }
  }

  Future<void> _editarCategoria(Categoria categoria) async {
    if (!mounted) return;
    final categoriaProvider = context.read<CategoriaProvider>();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _FormularioCategoriaDialog(categoria: categoria),
    );

    if (result == true && mounted) {
      await categoriaProvider.loadCategorias();
    }
  }

  void _confirmarEliminacion(Categoria categoria) {
    if (!mounted) return;
    final categoriaProvider = context.read<CategoriaProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text('¿Estás seguro de eliminar "${categoria.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              final ok = await categoriaProvider.deleteCategoria(
                categoria.idCategoria!,
              );

              if (!mounted) return;

              if (ok) {
                await categoriaProvider.loadCategorias();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('✅ Categoría eliminada correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      categoriaProvider.errorMessage ?? 'Error al eliminar',
                    ),
                    backgroundColor: colorScheme.error,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
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

class _FormularioCategoriaDialog extends StatefulWidget {
  final Categoria? categoria;

  const _FormularioCategoriaDialog({this.categoria});

  @override
  State<_FormularioCategoriaDialog> createState() =>
      _FormularioCategoriaDialogState();
}

class _FormularioCategoriaDialogState
    extends State<_FormularioCategoriaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  int? _disciplinaSeleccionada;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      _nombreController.text = widget.categoria!.nombre;
      _disciplinaSeleccionada = widget.categoria!.idDisciplina;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_disciplinaSeleccionada == null) return;

    setState(() => _isSaving = true);

    final categoriaProvider = context.read<CategoriaProvider>();
    final categoria = Categoria(
      idCategoria: widget.categoria?.idCategoria,
      nombre: _nombreController.text.trim(),
      idDisciplina: _disciplinaSeleccionada!,
    );

    bool ok;
    if (widget.categoria == null) {
      ok = await categoriaProvider.crearCategoria(categoria);
    } else {
      ok = await categoriaProvider.actualizarCategoria(
        widget.categoria!.idCategoria!,
        categoria,
      );
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(categoriaProvider.errorMessage ?? 'Error al guardar'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final disciplinaProvider = context.watch<DisciplinaProvider>();

    return AlertDialog(
      title: Text(
        widget.categoria == null ? 'Nueva Categoría' : 'Editar Categoría',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nombre de la categoría',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                if (value.trim().length < 3) {
                  return 'Debe tener al menos 3 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              // 🔥 CORREGIDO: initialValue en vez de value
              initialValue: _disciplinaSeleccionada,
              decoration: const InputDecoration(
                labelText: 'Disciplina',
                prefixIcon: Icon(Icons.sports_baseball),
                border: OutlineInputBorder(),
              ),
              items: disciplinaProvider.disciplinas.map((disciplina) {
                return DropdownMenuItem<int>(
                  value: disciplina.idDisciplina,
                  child: Text(disciplina.nombre),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _disciplinaSeleccionada = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Debes seleccionar una disciplina';
                }
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