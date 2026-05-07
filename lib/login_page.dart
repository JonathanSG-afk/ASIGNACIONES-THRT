import 'dart:ui';
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

  Future<void> login() async {
    //final url = Uri.parse("http://192.168.1.178/api/login.php");
    final url = Uri.parse("http://192.168.1.156/api/login.php");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user": usuario.text, "password": password.text}),
    );

    final data = jsonDecode(response.body);

    if (data["success"]) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(user: data["user"])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 🔥 evita overflow

      body: Stack(
        children: [
          // 🔥 FONDO
          SizedBox.expand(
            child: Image.asset("assets/background.png", fit: BoxFit.cover),
          ),

          // 🔥 OSCURECER
          Container(color: Colors.black.withOpacity(0.5)),

          // 🔥 CONTENIDO AJUSTADO
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🔥 LOGO
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Image.asset(
                        "assets/logo.png",
                        height: 200,
                      ),
                    ),

                    // 🔥 CARD LOGIN
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            width: double.infinity,
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
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "Bienvenido, inicia sesión",
                                  style: TextStyle(color: Colors.white70),
                                ),

                                const SizedBox(height: 25),

                                TextField(
                                  controller: usuario,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Usuario",
                                    hintStyle:
                                        const TextStyle(color: Colors.white60),
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.white70,
                                    ),
                                    filled: true,
                                    fillColor:
                                        Colors.white.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 15),

                                TextField(
                                  controller: password,
                                  obscureText: true,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Contraseña",
                                    hintStyle:
                                        const TextStyle(color: Colors.white60),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.white70,
                                    ),
                                    filled: true,
                                    fillColor:
                                        Colors.white.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 25),

                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: cargando ? null : login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFD4AF37),
                                            Color(0xFFB8962E),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: cargando
                                            ? const CircularProgressIndicator(
                                                color: Colors.black,
                                              )
                                            : const Text(
                                                "Iniciar Sesión",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}