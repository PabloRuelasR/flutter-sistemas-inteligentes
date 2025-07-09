import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReporteTimbrePage extends StatefulWidget {
  const ReporteTimbrePage({super.key});

  @override
  State<ReporteTimbrePage> createState() => _ReporteTimbrePageState();
}

class _ReporteTimbrePageState extends State<ReporteTimbrePage> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref(
    'eventosTimbre/C56umbwmLOvvc2ePXH99',
  );
  List<Map<String, dynamic>> registros = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.redAccent),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.notifications, color: Colors.redAccent, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Resumen de Timbre',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Total de eventos: ${registros.length}'),
              Text(
                'Última activación: ${registros.isNotEmpty ? registros.first['timestamp'] : "N/A"}',
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => generarPDF(List.from(registros)),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generar PDF'),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<DatabaseEvent>(
            stream: ref.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                final rawData =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                registros =
                    rawData.entries.where((entry) => entry.value is Map).map((
                      entry,
                    ) {
                      final data = entry.value as Map;
                      return {
                        "timestamp": data['timestamp'] ?? "",
                        "mensaje": data['mensaje'] ?? "",
                      };
                    }).toList();

                registros.sort(
                  (a, b) => b['timestamp'].toString().compareTo(
                    a['timestamp'].toString(),
                  ),
                );

                return ListView.builder(
                  itemCount: registros.length,
                  itemBuilder: (context, index) {
                    final registro = registros[index];
                    String fecha = "Inválido";
                    try {
                      final dt =
                          DateTime.parse(registro['timestamp']).toLocal();
                      fecha = DateFormat('yyyy-MM-dd hh:mm:ss a').format(dt);
                    } catch (_) {}
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.notifications,
                          color: Colors.redAccent,
                        ),
                        title: Text(registro['mensaje']),
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

    final hoy = DateTime.now();
    final registrosHoy =
        registros.where((r) {
          try {
            final dt = DateTime.parse(r['timestamp']).toLocal();
            return dt.year == hoy.year &&
                dt.month == hoy.month &&
                dt.day == hoy.day;
          } catch (_) {
            return false;
          }
        }).toList();

    final Map<String, int> eventosPorHora = {};
    for (var reg in registrosHoy) {
      try {
        final dt = DateTime.parse(reg['timestamp']).toLocal();
        final hIni = dt.hour.toString().padLeft(2, '0');
        final hFin = (dt.hour + 1).toString().padLeft(2, '0');
        final clave = '$hIni:00 - $hFin:00';
        eventosPorHora[clave] = (eventosPorHora[clave] ?? 0) + 1;
      } catch (_) {}
    }

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
                pw.Text(
                  'REPORTE DE TIMBRE',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Fecha de generación: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),

            // Enfoque 2
            pw.Text(
              '[Análisis] Eventos del timbre y uso del foco',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),

            pw.SizedBox(height: 5),
            pw.Text(
              'A continuación se muestra la cantidad de veces que se presionó el timbre durante el día actual.',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 10),

            pw.Table.fromTextArray(
              headers: ['Hora', 'Eventos'],
              data:
                  eventosPorHora.entries
                      .map((e) => [e.key, e.value.toString()])
                      .toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(color: PdfColors.deepOrange),
              border: pw.TableBorder.all(color: PdfColors.grey, width: 0.5),
              cellStyle: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Resultado:\n${resumenEventosPorHora(eventosPorHora)}',
              style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
            ),
            pw.SizedBox(height: 20),

            pw.Text(
              'Resumen de Eventos',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.Table.fromTextArray(
              headers: ['#', 'Mensaje', 'Fecha'],
              data: List.generate(registros.length, (index) {
                final registro = registros[index];
                String fecha = "Inválido";
                try {
                  final dt = DateTime.parse(registro['timestamp']).toLocal();
                  fecha = DateFormat('dd/MM/yyyy HH:mm:ss').format(dt);
                } catch (_) {}
                return [(index + 1).toString(), registro['mensaje'], fecha];
              }),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(color: PdfColors.redAccent),
              border: pw.TableBorder.all(color: PdfColors.grey, width: 0.5),
              cellStyle: const pw.TextStyle(fontSize: 10),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  String resumenEventosPorHora(Map<String, int> eventosPorHora) {
    if (eventosPorHora.isEmpty) return "No hay eventos registrados hoy.";
    final entradaPeak = eventosPorHora.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );
    return 'El timbre se presionó más entre ${entradaPeak.key}, con un total de ${entradaPeak.value} veces.';
  }
}
