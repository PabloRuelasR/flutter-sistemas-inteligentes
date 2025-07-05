import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReporteTemperaturaPage extends StatefulWidget {
  const ReporteTemperaturaPage({super.key});

  @override
  State<ReporteTemperaturaPage> createState() => _ReporteTemperaturaPageState();
}

class _ReporteTemperaturaPageState extends State<ReporteTemperaturaPage> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('lecturasSensor/Temperatura');

  List<Map<String, dynamic>> registros = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Resumen bonito al inicio
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.thermostat, color: Colors.orange, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Resumen de Temperatura',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Lecturas totales: ${registros.length}'),
              Text('Última lectura: ${registros.isNotEmpty ? registros.first['valor'].toString() + " °C" : "N/A"}'),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => generarPDF(registros),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generar PDF'),
              ),
            ],
          ),
        ),

        // Lista de registros
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream: ref.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                final rawData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                registros = rawData.entries
                    .where((entry) => entry.value is Map)
                    .map((entry) {
                  final data = entry.value as Map;
                  return {
                    "timestamp": data['timestamp'] ?? "",
                    "valor": data['valor'] ?? 0,
                  };
                }).toList();

                registros.sort((a, b) => b['timestamp'].toString().compareTo(a['timestamp'].toString()));

                return ListView.builder(
                  itemCount: registros.length,
                  itemBuilder: (context, index) {
                    final registro = registros[index];
                    String fecha = "Inválido";
                    try {
                      final dt = DateTime.parse(registro['timestamp']).toLocal();
                      fecha = DateFormat('yyyy-MM-dd hh:mm:ss a').format(dt);
                    } catch (_) {}

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.thermostat, color: Colors.orange),
                        title: Text('Temperatura: ${registro['valor']} °C'),
                        subtitle: Text(fecha),
                      ),
                    );
                  },
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  void generarPDF(List<Map<String, dynamic>> registros) async {
    final pdf = pw.Document();
    final logoImage = await imageFromAssetBundle('assets/logo.png');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(logoImage, height: 50),
                pw.Text('REPORTE DE TEMPERATURA', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text('Fecha de generación: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text('Historial de lecturas de temperatura', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['#', 'Temperatura (°C)', 'Fecha'],
              data: List.generate(registros.length, (index) {
                final registro = registros[index];
                String fecha = "Inválido";
                try {
                  final dt = DateTime.parse(registro['timestamp']).toLocal();
                  fecha = DateFormat('dd/MM/yyyy HH:mm:ss').format(dt);
                } catch (_) {}
                return [
                  (index + 1).toString(),
                  registro['valor'].toString(),
                  fecha,
                ];
              }),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: pw.BoxDecoration(color: PdfColors.orange),
              cellAlignment: pw.Alignment.centerLeft,
              border: pw.TableBorder.all(color: PdfColors.grey, width: 0.5),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
