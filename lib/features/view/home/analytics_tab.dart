import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  final DatabaseReference refHumedad = FirebaseDatabase.instance.ref(
    'lecturasSensor/Humedad',
  );
  final DatabaseReference refTemperatura = FirebaseDatabase.instance.ref(
    'lecturasSensor/Temperatura',
  );

  List<double> temperatureData = [];
  List<double> humidityData = [];

  double mediaTemp = 0;
  double mediaHum = 0;
  double desvTemp = 0;
  double desvHum = 0;
  double correlacion = 0;

  bool loading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchDataAndCompute();
  }

Future<void> fetchDataAndCompute() async {
  setState(() {
    loading = true;
  });

  final humSnap = await refHumedad.get();
  final tempSnap = await refTemperatura.get();

  temperatureData = [];
  humidityData = [];

  if (humSnap.exists && tempSnap.exists) {
    final rawH = humSnap.value as Map<dynamic, dynamic>;
    final rawT = tempSnap.value as Map<dynamic, dynamic>;

    final humValues = rawH.values.where((v) => v['timestamp'] != null && v['valor'] != null).toList();
    final tempValues = rawT.values.where((v) => v['timestamp'] != null && v['valor'] != null).toList();

    int limit = min(humValues.length, tempValues.length);

    for (int i = 0; i < limit; i++) {
      final humDate = DateTime.tryParse(humValues[i]['timestamp'].toString())?.toLocal();
      final tempDate = DateTime.tryParse(tempValues[i]['timestamp'].toString())?.toLocal();

      if (humDate != null && tempDate != null && _esMismoDia(humDate, _selectedDate) && _esMismoDia(tempDate, _selectedDate)) {
        double hum = double.tryParse(humValues[i]['valor'].toString()) ?? 0;
        double temp = double.tryParse(tempValues[i]['valor'].toString()) ?? 0;

        humidityData.add(hum);
        temperatureData.add(temp);

        debugPrint("📊 Registro $i: Temp = $temp °C, Hum = $hum %");
      }
    }

    if (temperatureData.isNotEmpty && humidityData.isNotEmpty) {
      calcularEstadisticas();
    }
  }

  setState(() {
    loading = false;
  });
}


  bool _esMismoDia(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void calcularEstadisticas() {
    mediaTemp =
        temperatureData.reduce((a, b) => a + b) / temperatureData.length;
    mediaHum = humidityData.reduce((a, b) => a + b) / humidityData.length;

    desvTemp = sqrt(
      temperatureData
              .map((e) => pow(e - mediaTemp, 2))
              .reduce((a, b) => a + b) /
          temperatureData.length,
    );
    desvHum = sqrt(
      humidityData.map((e) => pow(e - mediaHum, 2)).reduce((a, b) => a + b) /
          humidityData.length,
    );

    double sumProd = 0;
    for (int i = 0; i < temperatureData.length; i++) {
      sumProd +=
          (temperatureData[i] - mediaTemp) * (humidityData[i] - mediaHum);
    }

    correlacion = sumProd / (temperatureData.length * desvTemp * desvHum);
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      fetchDataAndCompute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.date_range, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('dd MMM yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _pickDate(context),
                    icon: const Icon(Icons.edit_calendar),
                    label: const Text("Cambiar fecha"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                "📈 Análisis de comportamiento ambiental",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),

              _buildCard("📊 Estadística Descriptiva", [
                _buildStat(
                  "Media de temperatura",
                  "${mediaTemp.toStringAsFixed(1)} °C",
                ),
                _buildStat(
                  "Media de humedad",
                  "${mediaHum.toStringAsFixed(1)} %",
                ),
                _buildStat(
                  "Desv. estándar temperatura",
                  "${desvTemp.toStringAsFixed(2)}",
                ),
                _buildStat(
                  "Desv. estándar humedad",
                  "${desvHum.toStringAsFixed(2)}",
                ),
              ]),

              const SizedBox(height: 16),

              _buildCard("🔍 Correlación entre temperatura y humedad", [
                Text(
                  correlacion.abs() > 0.3
                      ? "Existe una correlación de ${correlacion.toStringAsFixed(2)} entre temperatura y humedad."
                      : "No hay una correlación significativa entre temperatura y humedad.",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                temperatureData.isNotEmpty && humidityData.isNotEmpty
                    ? SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: ScatterChart(
                        ScatterChartData(
                          scatterSpots: List.generate(
                            temperatureData.length,
                            (i) => ScatterSpot(
                              temperatureData[i],
                              humidityData[i],
                            ),
                          ),
                          minX: temperatureData.reduce(min) - 1,
                          maxX: temperatureData.reduce(max) + 1,
                          minY: humidityData.reduce(min) - 5,
                          maxY: humidityData.reduce(max) + 5,
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 32,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          scatterTouchData: ScatterTouchData(enabled: false),
                        ),
                      ),
                    )
                    : const Text("No hay datos para mostrar en el gráfico."),

                const SizedBox(height: 8),
                const Text(
                  "Interpretación: Cada punto representa una lectura. Si tienden a alinearse diagonalmente, hay correlación.",
                  style: TextStyle(fontSize: 14),
                ),
              ]),

              const SizedBox(height: 24),
              const Text(
                "📌 Conclusión",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                correlacion < 0
                    ? "En promedio, la humedad baja cuando la temperatura aumenta, con una correlación de ${correlacion.toStringAsFixed(2)}."
                    : "Se detecta una ligera tendencia a que la humedad aumente con la temperatura, con una correlación de ${correlacion.toStringAsFixed(2)}.",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
  }

  Widget _buildStat(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
