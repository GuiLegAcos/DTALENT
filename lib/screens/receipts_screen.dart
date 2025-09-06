import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Receipt {
  Receipt({
    required this.type,
    required this.employee,
    required this.date,
    this.read = false,
    this.signed = false,
  });

  final String type; // p.ej. "LiqMensual"
  final String employee;
  final DateTime date;
  bool read;
  bool signed;
}

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  final _df = DateFormat('d/M/yyyy');

  var _items = <Receipt>[
    Receipt(type: 'LiqMensual', employee: 'dLab Demo #1', date: DateTime(2024, 1, 10), read: true),
    Receipt(type: 'LiqMensual', employee: 'Gerardo #123', date: DateTime(2024, 3, 1)),
    Receipt(type: 'Aguinaldo', employee: 'Ana #45', date: DateTime(2023, 12, 20), signed: true),
  ];

  bool _recentFirst = true;
  String _readFilter = 'Todos'; // Todos, Leídos, No leídos
  String _typeFilter = 'Todos'; // Todos, LiqMensual, Aguinaldo...

  List<String> get _types => ['Todos', ...{for (final r in _items) r.type}];

  List<Receipt> get _filtered {
    var list = [..._items];
    if (_readFilter == 'Leídos') list = list.where((e) => e.read).toList();
    if (_readFilter == 'No leídos') list = list.where((e) => !e.read).toList();
    if (_typeFilter != 'Todos') list = list.where((e) => e.type == _typeFilter).toList();
    list.sort((a, b) => _recentFirst ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    return list;
  }

  Future<void> _printReceipt(Receipt r) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('DTALENT APP', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Text('Recibo de sueldo'),
              pw.SizedBox(height: 24),
              pw.Text('Empleado: ${r.employee}'),
              pw.Text('Tipo: ${r.type}'),
              pw.Text('Fecha: ${_df.format(r.date)}'),
              pw.SizedBox(height: 24),
              pw.Text('Detalle:'),
              pw.Bullet(text: 'Concepto 1'),
              pw.Bullet(text: 'Concepto 2'),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Firma: ____________________'),
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ReceiptFilters(
          recentFirst: _recentFirst,
          onRecentFirstChanged: (v) => setState(() => _recentFirst = v),
          readFilter: _readFilter,
          onReadFilterChanged: (v) => setState(() => _readFilter = v),
          typeFilter: _typeFilter,
          typeItems: _types,
          onTypeFilterChanged: (v) => setState(() => _typeFilter = v),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: _filtered.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final r = _filtered[i];
              return ListTile(
                leading: Icon(r.read ? Icons.mark_email_read : Icons.mark_email_unread),
                title: Text('${r.type} – ${r.employee}'),
                subtitle: Text(_df.format(r.date)),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    if (r.signed)
                      const Chip(label: Text('Firmado'), avatar: Icon(Icons.check, size: 16), visualDensity: VisualDensity.compact),
                    IconButton(
                      tooltip: 'Imprimir',
                      icon: const Icon(Icons.print),
                      onPressed: () => _printReceipt(r),
                    ),
                  ],
                ),
                onTap: () => setState(() => r.read = true),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ReceiptFilters extends StatelessWidget {
  const _ReceiptFilters({
    required this.recentFirst,
    required this.onRecentFirstChanged,
    required this.readFilter,
    required this.onReadFilterChanged,
    required this.typeFilter,
    required this.typeItems,
    required this.onTypeFilterChanged,
  });

  final bool recentFirst;
  final ValueChanged<bool> onRecentFirstChanged;
  final String readFilter;
  final ValueChanged<String> onReadFilterChanged;
  final String typeFilter;
  final List<String> typeItems;
  final ValueChanged<String> onTypeFilterChanged;

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
          DropdownButton<String>(
            value: typeFilter,
            items: typeItems.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => onTypeFilterChanged(v ?? 'Todos'),
          ),
        ],
      ),
    );
  }
}

