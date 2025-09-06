import 'package:flutter/material.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile.adaptive(
              value: isDark,
              title: const Text('Tema oscuro'),
              subtitle: const Text('Activar/desactivar modo oscuro'),
              onChanged: (val) {
                themeMode.value = val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de dLab'),
              subtitle: const Text(
                'dLab es una empresa de tecnología que diseña y desarrolla '
                'apps, sistemas y soluciones digitales a medida.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Sitio y contacto'),
              subtitle: const Text(
                'Website: dlab.software\nEmail: hola@dlab.software',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

