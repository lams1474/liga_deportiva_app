import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/disciplina_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/disciplina.dart';

class DisciplinasScreen extends StatefulWidget {
  const DisciplinasScreen({super.key});

  @override
  State<DisciplinasScreen> createState() => _DisciplinasScreenState();
}

class _DisciplinasScreenState extends State<DisciplinasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.read<DisciplinaProvider>().loadDisciplinas();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final disciplinaProvider = context.watch<DisciplinaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disciplinas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: disciplinaProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : disciplinaProvider.errorMessage != null
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
                          disciplinaProvider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: disciplinaProvider.loadDisciplinas,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : disciplinaProvider.disciplinas.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sports_baseball_outlined,
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
                              'No hay disciplinas registradas.\nPresiona el botón + para agregar una.',
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
                      itemCount: disciplinaProvider.disciplinas.length,
                      itemBuilder: (context, index) {
                        final disciplina = disciplinaProvider.disciplinas[index];
                        return _buildDisciplinaCard(context, disciplina);
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearDisciplina,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDisciplinaCard(BuildContext context, Disciplina disciplina) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(
            Icons.sports_baseball,
            color: Colors.orange.shade800,
          ),
        ),
        title: Text(
          disciplina.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text('ID: ${disciplina.idDisciplina}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editarDisciplina(disciplina),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmarEliminacion(disciplina),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _crearDisciplina() async {
    if (!mounted) return;
    final disciplinaProvider = context.read<DisciplinaProvider>();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const _FormularioDisciplinaDialog(),
    );

    if (result == true && mounted) {
      await disciplinaProvider.loadDisciplinas();
    }
  }

  Future<void> _editarDisciplina(Disciplina disciplina) async {
    if (!mounted) return;
    final disciplinaProvider = context.read<DisciplinaProvider>();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _FormularioDisciplinaDialog(disciplina: disciplina),
    );

    if (result == true && mounted) {
      await disciplinaProvider.loadDisciplinas();
    }
  }

  void _confirmarEliminacion(Disciplina disciplina) {
    if (!mounted) return;
    final disciplinaProvider = context.read<DisciplinaProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar disciplina'),
        content: Text('¿Estás seguro de eliminar "${disciplina.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              final ok = await disciplinaProvider.deleteDisciplina(
                disciplina.idDisciplina!,
              );

              if (!mounted) return;

              if (ok) {
                await disciplinaProvider.loadDisciplinas();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('✅ Disciplina eliminada correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      disciplinaProvider.errorMessage ?? 'Error al eliminar',
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
// DIÁLOGO DE FORMULARIO (crear/editar)
// ============================================================

class _FormularioDisciplinaDialog extends StatefulWidget {
  final Disciplina? disciplina;

  const _FormularioDisciplinaDialog({this.disciplina});

  @override
  State<_FormularioDisciplinaDialog> createState() =>
      _FormularioDisciplinaDialogState();
}

class _FormularioDisciplinaDialogState
    extends State<_FormularioDisciplinaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.disciplina != null) {
      _nombreController.text = widget.disciplina!.nombre;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final disciplinaProvider = context.read<DisciplinaProvider>();
    final disciplina = Disciplina(
      idDisciplina: widget.disciplina?.idDisciplina,
      nombre: _nombreController.text.trim(),
    );

    bool ok;
    if (widget.disciplina == null) {
      ok = await disciplinaProvider.crearDisciplina(disciplina);
    } else {
      ok = await disciplinaProvider.actualizarDisciplina(
        widget.disciplina!.idDisciplina!,
        disciplina,
      );
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(disciplinaProvider.errorMessage ?? 'Error al guardar'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.disciplina == null ? 'Nueva Disciplina' : 'Editar Disciplina',
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nombreController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nombre de la disciplina',
            prefixIcon: Icon(Icons.sports_baseball),
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