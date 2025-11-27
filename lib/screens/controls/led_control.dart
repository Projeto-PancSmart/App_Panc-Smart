// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';

class LedControlScreen extends StatefulWidget {
  const LedControlScreen({super.key});

  @override
  _LedControlScreenState createState() => _LedControlScreenState();
}

class _LedControlScreenState extends State<LedControlScreen> {
  bool _isLedOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle da LED')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb,
              size: 100,
              color: _isLedOn ? Colors.yellow : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              _isLedOn ? 'LED LIGADA' : 'LED DESLIGADA',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Switch(
              value: _isLedOn,
              onChanged: (value) async {
                setState(() => _isLedOn = value);
                final messenger = ScaffoldMessenger.of(context);
                await Provider.of<FirebaseService>(context, listen: false)
                    .setLEDState(value);
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(
                      content: Text(value ? 'LED ligada' : 'LED desligada')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
