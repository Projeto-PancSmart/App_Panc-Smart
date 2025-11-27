import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../models/sensor_data.dart';
import './sensor_card.dart';
import './controls/water_pump_control.dart';
import './controls/sensor_control.dart';
import './controls/lcd_control.dart';
import './controls/led_control.dart';
import './charts_screen.dart';
import './settings_screen.dart';
import './plant_tips_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estufa Inteligente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<SensorData>(
        stream: Provider.of<FirebaseService>(context).getSensorData(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            debugPrint('getSensorData stream error: ${snapshot.error}');
          }

          final sensorData = snapshot.data ??
              SensorData(
                temperature: 0.0,
                humidity: 0.0,
                soilMoisture: 0.0,
                waterLevel: 0.0,
                isRaining: false,
                timestamp: DateTime.now(),
              );

          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            children: [
              SensorCard(
                title: 'Temperatura',
                value: '${sensorData.temperature.toStringAsFixed(1)}°C',
                icon: Icons.thermostat,
                color: Colors.orange,
              ),
              SensorCard(
                title: 'Umidade',
                value: '${sensorData.humidity.toStringAsFixed(1)}%',
                icon: Icons.water_drop,
                color: Colors.blue,
              ),
              SensorCard(
                title: 'Umidade Solo',
                value: '${sensorData.soilMoisture.toStringAsFixed(1)}%',
                icon: Icons.grass,
                color: Colors.brown,
              ),
              SensorCard(
                title: 'Nível Água',
                value: '${sensorData.waterLevel.toStringAsFixed(1)}%',
                icon: Icons.invert_colors,
                color: Colors.cyan,
              ),
              SensorCard(
                title: 'Chuva',
                value: sensorData.isRaining ? 'Chovendo' : 'Sem Chuva',
                icon: sensorData.isRaining ? Icons.umbrella : Icons.wb_sunny,
                color: sensorData.isRaining ? Colors.blue : Colors.orange,
              ),
              _buildControlCard(
                context,
                'Bomba de Água',
                Icons.opacity,
                Colors.blue,
                const WaterPumpControlScreen(),
              ),
              _buildControlCard(
                context,
                'Sensores',
                Icons.sensors,
                Colors.green,
                const SensorControlScreen(),
              ),
              _buildControlCard(
                context,
                'Display LCD',
                Icons.tv,
                Colors.purple,
                const LcdControlScreen(),
              ),
              _buildControlCard(
                context,
                'LED',
                Icons.lightbulb,
                Colors.yellow,
                const LedControlScreen(),
              ),
              _buildActionCard(
                context,
                'Gráficos',
                Icons.show_chart,
                Colors.red,
                const ChartsScreen(),
              ),
              _buildActionCard(
                context,
                'Dicas Plantas',
                Icons.spa,
                Colors.green,
                const PlantTipsScreen(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlCard(BuildContext context, String title, IconData icon,
      Color color, Widget screen) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon,
      Color color, Widget screen) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
