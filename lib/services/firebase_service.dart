import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/sensor_data.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _realtime = FirebaseDatabase.instance.ref();

  Stream<SensorData> getSensorData() {
    return _firestore
        .collection('sensor_data')
        .doc('current')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return SensorData.fromMap(snapshot.data()!);
      }
      return SensorData(
        temperature: 0.0,
        humidity: 0.0,
        soilMoisture: 0.0,
        waterLevel: 0.0,
        isRaining: false,
        timestamp: DateTime.now(),
      );
    });
  }

  Future<void> setWaterPumpState(bool state) async {
    await _firestore.collection('controls').doc('water_pump').set({
      'state': state,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    await _realtime.child('controls/water_pump').set({
      'state': state,
      'lastUpdated': ServerValue.timestamp,
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

  Stream<QuerySnapshot> getSensorHistory() {
    return _firestore
        .collection('sensor_history')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots();
  }

  Future<void> setSensorDataRealtime(SensorData data) async {
    await _realtime.child('sensor_data/current').set({
      'temperature': data.temperature,
      'humidity': data.humidity,
      'soilMoisture': data.soilMoisture,
      'waterLevel': data.waterLevel,
      'isRaining': data.isRaining,
      'timestamp': ServerValue.timestamp,
    });
  }

  Future<void> pushSensorHistory(SensorData data) async {
    await _realtime.child('sensor_history').push().set({
      'temperature': data.temperature,
      'humidity': data.humidity,
      'soilMoisture': data.soilMoisture,
      'waterLevel': data.waterLevel,
      'isRaining': data.isRaining,
      'timestamp': ServerValue.timestamp,
    });
  }

  Stream<SensorData> listenSensorRealtime() {
    return _realtime.child('sensor_data/current').onValue.map((event) {
      final val = event.snapshot.value as Map<dynamic, dynamic>?;
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
        time = DateTime.fromMillisecondsSinceEpoch(ts);
      } else {
        time = DateTime.now();
      }
      return SensorData(
        temperature: (map['temperature'] as num?)?.toDouble() ?? 0.0,
        humidity: (map['humidity'] as num?)?.toDouble() ?? 0.0,
        soilMoisture: (map['soilMoisture'] as num?)?.toDouble() ?? 0.0,
        waterLevel: (map['waterLevel'] as num?)?.toDouble() ?? 0.0,
        isRaining: map['isRaining'] ?? false,
        timestamp: time,
      );
    });
  }
}
