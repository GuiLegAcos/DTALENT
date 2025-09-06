import 'package:flutter/material.dart';
import 'new_employee_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final List<Map<String, dynamic>> _users = [
    {
      "name": "Ana García",
      "email": "ana@dlab.software",
      "id": "#45",
      "country": "Argentina",
      "role": "Empleado"
    },
    {
      "name": "Gerardo Andres Cabrera",
      "email": "gerardo+e1@dlab.software",
      "id": "#123",
      "country": "Paraguaya",
      "role": "Empleado"
    },
    {
      "name": "dLab Demo",
      "email": "demo@dlab.software",
      "id": "#1",
      "country": "Paraguaya",
      "role": "Admin"
    },
  ];

  String _orden = "Más recientes";
  String? _filtroPais;

  void _agregarUsuario(Map<String, dynamic> nuevoUsuario) {
    setState(() {
      _users.add(nuevoUsuario);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filtrados = _users;

    if (_filtroPais != null) {
      filtrados = filtrados
          .where((u) => u["country"].toString().toLowerCase() ==
              _filtroPais!.toLowerCase())
          .toList();
    }

    if (_orden == "Más recientes") {
      filtrados = filtrados.reversed.toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Empleados"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (valor) {
              setState(() {
                _orden = valor;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: "Más recientes", child: Text("Más recientes")),
              const PopupMenuItem(
                  value: "Más antiguos", child: Text("Más antiguos")),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (valor) {
              setState(() {
                _filtroPais = valor == "Todos" ? null : valor;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "Todos", child: Text("Todos")),
              const PopupMenuItem(value: "Paraguaya", child: Text("Paraguaya")),
              const PopupMenuItem(value: "Argentina", child: Text("Argentina")),
            ],
          ),
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NewEmployeeScreen()),
              );
              if (result != null) {
                _agregarUsuario(result);
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filtrados.length,
        itemBuilder: (context, index) {
          final user = filtrados[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(user["name"].toString()[0]),
            ),
            title: Text(user["name"]),
            subtitle: Text(
                "${user["email"]}  •  ${user["id"]}  •  ${user["country"]}"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user["role"] == "Admin"
                    ? Colors.blue.shade100
                    : Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user["role"],
                style: TextStyle(
                  color: user["role"] == "Admin"
                      ? Colors.blue.shade800
                      : Colors.green.shade800,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

