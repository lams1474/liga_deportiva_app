import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _correoController =
      TextEditingController();

  final TextEditingController _contrasenaController =
      TextEditingController();

  bool cargando = false;

  Future<void> iniciarSesion() async {
    setState(() {
      cargando = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();

      final ok = await authProvider.login(
        _correoController.text.trim(),
        _contrasenaController.text,
      );

      if (!mounted) return;

      if (ok) {
        Navigator.pushReplacementNamed(
          context,
          "/dashboard",
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text("Liga Deportiva Barrial"),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: SizedBox(
            width: 420,

            child: Card(
              elevation: 10,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),

              child: Padding(
                padding: const EdgeInsets.all(30),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    const Icon(
                      Icons.sports_soccer,
                      size: 90,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Liga Deportiva Barrial",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      "José Ignacio Izurieta",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 35),

                    TextField(
                      controller: _correoController,
                      decoration: const InputDecoration(
                        labelText: "Correo electrónico",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _contrasenaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Contraseña",
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: cargando
                            ? null
                            : iniciarSesion,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),

                        child: cargando
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Iniciar sesión",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
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
    );
  }
}