actions: [
  PopupMenuButton<String>(
    icon: const Icon(Icons.more_vert),
    onSelected: (value) {
      switch (value) {
        case 'users':
          Navigator.pushNamed(context, '/users');
          break;
        case 'receipts':
          Navigator.pushNamed(context, '/receipts');
          break;
        case 'settings':
          Navigator.pushNamed(context, '/settings');
          break;
        case 'comunicados':
          Navigator.pushNamed(context, '/comunicados');
          break;
      }
    },
    itemBuilder: (context) => const [
      PopupMenuItem(value: 'users', child: Text('Empleados')),
      PopupMenuItem(value: 'receipts', child: Text('Recibos')),
      PopupMenuItem(value: 'comunicados', child: Text('Comunicados')),
      PopupMenuItem(value: 'settings', child: Text('Configuración')),
    ],
  ),
],

