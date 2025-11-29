// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';

class LedControlScreen extends StatefulWidget {
  const LedControlScreen({super.key});

  @override
  _LedControlScreenState createState() => _LedControlScreenState();
}

class _LedControlScreenState extends State<LedControlScreen>
    with SingleTickerProviderStateMixin {
  bool _isLedOn = false;
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
      appBar: AppBar(title: const Text('Controle da LED')),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withAlpha((0.85 * 255).round())
                              ]),
                            ),
                            child: const Icon(Icons.lightbulb,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Iluminação (LED)',
                                    style: theme.textTheme.headlineSmall),
                                const SizedBox(height: 4),
                                Text('Controle manual das luzes de cultivo',
                                    style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Icon(Icons.lightbulb,
                          size: 84,
                          color: _isLedOn
                              ? Colors.yellowAccent
                              : Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(_isLedOn ? 'LED LIGADA' : 'LED DESLIGADA',
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontSize: 20)),
                      const SizedBox(height: 18),
                      Switch(
                        value: _isLedOn,
                        activeThumbColor: Colors.amberAccent,
                        onChanged: (value) async {
                          setState(() => _isLedOn = value);
                          final messenger = ScaffoldMessenger.of(context);
                          await Provider.of<FirebaseService>(context,
                                  listen: false)
                              .setLEDState(value);
                          if (!mounted) return;
                          messenger.showSnackBar(SnackBar(
                              content: Text(
                                  value ? 'LED ligada' : 'LED desligada')));
                        },
                      ),
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
