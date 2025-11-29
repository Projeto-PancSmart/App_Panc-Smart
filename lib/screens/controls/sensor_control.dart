import 'package:flutter/material.dart';

class SensorControlScreen extends StatefulWidget {
  const SensorControlScreen({super.key});

  @override
  SensorControlScreenState createState() => SensorControlScreenState();
}

class SensorControlScreenState extends State<SensorControlScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, bool> _enabled = {
    'Temperatura': true,
    'Umidade': true,
    'Umidade Solo': true,
    'Nível de Água': true,
  };

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
      appBar: AppBar(title: const Text('Controle de Sensores')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ScaleTransition(
              scale: _anim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _enabled.keys.map((name) {
                  final enabled = _enabled[name] ?? false;
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: theme.colorScheme.primary,
                              child: Icon(_iconForSensor(name),
                                  color: Colors.white)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text(
                                    enabled
                                        ? 'Ativo — coletando leituras'
                                        : 'Desativado',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withAlpha((0.6 * 255).round()))),
                              ],
                            ),
                          ),
                          Switch(
                            value: enabled,
                            activeThumbColor: theme.colorScheme.primary,
                            onChanged: (v) {
                              setState(() => _enabled[name] = v);
                              final messenger = ScaffoldMessenger.of(context);
                              messenger.showSnackBar(SnackBar(
                                  content: Text(v
                                      ? '$name ativado'
                                      : '$name desativado')));
                            },
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                    content: Text('Calibrando $name...'))),
                            child: const Text('Calibrar'),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForSensor(String name) {
    switch (name) {
      case 'Temperatura':
        return Icons.thermostat;
      case 'Umidade':
        return Icons.water_drop;
      case 'Umidade Solo':
        return Icons.grass;
      case 'Nível de Água':
        return Icons.invert_colors;
      default:
        return Icons.sensors;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
}
