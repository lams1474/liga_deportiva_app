import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/club_provider.dart';
import 'editar_club_screen.dart';

class ClubesScreen extends StatefulWidget {
  const ClubesScreen({super.key});

  @override
  State<ClubesScreen> createState() => _ClubesScreenState();
}

class _ClubesScreenState extends State<ClubesScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => context.read<ClubProvider>().cargarClubes(),
    );
  }

  Future<void> confirmarEliminar(int idClub, String nombre) async {

    final confirmado = await showDialog<bool>(

      context: context,

      builder: (_) => AlertDialog(

        title: const Text('Eliminar club'),

        content: Text(
          '¿Está seguro de eliminar el club "$nombre"?',
        ),

        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),

        ],

      ),

    );

    if (confirmado != true) return;

    final ok = await context.read<ClubProvider>().eliminarClub(idClub);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Text(
          ok
              ? 'Club eliminado correctamente'
              : 'No fue posible eliminar el club',
        ),

        backgroundColor: ok ? Colors.green : Colors.red,

      ),

    );
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<ClubProvider>();

    return Scaffold(

      appBar: AppBar(
        title: const Text('Clubes'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),

        onPressed: () async {

          await Navigator.pushNamed(
            context,
            '/clubes/crear',
          );

          if (!mounted) return;

          context.read<ClubProvider>().cargarClubes();

        },
      ),

      body: Builder(

        builder: (_) {

          if (provider.cargando) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Text(provider.error!),
            );
          }

          if (provider.clubes.isEmpty) {
            return const Center(
              child: Text(
                'No existen clubes registrados.',
              ),
            );
          }

          return ListView.builder(

            itemCount: provider.clubes.length,

            itemBuilder: (_, index) {

              final club = provider.clubes[index];

              return Card(

                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                child: ListTile(

                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      club.idClub.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  title: Text(club.nombre),

                  subtitle: Text(
                    '${club.ciudad}\nFundación: ${club.fechaFundacion}',
                  ),

                  isThreeLine: true,

                  trailing: Row(

                    mainAxisSize: MainAxisSize.min,

                    children: [

                      IconButton(

                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),

                        onPressed: () async {

                          await Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) => EditarClubScreen(

                                idClub: club.idClub,
                                nombre: club.nombre,
                                ciudad: club.ciudad,
                                fechaFundacion: club.fechaFundacion,

                              ),

                            ),

                          );

                          if (!mounted) return;

                          context.read<ClubProvider>().cargarClubes();

                        },

                      ),

                      IconButton(

                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),

                        onPressed: () => confirmarEliminar(
                          club.idClub,
                          club.nombre,
                        ),

                      ),

                    ],

                  ),

                ),

              );

            },

          );

        },

      ),

    );

  }

}