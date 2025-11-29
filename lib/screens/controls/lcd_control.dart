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

class _LcdControlScreenState extends State<LcdControlScreen>
    with SingleTickerProviderStateMixin {
  final _messageController = TextEditingController();
  late final AnimationController _animController;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _anim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Controle do Display LCD')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ScaleTransition(
              scale: _anim,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: theme.colorScheme.primary),
                            child: const Icon(Icons.tv,
                                color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text('Display LCD',
                                  style: theme.textTheme.headlineSmall)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.message),
                            labelText: 'Mensagem para o LCD',
                            hintText: 'Digite a mensagem (max 32 caracteres)'),
                        maxLength: 32,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_messageController.text.isNotEmpty) {
                              final messenger = ScaffoldMessenger.of(context);
                              await Provider.of<FirebaseService>(context,
                                      listen: false)
                                  .setLCDMessage(_messageController.text);
                              if (!mounted) return;
                              messenger.showSnackBar(const SnackBar(
                                  content:
                                      Text('Mensagem enviada para o LCD')));
                              _messageController.clear();
                            }
                          },
                          child: const Text('Enviar para LCD'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                          'O display LCD 16x2 pode mostrar até 32 caracteres (2 linhas de 16)',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withAlpha((0.6 * 255).round())),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
}
