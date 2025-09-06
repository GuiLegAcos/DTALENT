import 'package:flutter/material.dart';
import 'users_screen.dart';
import 'receipts_screen.dart';
import 'communications_screen.dart';
import 'settings_screen.dart';

enum Module { users, receipts, communications, settings }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Module? _selected; // null => portada

  final _pages = const {
    Module.users: UsersScreen(),
    Module.receipts: ReceiptsScreen(),
    Module.communications: CommunicationsScreen(),
    Module.settings: SettingsScreen(),
  };

  String get _title {
    switch (_selected) {
      case Module.users:
        return 'Empleados';
      case Module.receipts:
        return 'Recibos';
      case Module.communications:
        return 'Comunicados';
      case Module.settings:
        return 'Configuración';
      default:
        return 'Bienvenido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        // ⋮ a la IZQUIERDA
        leading: PopupMenuButton<Module>(
          tooltip: 'Seleccionar módulo',
          icon: const Icon(Icons.more_vert),
          onSelected: (m) => setState(() => _selected = m),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: Module.users,
              child: Row(children: [Icon(Icons.people), SizedBox(width: 12), Text('Empleados')]),
            ),
            PopupMenuItem(
              value: Module.receipts,
              child: Row(children: [Icon(Icons.receipt_long), SizedBox(width: 12), Text('Recibos')]),
            ),
            PopupMenuItem(
              value: Module.communications,
              child: Row(children: [Icon(Icons.campaign), SizedBox(width: 12), Text('Comunicados')]),
            ),
            PopupMenuItem(
              value: Module.settings,
              child: Row(children: [Icon(Icons.settings), SizedBox(width: 12), Text('Configuración')]),
            ),
          ],
        ),
      ),
      body: _selected == null
          ? _Welcome(theme: theme)
          : _pages[_selected]!,
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Bienvenido a', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Image.asset('assets/dTalentLogo.png', height: 80),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Opacity(
            opacity: 0.7,
            child: Text(
              'Seleccioná los módulos desde el menú ⋮ (arriba a la izquierda).',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

