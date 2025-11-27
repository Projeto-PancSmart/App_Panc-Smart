// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';

class WaterPumpControlScreen extends StatefulWidget {
  const WaterPumpControlScreen({super.key});

  @override
  _WaterPumpControlScreenState createState() => _WaterPumpControlScreenState();
}

class _WaterPumpControlScreenState extends State<WaterPumpControlScreen> {
  bool _isPumpOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle da Bomba de Água')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isPumpOn ? Icons.opacity : Icons.opacity_outlined,
              size: 100,
              color: _isPumpOn ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              _isPumpOn ? 'Bomba LIGADA' : 'Bomba DESLIGADA',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Switch(
              value: _isPumpOn,
              onChanged: (value) async {
                setState(() => _isPumpOn = value);
                final messenger = ScaffoldMessenger.of(context);
                await Provider.of<FirebaseService>(context, listen: false)
                    .setWaterPumpState(value);
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(
                      content:
                          Text(value ? 'Bomba ligada' : 'Bomba desligada')),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Controle manual da bomba de água da estufa',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
