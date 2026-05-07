import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CamionesPage extends StatefulWidget {
  final Function()? onGuardado;

  const CamionesPage({super.key, this.onGuardado});

  @override
  State<CamionesPage> createState() => _CamionesPageState();
}

class _CamionesPageState extends State<CamionesPage> {
  final TextEditingController tractor = TextEditingController();
  final TextEditingController economico = TextEditingController();
  final TextEditingController placas = TextEditingController();
  final TextEditingController modelo = TextEditingController();
  final TextEditingController capacidad = TextEditingController();

  bool cargando = false;

  Future<void> guardar() async {
    if (tractor.text.isEmpty ||
        placas.text.isEmpty ||
        economico.text.isEmpty ||
        modelo.text.isEmpty ||
        capacidad.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa los campos obligatorios")),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      //final url = Uri.parse("http://192.168.1.156/api/unidades.php");
      final url = Uri.parse("http://192.168.1.178/api/unidades.php");

      final body = {
        "tractor": tractor.text,
        "economico": economico.text,
        "placas": placas.text,
        "modelo": modelo.text,
        "capacidad": capacidad.text,
      };

      print("🔵 ENVIANDO:");
      print(jsonEncode(body));

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("🟢 RESPUESTA:");
      print(response.body);

      final data = jsonDecode(response.body);

      if (data["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );

        // limpiar
        tractor.clear();
        economico.clear();
        placas.clear();
        modelo.clear();
        capacidad.clear();

        print("✅ CALLBACK EJECUTADO");

        // 🔥 PEQUEÑO DELAY SEGURO PARA UX
        await Future.delayed(const Duration(milliseconds: 300));

        widget.onGuardado?.call(); // 👈 REGRESA AL HOME

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
      }
    } catch (e) {
      print("🔴 ERROR:");
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error de conexión")),
      );
    }

    setState(() {
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Registro de Camiones",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: tractor,
                decoration: const InputDecoration(
                  labelText: "Nombre del camión",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: economico,
                decoration: const InputDecoration(
                  labelText: "Número económico",
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
              const SizedBox(height: 15),

              TextField(
                controller: modelo,
                decoration: const InputDecoration(
                  labelText: "Modelo",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: capacidad,
                decoration: const InputDecoration(
                  labelText: "Capacidad",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: cargando ? null : guardar,
                  child: cargando
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("Guardar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 