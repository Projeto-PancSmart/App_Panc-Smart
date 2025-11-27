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

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'soilMoisture': soilMoisture,
      'waterLevel': waterLevel,
      'isRaining': isRaining,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory SensorData.fromMap(Map<String, dynamic> map) {
    return SensorData(
      temperature: map['temperature']?.toDouble() ?? 0.0,
      humidity: map['humidity']?.toDouble() ?? 0.0,
      soilMoisture: map['soilMoisture']?.toDouble() ?? 0.0,
      waterLevel: map['waterLevel']?.toDouble() ?? 0.0,
      isRaining: map['isRaining'] ?? false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
}