import 'package:flutter/material.dart';

class AsignacionesPage extends StatefulWidget {
  const AsignacionesPage({super.key});

  @override
  State<AsignacionesPage> createState() => _AsignacionesPageState();
}

class _AsignacionesPageState extends State<AsignacionesPage> {

  // Valores seleccionados
  String? opcion1;
  String? opcion2;
  String? opcion3;
  String? opcion4;

  // Opciones
  final List<String> opciones = [
    "Opción 1",
    "Opción 2",
    "Opción 3",
    "Opción 4",
  ];

  void guardarAsignacion() {
    if (opcion1 != null &&
        opcion2 != null &&
        opcion3 != null &&
        opcion4 != null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Asignación creada correctamente")),
      );

      print("Asignación:");
      print(opcion1);
      print(opcion2);
      print(opcion3);
      print(opcion4);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Asignación"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // SELECT 1
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Selecciona opción 1",
                border: OutlineInputBorder(),
              ),
              value: opcion1,
              items: opciones.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  opcion1 = value;
                });
              },
            ),

            const SizedBox(height: 15),

            // SELECT 2
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Selecciona opción 2",
                border: OutlineInputBorder(),
              ),
              value: opcion2,
              items: opciones.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  opcion2 = value;
                });
              },
            ),

            const SizedBox(height: 15),

            // SELECT 3
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Selecciona opción 3",
                border: OutlineInputBorder(),
              ),
              value: opcion3,
              items: opciones.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  opcion3 = value;
                });
              },
            ),

            const SizedBox(height: 15),

            // SELECT 4
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Selecciona opción 4",
                border: OutlineInputBorder(),
              ),
              value: opcion4,
              items: opciones.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  opcion4 = value;
                });
              },
            ),

            const SizedBox(height: 25),

            // BOTÓN
            ElevatedButton(
              onPressed: guardarAsignacion,
              child: const Text("Guardar asignación"),
            )
          ],
        ),
      ),
    );
  }
}