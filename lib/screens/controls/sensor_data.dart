class SensorData {
  final double temperature;
  final double humidity;
  final double soilMoisture;
  final double waterLevel;
  final bool isRaining;
  final DateTime timestamp;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.waterLevel,
    required this.isRaining,
    required this.timestamp,
  });

  factory SensorData.empty() {
    return SensorData(
      temperature: 0.0,
      humidity: 0.0,
      soilMoisture: 0.0,
      waterLevel: 0.0,
      isRaining: false,
      timestamp: DateTime.now(),
    );
  }

  // Método para converter do seu banco (opcional)
  factory SensorData.fromFirebaseMap(Map<String, dynamic> map) {
    return SensorData(
      temperature: (map['temperatura'] as num?)?.toDouble() ?? 0.0,
      humidity: (map['umidade_ar'] as num?)?.toDouble() ?? 0.0,
      soilMoisture: (map['umidade_solo'] as num?)?.toDouble() ?? 0.0,
      waterLevel: (map['nivel_agua'] as num?)?.toDouble() ?? 0.0,
      isRaining: false,
      timestamp: DateTime.now(),
    );
  }
}