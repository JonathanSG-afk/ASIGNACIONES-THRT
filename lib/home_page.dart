import 'dart:ui';
import 'package:flutter/material.dart';
import 'asignation_page.dart';
import 'usuarios_page.dart';
import 'login_page.dart';
import 'camiones_page.dart';
import 'rutas_page.dart';
import 'horarios_page.dart';

class HomePage extends StatefulWidget {
  final Map user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaActual = 0;

  late List<Map<String, dynamic>> menuItems;

  @override
  void initState() {
    super.initState();

    int rol = int.parse(widget.user["rol"].toString());

    if (rol == 1) {
      menuItems = [
        {"title": "Inicio", "icon": Icons.home, "page": 0},
        {"title": "Asignaciones", "icon": Icons.assignment, "page": 1},
        {"title": "Usuarios", "icon": Icons.people, "page": 2},
      ];
    } else if (rol == 2) {
      menuItems = [
        {"title": "Inicio", "icon": Icons.home, "page": 0},
        {"title": "Asignaciones", "icon": Icons.assignment, "page": 1},
      ];
    } else {
      menuItems = [
        {"title": "Inicio", "icon": Icons.home, "page": 0},
      ];
    }
  }

  void cambiarPagina(int index) {
    setState(() {
      paginaActual = index;
    });
  }

  Widget getPagina() {
    switch (paginaActual) {
      case 0:
        return _homePrincipal();
      case 1:
        return const AsignacionesPage();
      case 2:
        return const UsuariosPage();
      case 3:
        return CamionesPage(onGuardado: () => cambiarPagina(0));
      case 4:
        return const RutasPage();
      case 5:
        return const HorariosPage();
      default:
        return const Center(child: Text("Página no encontrada"));
    }
  }

  Widget _homePrincipal() {
    return Center(
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
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.directions_bus,
                      size: 50, color: Color(0xFFD4AF37)),
                  const SizedBox(height: 15),
                  Text(
                    "Bienvenido ${widget.user["nombre"]}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sistema de asignaciones",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItem(String title, int page) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      onTap: () {
        cambiarPagina(page);
        Navigator.pop(context);
      },
    );
  }

  void cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text("Salir"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Inicio"),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: getPagina(),
            ),
          ),
        ],
      ),

      // 🔥 DRAWER MÁS TRANSLÚCIDO
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25), // 🔥 más blur
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2), // 🔥 más transparente
                border: Border(
                  right: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              child: Column(
                children: [

                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    accountName: Text(
                      "${widget.user["nombre"]} ${widget.user["apellido_paterno"]}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(
                      widget.user["email"],
                      style: const TextStyle(color: Colors.white70),
                    ),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Color(0xFFD4AF37),
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                  ),

                  ...menuItems.map((item) {
                    return ListTile(
                      leading: Icon(item["icon"], color: Colors.white70),
                      title: Text(item["title"],
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        cambiarPagina(item["page"]);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),

                  ExpansionTile(
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white70,
                    title: const Text("Catálogos",
                        style: TextStyle(color: Colors.white)),
                    leading: const Icon(Icons.category,
                        color: Colors.white70),
                    children: [
                      _menuItem("Camiones", 3),
                      _menuItem("Rutas", 4),
                      _menuItem("Horarios", 5),
                    ],
                  ),

                  const Spacer(),

                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Cerrar sesión",
                        style: TextStyle(color: Colors.white)),
                    onTap: () => cerrarSesion(context),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}