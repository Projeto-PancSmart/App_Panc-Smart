import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../utils/responsive.dart';
import '../models/sensor_data.dart';
import './sensor_card.dart';
import 'controls/water_pump_control.dart';
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
        titleTextStyle: TextStyle(
          fontSize: Responsive.fontSize(context, 18),
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              size: Responsive.fontSize(context, 24),
            ),
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

          // Responsive columns based on breakpoints
          int columns;
          if (Responsive.isPhone(context)) {
            columns = 2; // Celular: 2 colunas
          } else if (Responsive.isTablet(context)) {
            columns = 3; // Tablet: 3 colunas
          } else {
            columns = 4; // Desktop: 4 colunas
          }

          final spacing = Responsive.scale(context, 12);
          final horizontalPadding = Responsive.scale(context, 16);
          
          // Cálculo da largura do card
          final usableWidth = width - (horizontalPadding * 2);
          final totalSpacing = spacing * (columns - 1);
          final cardWidth = (usableWidth - totalSpacing) / columns;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(Responsive.scale(context, 16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header / hero
                  Container(
                    padding: EdgeInsets.all(Responsive.scale(context, 20)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primary
                              .withAlpha((0.8 * 255).round()),
                        ], 
                        begin: Alignment.topLeft, 
                        end: Alignment.bottomRight
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.08 * 255).round()),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (Responsive.isPhone(context)) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bem-vindo de volta',
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(context, 14),
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: Responsive.scale(context, 8)),
                                  Text(
                                    'Painel da Estufa',
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(context, 24),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: Responsive.scale(context, 12)),
                                  Text(
                                    'Destaques de sustentabilidade e eficiência.',
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(context, 14),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Responsive.scale(context, 16)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.eco,
                                    size: Responsive.fontSize(context, 36),
                                    color: Colors.white
                                        .withAlpha((0.95 * 255).round())
                                  ),
                                  SizedBox(width: Responsive.scale(context, 12)),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Responsive.scale(context, 12),
                                      vertical: Responsive.scale(context, 6),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Text(
                                      'Sustentável',
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(context, 14),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }

                        // Layout para tablets/desktops
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bem-vindo de volta',
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(context, 16),
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: Responsive.scale(context, 8)),
                                  Text(
                                    'Painel da Estufa',
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(context, 28),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: Responsive.scale(context, 12)),
                                  Text(
                                    'Destaques de sustentabilidade e eficiência.',
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(context, 16),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Responsive.scale(context, 20)),
                            Column(
                              children: [
                                Icon(
                                  Icons.eco,
                                  size: Responsive.fontSize(context, 48),
                                  color: Colors.white
                                      .withAlpha((0.95 * 255).round())
                                ),
                                SizedBox(height: Responsive.scale(context, 12)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Responsive.scale(context, 16),
                                    vertical: Responsive.scale(context, 8),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Text(
                                    'Sustentável',
                                    style: TextStyle(
                                      fontSize: Responsive.fontSize(context, 16),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: Responsive.scale(context, 24)),

                  // Summary cards
                  Wrap(
                    spacing: Responsive.scale(context, 12),
                    runSpacing: Responsive.scale(context, 12),
                    children: [
                      SizedBox(
                        width: Responsive.isPhone(context)
                            ? double.infinity
                            : cardWidth,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(Responsive.scale(context, 16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Uso de Água',
                                        style: TextStyle(
                                          fontSize: Responsive.fontSize(context, 14),
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: Responsive.scale(context, 6)),
                                      Text(
                                        'Moderado',
                                        style: TextStyle(
                                          fontSize: Responsive.fontSize(context, 18),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.water_drop,
                                  size: Responsive.fontSize(context, 40), 
                                  color: Colors.blueAccent
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Responsive.isPhone(context)
                            ? double.infinity
                            : cardWidth,
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(Responsive.scale(context, 16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Eficiência',
                                        style: TextStyle(
                                          fontSize: Responsive.fontSize(context, 14),
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: Responsive.scale(context, 6)),
                                      Text(
                                        'Ótima',
                                        style: TextStyle(
                                          fontSize: Responsive.fontSize(context, 18),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.energy_savings_leaf,
                                  size: Responsive.fontSize(context, 40), 
                                  color: Colors.green
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Responsive.scale(context, 24)),

                  // Responsive Grid - Ajustado para evitar overflow
                  GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    // Ajustado para melhor proporção e evitar overflow
                    childAspectRatio: Responsive.isPhone(context) ? 0.85 : 1.0,
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
                      // Card da Bomba de Água
                      _buildControlCard(
                        context,
                        'Bomba de Água',
                        Icons.opacity,
                        Colors.blue,
                        const WaterPumpControlScreen(),
                      ),
                      // Card de Gráficos
                      _buildActionCard(
                        context,
                        'Gráficos',
                        Icons.show_chart,
                        Colors.red,
                        const ChartsScreen(),
                      ),
                      // Card de Dicas de Plantas
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
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen)),
        child: Padding(
          padding: EdgeInsets.all(Responsive.scale(context, 12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.scale(context, 8)),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon, 
                  size: Responsive.fontSize(context, 24), 
                  color: color
                ),
              ),
              SizedBox(height: Responsive.scale(context, 8)),
              Text(
                title, 
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Responsive.scale(context, 4)),
              Text(
                'Controle',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 12),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon,
      Color color, Widget screen) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen)),
        child: Padding(
          padding: EdgeInsets.all(Responsive.scale(context, 12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(Responsive.scale(context, 8)),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon, 
                  size: Responsive.fontSize(context, 24), 
                  color: color
                ),
              ),
              SizedBox(height: Responsive.scale(context, 8)),
              Text(
                title, 
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Responsive.scale(context, 4)),
              Text(
                'Visualizar',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 12),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}