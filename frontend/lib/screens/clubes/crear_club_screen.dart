import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/club_provider.dart';

class CrearClubScreen extends StatefulWidget {
  const CrearClubScreen({super.key});

  @override
  State<CrearClubScreen> createState() => _CrearClubScreenState();
}

class _CrearClubScreenState extends State<CrearClubScreen> {

  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final ciudadController = TextEditingController();
  final fechaController = TextEditingController();

  bool cargando = false;

  Future<void> guardar() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      cargando = true;
    });

    final ok = await context.read<ClubProvider>().crearClub(
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
          content: Text("Club registrado correctamente"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No fue posible registrar el club"),
          backgroundColor: Colors.red,
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Registrar Club"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Center(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: SizedBox(

            width: 500,

            child: Card(

              elevation: 10,

              child: Padding(

                padding: const EdgeInsets.all(25),

                child: Form(

                  key: _formKey,

                  child: Column(

                    children: [

                      TextFormField(
                        controller: nombreController,
                        decoration: const InputDecoration(
                          labelText: "Nombre del club",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Ingrese el nombre" : null,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: ciudadController,
                        decoration: const InputDecoration(
                          labelText: "Ciudad",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Ingrese la ciudad" : null,
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: fechaController,
                        decoration: const InputDecoration(
                          labelText: "Fecha de fundación",
                          hintText: "2020-05-10",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Ingrese la fecha" : null,
                      ),

                      const SizedBox(height: 30),

                      SizedBox(

                        width: double.infinity,

                        height: 50,

                        child: ElevatedButton(

                          onPressed: cargando ? null : guardar,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),

                          child: cargando
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Guardar Club",
                                  style: TextStyle(fontSize: 18),
                                ),

                        ),

                      ),

                    ],

                  ),

                ),

              ),

            ),

          ),

        ),

      ),

    );

  }

}