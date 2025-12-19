import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/sensor_data.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _realtime = FirebaseDatabase.instance.ref();

  Stream<SensorData> listenSensorRealtime() {
    return _realtime.child('sistema').onValue.map((event) {
      final val = event.snapshot.value as Map<dynamic, dynamic>?;
      
      // CORREÇÃO: Sem usar SensorData.empty()
      if (val == null) {
        return SensorData(
          temperature: 0.0,
          humidity: 0.0,
          soilMoisture: 0.0,
          waterLevel: 0.0,
          isRaining: false,
          timestamp: DateTime.now(),
        );
      }
      
      final map = Map<String, dynamic>.from(
          val.map((k, v) => MapEntry(k.toString(), v)));

      final ts = map['timestamp'];
      DateTime time;
      if (ts is int) {
        time = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
      } else if (ts is String) {
        time = DateTime.tryParse(ts) ?? DateTime.now();
      } else {
        time = DateTime.now();
      }
      
      return SensorData(
        temperature: (map['temperatura'] as num?)?.toDouble() ?? 0.0,
        humidity: (map['umidade_ar'] as num?)?.toDouble() ?? 0.0,
        soilMoisture: (map['umidade_solo'] as num?)?.toDouble() ?? 0.0,
        waterLevel: (map['nivel_agua'] as num?)?.toDouble() ?? 0.0,
        isRaining: false,
        timestamp: time,
      );
    });
  }

  Stream<List<SensorData>> getSensorHistory() {
    return _realtime
        .child('sensor_history')
        .orderByChild('timestamp')
        .limitToLast(100)
        .onValue
        .map((event) {
          final historyMap = event.snapshot.value as Map<dynamic, dynamic>?;
          final List<SensorData> historyList = [];

          if (historyMap != null) {
            historyMap.forEach((key, value) {
              if (value is Map<dynamic, dynamic>) {
                final map = Map<String, dynamic>.from(
                    value.map((k, v) => MapEntry(k.toString(), v)));
                
                final ts = map['timestamp'];
                DateTime time;
                if (ts is int) {
                  time = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
                } else if (ts is String) {
                  time = DateTime.tryParse(ts) ?? DateTime.now();
                } else {
                  time = DateTime.now();
                }

                historyList.add(SensorData(
                  temperature: (map['temperatura'] as num?)?.toDouble() ?? 0.0,
                  humidity: (map['umidade_ar'] as num?)?.toDouble() ?? 0.0,
                  soilMoisture: (map['umidade_solo'] as num?)?.toDouble() ?? 0.0,
                  waterLevel: (map['nivel_agua'] as num?)?.toDouble() ?? 0.0,
                  isRaining: false,
                  timestamp: time,
                ));
              }
            });
          }
          
          historyList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          return historyList;
        });
  }

  Future<void> setWaterPumpState(bool state) async {
    await _realtime.child('sistema/status/bomba').set(state);
  }

  Future<void> setConfiguracao(double ligar, double desligar) async {
    await _realtime.child('sistema/configuracoes').update({
      'umidade_ligar': ligar,
      'umidade_desligar': desligar,
    });
  }

  Future<void> setWaterPumpStateFirestore(bool state) async {
    await _firestore.collection('controls').doc('water_pump').set({
      'state': state,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setLEDState(bool state) async {
    await _firestore.collection('controls').doc('led').set({
      'state': state,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    await _realtime.child('controls/led').set({
      'state': state,
      'lastUpdated': ServerValue.timestamp,
    });
  }

  Future<void> setLCDMessage(String message) async {
    await _firestore.collection('controls').doc('lcd').set({
      'message': message,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    await _realtime.child('controls/lcd').set({
      'message': message,
      'lastUpdated': ServerValue.timestamp,
    });
  }

  Future<void> pushSensorHistory(SensorData data) async {
    await _realtime.child('sensor_history').push().set({
      'temperatura': data.temperature,
      'umidade_ar': data.humidity,
      'umidade_solo': data.soilMoisture,
      'nivel_agua': data.waterLevel,
      'timestamp': ServerValue.timestamp,
    });
  }

  // Métodos de compatibilidade mantidos
  Stream<SensorData> getSensorData() {
    return listenSensorRealtime();
  }

  Future<void> setSensorDataRealtime(SensorData data) async {
    await _realtime.child('sistema').update({
      'temperatura': data.temperature,
      'umidade_ar': data.humidity,
      'umidade_solo': data.soilMoisture,
      'nivel_agua': data.waterLevel,
      'timestamp': ServerValue.timestamp,
    });
  }
}