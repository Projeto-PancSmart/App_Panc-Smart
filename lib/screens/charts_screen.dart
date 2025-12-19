import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firebase_service.dart';
import '../models/sensor_data.dart';
import '../utils/responsive.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  ChartsScreenState createState() => ChartsScreenState();
}

class ChartsScreenState extends State<ChartsScreen> with SingleTickerProviderStateMixin {
  String _selectedChart = 'temperature';
  List<SensorData> _historyData = [];
  DateTime _lastUpdate = DateTime.now();
  late TabController _tabController;
  
  // Dados para os gráficos
  final Map<String, List<FlSpot>> _chartData = {
    'temperature': [],
    'humidity': [],
    'soilMoisture': [],
    'waterLevel': [],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Inicializa com dados fictícios para teste
    _initializeSampleData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeSampleData() {
    final now = DateTime.now();
    _historyData = List.generate(12, (index) {
      final time = now.subtract(Duration(hours: 11 - index));
      return SensorData(
        temperature: 25.0 + (index % 3) * 2,
        humidity: 50.0 + (index % 4) * 5,
        soilMoisture: 40.0 + (index % 5) * 3,
        waterLevel: 80.0 - (index % 2) * 10,
        isRaining: index % 4 == 0,
        timestamp: time,
      );
    });
    
    // Prepara dados para todos os gráficos
    _updateAllChartData();
  }

  void _updateAllChartData() {
    final categories = ['temperature', 'humidity', 'soilMoisture', 'waterLevel'];
    for (var category in categories) {
      _chartData[category] = _generateChartData(category);
    }
  }

  List<FlSpot> _generateChartData(String category) {
    return List.generate(_historyData.length, (index) {
      final data = _historyData[index];
      double value;
      switch (category) {
        case 'temperature':
          value = data.temperature;
          break;
        case 'humidity':
          value = data.humidity;
          break;
        case 'soilMoisture':
          value = data.soilMoisture;
          break;
        case 'waterLevel':
          value = data.waterLevel;
          break;
        default:
          value = 0;
      }
      return FlSpot(index.toDouble(), value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise de Dados'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.show_chart), text: 'Gráficos'),
            Tab(icon: Icon(Icons.table_chart), text: 'Tabela'),
          ],
          labelStyle: TextStyle(fontSize: Responsive.fontSize(context, 12)),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChartsTab(),
          _buildDataTableTab(),
        ],
      ),
    );
  }

  Widget _buildChartsTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabeçalho informativo
                _buildHeaderInfo(),
                
                // Seletor de gráfico
                _buildChartSelector(),
                
                // Container do gráfico principal
                Container(
                  margin: EdgeInsets.all(Responsive.scale(context, 12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título do gráfico
                      Padding(
                        padding: EdgeInsets.all(Responsive.scale(context, 16)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getChartTitle(),
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 18),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  'Últimas 12 horas',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 12),
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            _buildValueIndicator(),
                          ],
                        ),
                      ),
                      
                      // Gráfico principal
                      SizedBox(
                        height: 250,
                        child: Padding(
                          padding: EdgeInsets.all(Responsive.scale(context, 8)),
                          child: _buildMainChart(),
                        ),
                      ),
                      
                      // Legenda e controles
                      _buildChartFooter(),
                    ],
                  ),
                ),
                
                // Mini gráficos rápidos - VISÃO GERAL CORRIGIDA
                _buildMiniChartsSection(),
                
                // Estatísticas
                _buildStatistics(),
                
                // Botão de atualizar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _refreshData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Atualizar Dados'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                
                // ESPAÇO EXTRA no final para evitar overflow
                SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      margin: EdgeInsets.all(Responsive.scale(context, 12)),
      padding: EdgeInsets.all(Responsive.scale(context, 16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.green.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            size: Responsive.fontSize(context, 32),
            color: Colors.blue.shade700,
          ),
          SizedBox(width: Responsive.scale(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monitoramento em Tempo Real',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 16),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: Responsive.scale(context, 4)),
                Text(
                  'Dados coletados a cada 30 minutos',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 12),
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Atualizado: ${_lastUpdate.hour.toString().padLeft(2, '0')}:${_lastUpdate.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 10),
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSelector() {
    final List<Map<String, dynamic>> chartTypes = [
      {
        'id': 'temperature',
        'icon': Icons.thermostat,
        'label': 'Temperatura',
        'color': Colors.red,
        'unit': '°C'
      },
      {
        'id': 'humidity',
        'icon': Icons.water_drop,
        'label': 'Umidade',
        'color': Colors.blue,
        'unit': '%'
      },
      {
        'id': 'soilMoisture',
        'icon': Icons.grass,
        'label': 'Solo',
        'color': Colors.green,
        'unit': '%'
      },
      {
        'id': 'waterLevel',
        'icon': Icons.opacity,
        'label': 'Água',
        'color': Colors.cyan,
        'unit': '%'
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.scale(context, 12),
        vertical: Responsive.scale(context, 8),
      ),
      child: Row(
        children: chartTypes.map((type) {
          final isSelected = _selectedChart == type['id'];
          final color = type['color'] as Color;
          final id = type['id'] as String;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedChart = id),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Responsive.scale(context, 4)),
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.scale(context, 16),
                vertical: Responsive.scale(context, 10),
              ),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Icon(
                    type['icon'] as IconData,
                    color: isSelected ? Colors.white : color,
                    size: Responsive.fontSize(context, 16),
                  ),
                  SizedBox(width: Responsive.scale(context, 6)),
                  Text(
                    type['label'] as String,
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 12),
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainChart() {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: _historyData.isNotEmpty ? (_historyData.length - 1).toDouble() : 0,
        minY: 0,
        maxY: _getMaxYValue(),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: _getGridInterval(),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[200]!,
              strokeWidth: 1,
              dashArray: const [5, 5],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < _historyData.length) {
                  final time = _historyData[index].timestamp;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${time.hour.toString().padLeft(2, '0')}:00',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 10),
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _getGridInterval(),
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '${value.toInt()}${_getUnit()}',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 10),
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _chartData[_selectedChart] ?? [],
            isCurved: true,
            curveSmoothness: 0.3,
            color: _getChartColor(),
            barWidth: 4,
            shadow: Shadow(
              color: _getChartColor().withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  _getChartColor().withOpacity(0.3),
                  _getChartColor().withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: _getChartColor(),
                );
              },
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                final index = touchedSpot.x.toInt();
                if (index >= 0 && index < _historyData.length) {
                  final data = _historyData[index];
                  final time = data.timestamp;
                  
                  return LineTooltipItem(
                    '${touchedSpot.y.toStringAsFixed(1)}${_getUnit()} - ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                    TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.fontSize(context, 12),
                    ),
                  );
                }
                return LineTooltipItem('', const TextStyle());
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildValueIndicator() {
    if (_historyData.isEmpty) return const SizedBox();
    
    final currentValue = _getCurrentValue();
    final unit = _getUnit();
    final avgValue = _getAverageValue();
    final diff = currentValue - avgValue;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.scale(context, 12),
        vertical: Responsive.scale(context, 6),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            '${currentValue.toStringAsFixed(1)}$unit',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: _getChartColor(),
            ),
          ),
          Text(
            diff > 0 ? '+${diff.toStringAsFixed(1)}' : diff.toStringAsFixed(1),
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 10),
              color: diff > 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartFooter() {
    return Padding(
      padding: EdgeInsets.all(Responsive.scale(context, 16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem('Mínimo', _getMinValue().toStringAsFixed(1)),
          _buildStatItem('Média', _getAverageValue().toStringAsFixed(1)),
          _buildStatItem('Máximo', _getMaxValue().toStringAsFixed(1)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 10),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: Responsive.scale(context, 4)),
        Text(
          '$value${_getUnit()}',
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 14),
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // VISÃO GERAL CORRIGIDA - TODOS OS 4 GRÁFICOS VISÍVEIS
  Widget _buildMiniChartsSection() {
    final List<Map<String, dynamic>> charts = [
      {'id': 'temperature', 'color': Colors.red, 'label': 'Temperatura'},
      {'id': 'humidity', 'color': Colors.blue, 'label': 'Umidade'},
      {'id': 'soilMoisture', 'color': Colors.green, 'label': 'Solo'},
      {'id': 'waterLevel', 'color': Colors.cyan, 'label': 'Água'},
    ];

    return Container(
      margin: EdgeInsets.all(Responsive.scale(context, 12)),
      padding: EdgeInsets.all(Responsive.scale(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '📊 Visão Geral',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 16),
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: Responsive.scale(context, 12)),
          
          // Layout responsivo: 2x2 grid
          Column(
            children: [
              // Primeira linha: Temperatura e Umidade
              Row(
                children: [
                  Expanded(child: _buildMiniChartCard(charts[0])),
                  SizedBox(width: Responsive.scale(context, 12)),
                  Expanded(child: _buildMiniChartCard(charts[1])),
                ],
              ),
              SizedBox(height: Responsive.scale(context, 12)),
              // Segunda linha: Solo e Água
              Row(
                children: [
                  Expanded(child: _buildMiniChartCard(charts[2])),
                  SizedBox(width: Responsive.scale(context, 12)),
                  Expanded(child: _buildMiniChartCard(charts[3])),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChartCard(Map<String, dynamic> chart) {
    final String chartId = chart['id'];
    final Color color = chart['color'];
    final String label = chart['label'];
    
    final data = _chartData[chartId] ?? [];
    final currentValue = _getValueForChart(chartId);
    
    return GestureDetector(
      onTap: () => setState(() => _selectedChart = chartId),
      child: Container(
        padding: EdgeInsets.all(Responsive.scale(context, 12)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedChart == chartId ? color : Colors.grey[200]!,
            width: _selectedChart == chartId ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: Responsive.scale(context, 32),
                  height: Responsive.scale(context, 32),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIconForChart(chartId),
                    color: color,
                    size: Responsive.fontSize(context, 16),
                  ),
                ),
                SizedBox(width: Responsive.scale(context, 8)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 12),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        '${currentValue.toStringAsFixed(1)}${_getUnitForChart(chartId)}',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 14),
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Responsive.scale(context, 8)),
            // Mini gráfico
            Container(
              height: 30,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: data.isNotEmpty ? (data.length - 1).toDouble() : 0,
                  minY: data.isNotEmpty ? _getMinFromData(data) - 5 : 0,
                  maxY: data.isNotEmpty ? _getMaxFromData(data) + 5 : 0,
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: color,
                      barWidth: 1,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Container(
      margin: EdgeInsets.all(Responsive.scale(context, 12)),
      padding: EdgeInsets.all(Responsive.scale(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '📈 Estatísticas do Sistema',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 16),
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: Responsive.scale(context, 16)),
          Row(
            children: [
              _buildStatCard('Total de Leituras', '${_historyData.length}', Icons.bar_chart),
              SizedBox(width: Responsive.scale(context, 12)),
              _buildStatCard('Período', '12h', Icons.access_time),
              SizedBox(width: Responsive.scale(context, 12)),
              _buildStatCard('Status', 'Ativo', Icons.check_circle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(Responsive.scale(context, 12)),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.blue.shade700, size: Responsive.fontSize(context, 20)),
            SizedBox(height: Responsive.scale(context, 8)),
            Text(
              value,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 14),
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 10),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTableTab() {
    return StreamBuilder<SensorData>(
      stream: Provider.of<FirebaseService>(context).listenSensorRealtime(),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabeçalho com dados atuais
              if (snapshot.hasData) _buildCurrentDataHeader(snapshot.data!),
              
              // Tabela de histórico
              _buildDataTable(),
              SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentDataHeader(SensorData data) {
    return Container(
      margin: EdgeInsets.all(Responsive.scale(context, 12)),
      padding: EdgeInsets.all(Responsive.scale(context, 16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.green.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '📈 Dados em Tempo Real',
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: Responsive.scale(context, 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLiveDataItem('🌡️', '${data.temperature.toStringAsFixed(1)}°C', Colors.red),
              _buildLiveDataItem('💧', '${data.humidity.toStringAsFixed(0)}%', Colors.blue),
              _buildLiveDataItem('🌱', '${data.soilMoisture.toStringAsFixed(0)}%', Colors.green),
              _buildLiveDataItem('💦', '${data.waterLevel.toStringAsFixed(0)}%', Colors.cyan),
            ],
          ),
          SizedBox(height: Responsive.scale(context, 12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(data.isRaining ? Icons.cloud : Icons.wb_sunny, 
                  color: data.isRaining ? Colors.blue : Colors.orange),
              SizedBox(width: 8),
              Text(
                data.isRaining ? 'Chovendo' : 'Sem chuva',
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 14),
                  color: data.isRaining ? Colors.blue : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveDataItem(String icon, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Responsive.scale(context, 40),
          height: Responsive.scale(context, 40),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              icon,
              style: TextStyle(fontSize: Responsive.fontSize(context, 20)),
            ),
          ),
        ),
        SizedBox(height: Responsive.scale(context, 4)),
        Text(
          value,
          style: TextStyle(
            fontSize: Responsive.fontSize(context, 14),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return Container(
      margin: EdgeInsets.all(Responsive.scale(context, 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.blue.shade50,
          ),
          columns: const [
            DataColumn(label: Text('Hora')),
            DataColumn(label: Text('Temperatura')),
            DataColumn(label: Text('Umidade')),
            DataColumn(label: Text('Solo')),
            DataColumn(label: Text('Água')),
            DataColumn(label: Text('Chuva')),
          ],
          rows: _historyData.reversed.take(10).map((data) {
            return DataRow(
              cells: [
                DataCell(Text(
                  '${data.timestamp.hour.toString().padLeft(2, '0')}:'
                  '${data.timestamp.minute.toString().padLeft(2, '0')}',
                )),
                DataCell(Text('${data.temperature.toStringAsFixed(1)}°C')),
                DataCell(Text('${data.humidity.toStringAsFixed(0)}%')),
                DataCell(Text('${data.soilMoisture.toStringAsFixed(0)}%')),
                DataCell(Text('${data.waterLevel.toStringAsFixed(0)}%')),
                DataCell(Icon(
                  data.isRaining ? Icons.cloud : Icons.wb_sunny,
                  color: data.isRaining ? Colors.blue : Colors.orange,
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // Métodos auxiliares
  double _getCurrentValue() {
    if (_historyData.isEmpty) return 0;
    final data = _historyData.last;
    switch (_selectedChart) {
      case 'temperature': return data.temperature;
      case 'humidity': return data.humidity;
      case 'soilMoisture': return data.soilMoisture;
      case 'waterLevel': return data.waterLevel;
      default: return 0;
    }
  }

  double _getValueForChart(String chartId) {
    if (_historyData.isEmpty) return 0;
    final data = _historyData.last;
    switch (chartId) {
      case 'temperature': return data.temperature;
      case 'humidity': return data.humidity;
      case 'soilMoisture': return data.soilMoisture;
      case 'waterLevel': return data.waterLevel;
      default: return 0;
    }
  }

  double _getMinValue() {
    if (_historyData.isEmpty) return 0;
    
    double minValue = double.infinity;
    for (final data in _historyData) {
      double value;
      switch (_selectedChart) {
        case 'temperature':
          value = data.temperature;
          break;
        case 'humidity':
          value = data.humidity;
          break;
        case 'soilMoisture':
          value = data.soilMoisture;
          break;
        case 'waterLevel':
          value = data.waterLevel;
          break;
        default:
          value = 0;
      }
      if (value < minValue) {
        minValue = value;
      }
    }
    return minValue == double.infinity ? 0 : minValue;
  }

  double _getMaxValue() {
    if (_historyData.isEmpty) return 0;
    
    double maxValue = -double.infinity;
    for (final data in _historyData) {
      double value;
      switch (_selectedChart) {
        case 'temperature':
          value = data.temperature;
          break;
        case 'humidity':
          value = data.humidity;
          break;
        case 'soilMoisture':
          value = data.soilMoisture;
          break;
        case 'waterLevel':
          value = data.waterLevel;
          break;
        default:
          value = 0;
      }
      if (value > maxValue) {
        maxValue = value;
      }
    }
    return maxValue == -double.infinity ? 0 : maxValue;
  }

  double _getAverageValue() {
    if (_historyData.isEmpty) return 0;
    double sum = 0;
    int count = 0;
    
    for (final data in _historyData) {
      double value;
      switch (_selectedChart) {
        case 'temperature':
          value = data.temperature;
          break;
        case 'humidity':
          value = data.humidity;
          break;
        case 'soilMoisture':
          value = data.soilMoisture;
          break;
        case 'waterLevel':
          value = data.waterLevel;
          break;
        default:
          value = 0;
      }
      sum += value;
      count++;
    }
    
    return count > 0 ? sum / count : 0;
  }

  double _getMaxYValue() {
    final maxValue = _getMaxValue();
    return maxValue * 1.1; // 10% de margem
  }

  double _getGridInterval() {
    final max = _getMaxValue();
    final min = _getMinValue();
    final range = max - min;
    if (range <= 10) return 2;
    if (range <= 20) return 5;
    if (range <= 50) return 10;
    return 20;
  }

  String _getChartTitle() {
    switch (_selectedChart) {
      case 'temperature': return 'Temperatura';
      case 'humidity': return 'Umidade do Ar';
      case 'soilMoisture': return 'Umidade do Solo';
      case 'waterLevel': return 'Nível de Água';
      default: return '';
    }
  }

  String _getChartTitleForId(String chartId) {
    switch (chartId) {
      case 'temperature': return 'Temperatura';
      case 'humidity': return 'Umidade';
      case 'soilMoisture': return 'Solo';
      case 'waterLevel': return 'Água';
      default: return '';
    }
  }

  String _getUnit() {
    switch (_selectedChart) {
      case 'temperature': return '°C';
      case 'humidity': return '%';
      case 'soilMoisture': return '%';
      case 'waterLevel': return '%';
      default: return '';
    }
  }

  String _getUnitForChart(String chartId) {
    switch (chartId) {
      case 'temperature': return '°C';
      case 'humidity': return '%';
      case 'soilMoisture': return '%';
      case 'waterLevel': return '%';
      default: return '';
    }
  }

  Color _getChartColor() {
    switch (_selectedChart) {
      case 'temperature': return Colors.red;
      case 'humidity': return Colors.blue;
      case 'soilMoisture': return Colors.green;
      case 'waterLevel': return Colors.cyan;
      default: return Colors.grey;
    }
  }

  IconData _getIconForChart(String chartId) {
    switch (chartId) {
      case 'temperature': return Icons.thermostat;
      case 'humidity': return Icons.water_drop;
      case 'soilMoisture': return Icons.grass;
      case 'waterLevel': return Icons.opacity;
      default: return Icons.show_chart;
    }
  }

  double _getMinFromData(List<FlSpot> data) {
    if (data.isEmpty) return 0;
    double min = data.first.y;
    for (final spot in data) {
      if (spot.y < min) min = spot.y;
    }
    return min;
  }

  double _getMaxFromData(List<FlSpot> data) {
    if (data.isEmpty) return 0;
    double max = data.first.y;
    for (final spot in data) {
      if (spot.y > max) max = spot.y;
    }
    return max;
  }

  void _refreshData() {
    setState(() {
      _lastUpdate = DateTime.now();
      _updateAllChartData();
    });
  }
}