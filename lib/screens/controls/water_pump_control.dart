// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';

class WaterPumpControlScreen extends StatefulWidget {
  const WaterPumpControlScreen({super.key});

  @override
  _WaterPumpControlScreenState createState() => _WaterPumpControlScreenState();
}

class _WaterPumpControlScreenState extends State<WaterPumpControlScreen>
    with SingleTickerProviderStateMixin {
  bool _isPumpOn = false;
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
      appBar: AppBar(title: const Text('Controle da Bomba de Água')),
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
                                theme.colorScheme.primary,
                                theme.colorScheme.primary
                                    .withAlpha((0.85 * 255).round())
                              ]),
                            ),
                            child: const Icon(Icons.opacity,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Bomba de Água',
                                    style: theme.textTheme.headlineSmall),
                                const SizedBox(height: 4),
                                Text('Controle manual da bomba da estufa',
                                    style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      Icon(
                          _isPumpOn
                              ? Icons.water_drop
                              : Icons.water_drop_outlined,
                          size: 84,
                          color: _isPumpOn
                              ? Colors.blueAccent
                              : Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(_isPumpOn ? 'Bomba LIGADA' : 'Bomba DESLIGADA',
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontSize: 20)),

                      const SizedBox(height: 18),

                      // Styled switch in a row with label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('OFF',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withAlpha((0.6 * 255).round()))),
                          const SizedBox(width: 8),
                          Switch(
                            value: _isPumpOn,
                            activeThumbColor: theme.colorScheme.primary,
                            onChanged: (value) async {
                              setState(() => _isPumpOn = value);
                              final messenger = ScaffoldMessenger.of(context);
                              await Provider.of<FirebaseService>(context,
                                      listen: false)
                                  .setWaterPumpState(value);
                              if (!mounted) return;
                              messenger.showSnackBar(SnackBar(
                                  content: Text(value
                                      ? 'Bomba ligada'
                                      : 'Bomba desligada')));
                            },
                          ),
                          const SizedBox(width: 8),
                          Text('ON',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withAlpha((0.8 * 255).round()))),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Text(
                          'Use o controle manual para ligar/desligar imediatamente.',
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
