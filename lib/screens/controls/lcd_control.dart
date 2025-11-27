// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';
// prefer const constructors where applicable

class LcdControlScreen extends StatefulWidget {
  const LcdControlScreen({super.key});

  @override
  _LcdControlScreenState createState() => _LcdControlScreenState();
}

class _LcdControlScreenState extends State<LcdControlScreen> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle do Display LCD')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.tv, size: 80, color: Colors.purple),
            const SizedBox(height: 20),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Mensagem para o LCD',
                border: OutlineInputBorder(),
                hintText: 'Digite a mensagem (max 32 caracteres)',
              ),
              maxLength: 32,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_messageController.text.isNotEmpty) {
                  final messenger = ScaffoldMessenger.of(context);
                  await Provider.of<FirebaseService>(context, listen: false)
                      .setLCDMessage(_messageController.text);

                  if (!mounted) return;
                  messenger.showSnackBar(
                    const SnackBar(
                        content: Text('Mensagem enviada para o LCD')),
                  );
                  _messageController.clear();
                }
              },
              child: const Text('Enviar para LCD'),
            ),
            const SizedBox(height: 20),
            const Text(
              'O display LCD 16x2 pode mostrar até 32 caracteres (2 linhas de 16)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
