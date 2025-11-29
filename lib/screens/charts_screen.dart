import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';
import '../models/sensor_data.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  ChartsScreenState createState() => ChartsScreenState();
}

class ChartsScreenState extends State<ChartsScreen> {
  String _selectedChart = 'temperature';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gráficos dos Sensores')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // header control
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Selecione o sensor',
                        style: Theme.of(context).textTheme.bodyMedium),
                    DropdownButton<String>(
                      value: _selectedChart,
                      onChanged: (String? newValue) {
                        setState(() => _selectedChart = newValue!);
                      },
                      items: <String>[
                        'temperature',
                        'humidity',
                        'soilMoisture',
                        'waterLevel'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(_getChartTitle(value)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    Provider.of<FirebaseService>(context).getSensorHistory(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.docs
                      .map((doc) => SensorData.fromMap(
                          doc.data() as Map<String, dynamic>))
                      .toList()
                      .reversed
                      .toList();

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(_getChartTitle(_selectedChart),
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 12),
                          Expanded(child: _buildLineChart(data)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart(List<SensorData> data) {
    if (data.isEmpty) return const Center(child: Text('Sem dados'));

    final points = <FlSpot>[];
    for (var i = 0; i < data.length; i++) {
      final d = data[i];
      double y;
      switch (_selectedChart) {
        case 'temperature':
          y = d.temperature;
          break;
        case 'humidity':
          y = d.humidity;
          break;
        case 'soilMoisture':
          y = d.soilMoisture;
          break;
        case 'waterLevel':
          y = d.waterLevel;
          break;
        default:
          y = 0.0;
      }
      points.add(FlSpot(i.toDouble(), y));
    }

    final minY = points.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    final ymax = points.map((p) => p.y).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval:
                  ((data.length - 1) / 4).clamp(1, data.length).toDouble(),
              getTitlesWidget: (value, meta) {
                final idx = value.toInt().clamp(0, data.length - 1);
                final date = data[idx].timestamp;
                return Text(
                  DateFormat('MM/dd HH:mm').format(date),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: minY - 1,
        maxY: ymax + 1,
        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: true,
            barWidth: 2,
            dotData: FlDotData(show: false),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  String _getChartTitle(String value) {
    switch (value) {
      case 'temperature':
        return 'Temperatura (°C)';
      case 'humidity':
        return 'Umidade do Ar (%)';
      case 'soilMoisture':
        return 'Umidade do Solo (%)';
      case 'waterLevel':
        return 'Nível de Água (%)';
      default:
        return '';
    }
  }
}
