import 'package:flutter/material.dart';

class Communication {
  Communication({required this.title, required this.date, this.read = false});
  final String title;
  final DateTime date;
  bool read;
}

class CommunicationsScreen extends StatefulWidget {
  const CommunicationsScreen({super.key});
  @override
  State<CommunicationsScreen> createState() => _CommunicationsScreenState();
}

class _CommunicationsScreenState extends State<CommunicationsScreen> {
  var _items = <Communication>[
    Communication(title: 'Actualización de políticas', date: DateTime.now().subtract(const Duration(days: 2)), read: true),
    Communication(title: 'Mantenimiento programado', date: DateTime.now().subtract(const Duration(days: 9))),
    Communication(title: 'Campaña de salud', date: DateTime.now().subtract(const Duration(days: 30))),
  ];

  bool _recentFirst = true;
  String _readFilter = 'Todos'; // Todos, Leídos, No leídos

  List<Communication> get _filtered {
    var list = [..._items];
    if (_readFilter == 'Leídos') {
      list = list.where((e) => e.read).toList();
    } else if (_readFilter == 'No leídos') {
      list = list.where((e) => !e.read).toList();
    }
    list.sort((a, b) => _recentFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Filters(
          recentFirst: _recentFirst,
          onRecentFirstChanged: (v) => setState(() => _recentFirst = v),
          readFilter: _readFilter,
          onReadFilterChanged: (v) => setState(() => _readFilter = v),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: _filtered.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final c = _filtered[i];
              return ListTile(
                leading: Icon(c.read ? Icons.mark_email_read : Icons.mark_email_unread),
                title: Text(c.title),
                subtitle: Text('${c.date.toLocal()}'),
                trailing: IconButton(
                  icon: const Icon(Icons.done_all),
                  tooltip: 'Marcar leído',
                  onPressed: () => setState(() => c.read = true),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.recentFirst,
    required this.onRecentFirstChanged,
    required this.readFilter,
    required this.onReadFilterChanged,
  });

  final bool recentFirst;
  final ValueChanged<bool> onRecentFirstChanged;
  final String readFilter;
  final ValueChanged<String> onReadFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FilterChip(
            label: Text(recentFirst ? 'Más recientes' : 'Más antiguos'),
            selected: true,
            onSelected: (_) => onRecentFirstChanged(!recentFirst),
          ),
          DropdownButton<String>(
            value: readFilter,
            items: const [
              DropdownMenuItem(value: 'Todos', child: Text('Todos')),
              DropdownMenuItem(value: 'Leídos', child: Text('Leídos')),
              DropdownMenuItem(value: 'No leídos', child: Text('No leídos')),
            ],
            onChanged: (v) => onReadFilterChanged(v ?? 'Todos'),
          ),
        ],
      ),
    );
  }
}

