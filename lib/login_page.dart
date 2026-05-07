import 'package:flutter/material.dart';
import 'home_page.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usuario = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool cargando = false;

  // 🔐 LOGIN CON API
  Future<void> login() async {
    setState(() {
      cargando = true;
    });

    try {
      //final url = Uri.parse("http://192.168.1.178/api/login.php");
       final url = Uri.parse("http://192.168.1.156/api/login.php");

      // 🔥 DEBUG: lo que envías
      debugPrint("Usuario enviado: ${usuario.text}");
      debugPrint("Password enviado: ${password.text}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user": usuario.text,
          "password": password.text,
        }),
      );

      // 🔥 DEBUG: respuesta del servidor
      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("RESPONSE BODY:");
      debugPrint(response.body);

      final data = jsonDecode(response.body);

      // 🔥 DEBUG: JSON ya convertido
      debugPrint("DATA DECODIFICADA:");
      debugPrint(data.toString());

      if (data["success"]) {

        // 🔥 NUEVO: ver todo el usuario
        debugPrint("USER COMPLETO:");
        debugPrint(data["user"].toString());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(user: data["user"]), // 👈 CAMBIO CLAVE
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Error de login")),
        );
      }
    } catch (e) {
      // 🔥 DEBUG: errores reales
      debugPrint("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error de conexión con el servidor")),
      );
    }

    setState(() {
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 180),

              const SizedBox(height: 20),

              const Text(
                "Asignaciones",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: usuario,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFD4AF37)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFD4AF37)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: cargando ? null : login,
                  child: cargando
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("Iniciar Sesión"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}