import 'package:flutter/material.dart';

class SensorControlScreen extends StatelessWidget {
  const SensorControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Sensores')),
      body: const Center(
        child: Text('Aqui você poderá visualizar e configurar sensores.'),
      ),
    );
  }
}
