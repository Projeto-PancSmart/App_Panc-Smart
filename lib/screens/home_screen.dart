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

          final size = MediaQuery.of(context).size;
          final width = size.width;

          // Responsive columns based on width
          int columns = 2;
          if (width < 600) {
            columns = 1;
          } else if (width < 1000) {
            columns = 2;
          } else if (width < 1400) {
            columns = 3;
          } else {
            columns = 4;
          }

          // Build a scrollable layout with an attractive header and responsive grid
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header / hero
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha((0.8 * 255).round()),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.08 * 255).round()),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bem-vindo de volta',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white70)),
                              const SizedBox(height: 8),
                              Text('Painel da Estufa',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.white)),
                              const SizedBox(height: 12),
                              Text(
                                  'Destaques de sustentabilidade e eficiência.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white70)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // small status indicators
                        Column(
                          children: [
                            Icon(Icons.eco,
                                size: 42,
                                color: Colors.white
                                    .withAlpha((0.95 * 255).round())),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Text('Sustentável',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Summary cards (quick glance)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: width < 600
                            ? double.infinity
                            : (width / columns) - 24,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Uso de Água',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    const SizedBox(height: 6),
                                    Text('Moderado',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(fontSize: 14)),
                                  ],
                                ),
                                const Icon(Icons.water_drop,
                                    size: 36, color: Colors.blueAccent),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width < 600
                            ? double.infinity
                            : (width / columns) - 24,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Eficiência',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    const SizedBox(height: 6),
                                    Text('Ótima',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(fontSize: 14)),
                                  ],
                                ),
                                const Icon(Icons.energy_savings_leaf,
                                    size: 36, color: Colors.green),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Responsive Grid
                  GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
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
                        icon: sensorData.isRaining
                            ? Icons.umbrella
                            : Icons.wb_sunny,
                        color:
                            sensorData.isRaining ? Colors.blue : Colors.orange,
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
                  ),
                ],
              ),
            ),
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
