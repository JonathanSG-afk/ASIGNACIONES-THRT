import 'package:flutter/material.dart';
import 'asignation_page.dart';
import 'usuarios_page.dart';
import 'catalogos_page.dart';
import 'login_page.dart';
import 'camiones_page.dart';

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

    // 🔥 MENÚ SEGÚN ROL
    if (rol == 1) {
      menuItems = [
        {"title": "Inicio", "icon": Icons.home, "page": 0},
        {"title": "Asignaciones", "icon": Icons.assignment, "page": 1},
        {"title": "Usuarios", "icon": Icons.people, "page": 2},
        {"title": "Catálogos", "icon": Icons.category, "page": 3},
      ];
    } else if (rol == 2) {
      menuItems = [
        {"title": "Inicio", "icon": Icons.home, "page": 0},
        {"title": "Asignaciones", "icon": Icons.assignment, "page": 1},
      ];
    } else if (rol == 3) {
      menuItems = [
        {"title": "Incidencias", "icon": Icons.assignment, "page": 1},
      ];
    } else {
      menuItems = [
        {"title": "Inicio", "icon": Icons.home, "page": 0},
      ];
    }
  }

  // 🔥 CONTROL CENTRAL DE NAVEGACIÓN
  void cambiarPagina(int index) {
    setState(() {
      paginaActual = index;
    });
  }

  // 🔥 PÁGINAS DINÁMICAS (MEJOR CONTROL)
  Widget getPagina() {
    if (paginaActual == 0) {
      return const Center(
        child: Text(
          "Bienvenido al sistema 🚀",
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    if (paginaActual == 1) {
      return const AsignacionesPage();
    }

    if (paginaActual == 2) {
      return const UsuariosPage();
    }

    if (paginaActual == 3) {
      return CamionesPage(
        key: const ValueKey("camiones"), // 🔥 evita bugs de rebuild
        onGuardado: () {
          print("🔥 REGRESANDO AL HOME");
          cambiarPagina(0);
        },
      );
    }

    return const Center(child: Text("Página no encontrada"));
  }

  void cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro que deseas salir?"),
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
      appBar: AppBar(title: const Text("Menú Principal")),

      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "${widget.user["nombre"]} ${widget.user["apellido_paterno"]}",
              ),
              accountEmail: Text(widget.user["email"]),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),

            // 🔥 MENÚ DINÁMICO
            ...menuItems.map((item) {
              return ListTile(
                leading: Icon(item["icon"]),
                title: Text(item["title"]),
                onTap: () {
                  cambiarPagina(item["page"]);
                  Navigator.pop(context);
                },
              );
            }).toList(),

            const Spacer(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Cerrar sesión"),
              onTap: () {
                cerrarSesion(context);
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // 🔥 CONTENIDO
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300), // 👈 transición suave
        child: getPagina(),
      ),
    );
  }
}