import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/plant_service.dart';
import '../models/plant.dart';

class PlantTipsScreen extends StatefulWidget {
  const PlantTipsScreen({super.key});

  @override
  PlantTipsScreenState createState() => PlantTipsScreenState();
}

class PlantTipsScreenState extends State<PlantTipsScreen> {
  final _searchController = TextEditingController();
  Plant? _selectedPlant;
  bool _isLoading = false;

  void _searchPlant() async {
    if (_searchController.text.isEmpty) return;

    setState(() => _isLoading = true);

    final plantService = Provider.of<PlantService>(context, listen: false);
    final plant =
        await plantService.getPlantInfo(_searchController.text.trim());

    setState(() {
      _selectedPlant = plant;
      _isLoading = false;
    });

    if (!mounted) return;
    if (plant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Planta não encontrada')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dicas para Plantas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Nome da planta',
                      hintText: 'Ex: Tomate, Alface, Rosa...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _searchPlant(),
                  ),
                ),
                const SizedBox(width: 10),
                _isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchPlant,
                      ),
              ],
            ),
            const SizedBox(height: 20),
            if (_selectedPlant != null) _buildPlantInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantInfo() {
    final plant = _selectedPlant!;
    final care = plant.careInstructions;

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plant.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(plant.scientificName,
                style: const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.grey)),
            const SizedBox(height: 10),
            Text(plant.description),
            const SizedBox(height: 20),
            _buildCareItem(
                '💧 Rega', care['watering'] ?? 'Informação não disponível'),
            _buildCareItem('☀️ Luz Solar',
                care['sunlight'] ?? 'Informação não disponível'),
            _buildCareItem('🌡️ Temperatura',
                care['temperature'] ?? 'Informação não disponível'),
            _buildCareItem(
                '🌱 Solo', care['soil'] ?? 'Informação não disponível'),
            _buildCareItem('🍃 Fertilização',
                care['fertilization'] ?? 'Informação não disponível'),
          ],
        ),
      ),
    );
  }

  Widget _buildCareItem(String title, String description) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(description),
          ],
        ),
      ),
    );
  }
}
