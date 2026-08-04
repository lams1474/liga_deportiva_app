import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liga Deportiva Barrial"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      drawer: Drawer(
        child: ListView(
          children: [

            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.sports_soccer,
                    size: 70,
                    color: Colors.white,
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Sistema Liga Deportiva",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),

                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Inicio"),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.groups),
              title: const Text("Clubes"),
              onTap: () {

                Navigator.pop(context);

                Navigator.pushNamed(
                  context,
                  "/clubes",
                );

              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Jugadores"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Partidos"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.scoreboard),
              title: const Text("Resultados"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text("Tabla de posiciones"),
              onTap: () {},
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Cerrar sesión"),
              onTap: () {

                Navigator.pushReplacementNamed(
                  context,
                  "/",
                );

              },
            ),

          ],
        ),
      ),

      body: const Center(
        child: Text(
          "Bienvenido al Sistema de Gestión Deportiva",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}