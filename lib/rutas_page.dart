import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/glass_card.dart';

class RutasPage extends StatefulWidget {
  final Function()? onGuardado;

  const RutasPage({super.key, this.onGuardado});

  @override
  State<RutasPage> createState() => _RutasPageState();
}

class _RutasPageState extends State<RutasPage> {
  final TextEditingController cedis = TextEditingController();

  bool cargando = false;

  Future<void> guardar() async {
    if (cedis.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa el nombre del CEDIS")),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      final url = Uri.parse("http://192.168.1.156/api/cedis.php");

      final body = {
        "cedis": cedis.text,
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

        cedis.clear();

        // 🔥 REGRESAR (SIEMPRE FUNCIONA)
        await Future.delayed(const Duration(milliseconds: 300));

        if (widget.onGuardado != null) {
          widget.onGuardado!(); // 👈 HomePage
        } else {
          Navigator.pop(context); // 👈 fallback
        }

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

    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Text(
                      "Registro de CEDIS",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    TextField(
                      controller: cedis,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Nombre del CEDIS",
                        hintStyle: const TextStyle(color: Colors.white60),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

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
    );
  }
}