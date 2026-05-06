import 'package:flutter/material.dart';
import 'camiones_page.dart';
import 'rutas_page.dart';
import 'horarios_page.dart';

class CatalogosPage extends StatelessWidget {
  const CatalogosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catálogos"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
          children: [

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CamionesPage()),
                );
              },
              child: const Text("Catálogo de Camiones"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RutasPage()),
                );
              },
              child: const Text("Catálogo de Rutas"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HorariosPage()),
                );
              },
              child: const Text("Catálogo de Horarios"),
            ),
          ],
        ),
      );
  }
}