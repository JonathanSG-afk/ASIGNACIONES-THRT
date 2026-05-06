import 'package:flutter/material.dart';
import 'asignation_page.dart';
import 'usuarios_page.dart';
import 'catalogos_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final Map user; // 👈 AHORA RECIBE TODO EL USUARIO

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaActual = 0;

  List<Map<String, dynamic>> menuItems = [];

  final List<Widget> paginas = [
    const Center(
      child: Text("Bienvenido al sistema 🚀", style: TextStyle(fontSize: 20)),
    ),
    const AsignacionesPage(),
    const UsuariosPage(),
    const CatalogosPage(),
  ];

  @override
  void initState() {
    super.initState();

    // 🔥 OBTENER ROL DESDE EL USER
    int rol = int.parse(widget.user["rol"].toString());

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
        //{"title": "Inicio", "icon": Icons.home, "page": 0},
        {"title": "Incidencias", "icon": Icons.assignment, "page": 1},
        //{"title": "Usuarios", "icon": Icons.people, "page": 2},
      ];
    } else {
      menuItems = [
        {"title": "Inicio", "icon": Icons.home, "page": 0},
      ];
    }
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
    int rol = int.parse(widget.user["rol"].toString());

    return Scaffold(
      appBar: AppBar(title: const Text("Menú Principal")),

      drawer: Drawer(
        child: Column(
          children: [
            // 🔥 HEADER CON DATOS REALES
            UserAccountsDrawerHeader(
              accountName: Text(
                "${widget.user["nombre"]} ${widget.user["apellido_paterno"]}",
              ),
              accountEmail: Text(widget.user["email"]),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),

            ...menuItems.map((item) {
              return ListTile(
                leading: Icon(item["icon"]),
                title: Text(item["title"]),
                onTap: () {
                  setState(() {
                    paginaActual = item["page"];
                  });
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

      body: paginas[paginaActual],
    );
  }
}
