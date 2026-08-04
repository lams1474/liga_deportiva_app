import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/club_provider.dart';

class EditarClubScreen extends StatefulWidget {
  final int idClub;
  final String nombre;
  final String ciudad;
  final String fechaFundacion;

  const EditarClubScreen({
    super.key,
    required this.idClub,
    required this.nombre,
    required this.ciudad,
    required this.fechaFundacion,
  });

  @override
  State<EditarClubScreen> createState() => _EditarClubScreenState();
}

class _EditarClubScreenState extends State<EditarClubScreen> {
  late TextEditingController nombreController;
  late TextEditingController ciudadController;
  late TextEditingController fechaController;

  bool cargando = false;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(
      text: widget.nombre,
    );

    ciudadController = TextEditingController(
      text: widget.ciudad,
    );

    fechaController = TextEditingController(
      text: widget.fechaFundacion,
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    ciudadController.dispose();
    fechaController.dispose();
    super.dispose();
  }

  Future<void> actualizarClub() async {
    setState(() {
      cargando = true;
    });

    final ok = await context.read<ClubProvider>().actualizarClub(
          idClub: widget.idClub,
          nombre: nombreController.text.trim(),
          ciudad: ciudadController.text.trim(),
          fechaFundacion: fechaController.text.trim(),
        );

    if (!mounted) return;

    setState(() {
      cargando = false;
    });

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Club actualizado correctamente"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No fue posible actualizar el club"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Club"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre del club",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: ciudadController,
              decoration: const InputDecoration(
                labelText: "Ciudad",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: fechaController,
              decoration: const InputDecoration(
                labelText: "Fecha de fundación",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: cargando ? null : actualizarClub,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: cargando
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Actualizar Club",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}