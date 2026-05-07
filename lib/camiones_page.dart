import 'dart:ui';
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

    setState(() => cargando = true);

    try {
      final url = Uri.parse("http://192.168.1.156/api/unidades.php");
      //final url = Uri.parse("http://192.168.1.178/api/unidades.php");

      final body = {
        "tractor": tractor.text,
        "economico": economico.text,
        "placas": placas.text,
        "modelo": modelo.text,
        "capacidad": capacidad.text,
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (data["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );

        tractor.clear();
        economico.clear();
        placas.clear();
        modelo.clear();
        capacidad.clear();

        await Future.delayed(const Duration(milliseconds: 300));
        widget.onGuardado?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error de conexión")),
      );
    }

    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // 🔥 importante
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        const Text(
                          "Registro de Camiones",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        _input("Nombre del camión", tractor),
                        const SizedBox(height: 15),

                        _input("Número económico", economico),
                        const SizedBox(height: 15),

                        _input("Placas", placas),
                        const SizedBox(height: 15),

                        _input("Modelo", modelo),
                        const SizedBox(height: 15),

                        _input("Capacidad", capacidad),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: cargando ? null : guardar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: cargando
                                ? const CircularProgressIndicator(color: Colors.black)
                                : const Text(
                                    "Guardar",
                                    style: TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }

  // 🔥 INPUT REUTILIZABLE ESTILO GLASS
  Widget _input(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}