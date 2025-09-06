import 'package:flutter/material.dart';

class ComunicadosScreen extends StatefulWidget {
  const ComunicadosScreen({super.key});

  @override
  State<ComunicadosScreen> createState() => _ComunicadosScreenState();
}

class _ComunicadosScreenState extends State<ComunicadosScreen> {
  String _filtro = "Todos";

  final List<Map<String, dynamic>> _comunicados = [
    {"titulo": "Mantenimiento programado", "leido": false, "fecha": DateTime(2025, 9, 1)},
    {"titulo": "Nuevo beneficio para empleados", "leido": true, "fecha": DateTime(2025, 8, 20)},
    {"titulo": "Cambio de horario", "leido": false, "fecha": DateTime(2025, 7, 15)},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filtrados = _filtro == "Todos"
        ? _comunicados
        : _comunicados.where((c) => _filtro == "Leídos" ? c["leido"] : !c["leido"]).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comunicados"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => setState(() => _filtro = val),
            itemBuilder: (_) => const [
              PopupMenuItem(value: "Todos", child: Text("Todos")),
              PopupMenuItem(value: "Leídos", child: Text("Leídos")),
              PopupMenuItem(value: "No leídos", child: Text("No leídos")),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filtrados.length,
        itemBuilder: (_, i) {
          final c = filtrados[i];
          return ListTile(
            leading: Icon(c["leido"] ? Icons.mark_email_read : Icons.mark_email_unread),
            title: Text(c["titulo"]),
            subtitle: Text("Fecha: ${c["fecha"].toLocal()}".split(" ")[0]),
            trailing: c["leido"] ? const Text("Leído") : const Text("No leído"),
          );
        },
      ),
    );
  }
}

