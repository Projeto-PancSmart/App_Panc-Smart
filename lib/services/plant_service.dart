import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../models/plant.dart';

class PlantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Plant?> getPlantInfo(String plantName) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('plants')
          .doc(plantName.toLowerCase())
          .get();

      if (snapshot.exists) {
        return Plant.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao buscar planta: $e');
      return null;
    }
  }

  Future<List<Plant>> searchPlants(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('plants')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();

      return snapshot.docs
          .map((doc) => Plant.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Erro na busca: $e');
      return [];
    }
  }
}
