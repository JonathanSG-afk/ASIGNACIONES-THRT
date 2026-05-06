import 'package:flutter/material.dart';

class CamionesPage extends StatefulWidget {
  const CamionesPage({super.key});

  @override
  State<CamionesPage> createState() => _CamionesPageState();
}

class _CamionesPageState extends State<CamionesPage> {

  final TextEditingController nombre = TextEditingController();
  final TextEditingController placas = TextEditingController();

  void guardar() {
    if (nombre.text.isNotEmpty && placas.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camión guardado")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camiones")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nombre,
              decoration: const InputDecoration(
                labelText: "Nombre del camión",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: placas,
              decoration: const InputDecoration(
                labelText: "Placas",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: guardar,
              child: const Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}