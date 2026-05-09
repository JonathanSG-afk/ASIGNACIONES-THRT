import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AsignacionesPage extends StatefulWidget {
  const AsignacionesPage({super.key});

  @override
  State<AsignacionesPage> createState() => _AsignacionesPageState();
}

class _AsignacionesPageState extends State<AsignacionesPage> {

  List<Map<String, dynamic>> camiones = [];
  List<Map<String, dynamic>> cedis = [];

  String? camionSeleccionado;
  String? cedisOrigenSeleccionado;
  String? cedisDestinoSeleccionado;
  String? horarioSeleccionado;

  bool cargando = true;

  final List<String> horarios = [
    "00:00","01:00","02:00","03:00","04:00","05:00",
    "06:00","07:00","08:00","09:00","10:00","11:00",
    "12:00","13:00","14:00","15:00","16:00","17:00",
    "18:00","19:00","20:00","21:00","22:00","23:00",
  ];

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final url = Uri.parse("http://192.168.1.156/asignaciones/api/asignaciones.php");
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data["success"]) {
        setState(() {
          camiones = List<Map<String, dynamic>>.from(data["camiones"] ?? []);
          cedis = List<Map<String, dynamic>>.from(data["cedis"] ?? []);
          cargando = false;
        });

        print("🚛 CAMIONES: $camiones");
        print("🏢 CEDIS: $cedis");

      } else {
        setState(() => cargando = false);
      }

    } catch (e) {
      print("🔴 ERROR: $e");
      setState(() => cargando = false);
    }
  }

  void guardarAsignacion() {

    // 🔥 VALIDACIÓN ORIGEN ≠ DESTINO
    if (cedisOrigenSeleccionado == cedisDestinoSeleccionado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Origen y destino no pueden ser iguales")),
      );
      return;
    }

    if (camionSeleccionado != null &&
        cedisOrigenSeleccionado != null &&
        cedisDestinoSeleccionado != null &&
        horarioSeleccionado != null) {

      print("📦 ASIGNACIÓN:");
      print(camionSeleccionado);
      print(cedisOrigenSeleccionado);
      print(cedisDestinoSeleccionado);
      print(horarioSeleccionado);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Asignación creada correctamente")),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          // 🔥 CAMIONES (BUSCADOR)
          Autocomplete<Map<String, dynamic>>(
            optionsBuilder: (text) {
              if (text.text.isEmpty) {
                return const Iterable<Map<String, dynamic>>.empty();
              }

              return camiones.where((item) =>
                  item["tractor"]
                      .toString()
                      .toLowerCase()
                      .contains(text.text.toLowerCase()));
            },
            displayStringForOption: (option) => option["tractor"].toString(),
            onSelected: (selection) {
              setState(() {
                camionSeleccionado = selection["id"].toString();
              });

              print("🚛 CAMIÓN: $camionSeleccionado");
            },
            fieldViewBuilder: (context, controller, focusNode, _) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: "Buscar camión",
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          // 🔥 CEDIS ORIGEN
          Autocomplete<Map<String, dynamic>>(
            optionsBuilder: (text) {
              if (text.text.isEmpty) {
                return const Iterable<Map<String, dynamic>>.empty();
              }

              return cedis.where((item) =>
                  item["nombre"]
                      .toString()
                      .toLowerCase()
                      .contains(text.text.toLowerCase()));
            },
            displayStringForOption: (option) => option["nombre"].toString(),
            onSelected: (selection) {
              setState(() {
                cedisOrigenSeleccionado = selection["id"].toString();
              });

              print("📍 ORIGEN: $cedisOrigenSeleccionado");
            },
            fieldViewBuilder: (context, controller, focusNode, _) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: "Buscar CEDIS origen",
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          // 🔥 CEDIS DESTINO
          Autocomplete<Map<String, dynamic>>(
            optionsBuilder: (text) {
              if (text.text.isEmpty) {
                return const Iterable<Map<String, dynamic>>.empty();
              }

              return cedis.where((item) =>
                  item["nombre"]
                      .toString()
                      .toLowerCase()
                      .contains(text.text.toLowerCase()));
            },
            displayStringForOption: (option) => option["nombre"].toString(),
            onSelected: (selection) {
              setState(() {
                cedisDestinoSeleccionado = selection["id"].toString();
              });

              print("📍 DESTINO: $cedisDestinoSeleccionado");
            },
            fieldViewBuilder: (context, controller, focusNode, _) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: "Buscar CEDIS destino",
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          // 🔥 HORARIOS
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Selecciona horario",
              border: OutlineInputBorder(),
            ),
            value: horarios.contains(horarioSeleccionado)
                ? horarioSeleccionado
                : null,
            items: horarios.map((hora) {
              return DropdownMenuItem(
                value: hora,
                child: Text(hora),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => horarioSeleccionado = value);
            },
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: guardarAsignacion,
            child: const Text("Guardar asignación"),
          ),
        ],
      ),
    );
  }
}