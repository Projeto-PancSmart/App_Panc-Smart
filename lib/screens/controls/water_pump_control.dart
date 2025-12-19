// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firebase_service.dart';
import '../../utils/responsive.dart';

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
      appBar: AppBar(
        title: const Text('Controle da Bomba de Água'),
        // ADICIONADO: título responsivo
        titleTextStyle: TextStyle(
          fontSize: Responsive.fontSize(context, 18),
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        // CORRIGIDO: padding responsivo
        padding: EdgeInsets.all(Responsive.scale(context, 16)),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.isPhone(context) 
                  ? double.infinity 
                  : Responsive.scale(context, 640),
            ),
            child: ScaleTransition(
              scale: _anim,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  // CORRIGIDO: padding interno responsivo
                  padding: EdgeInsets.all(Responsive.scale(context, 24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CABEÇALHO
                      Row(
                        children: [
                          Container(
                            width: Responsive.scale(context, 56),
                            height: Responsive.scale(context, 56),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary
                                      .withAlpha((0.85 * 255).round())
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.opacity, 
                              color: Colors.white, 
                              size: Responsive.fontSize(context, 28)
                            ),
                          ),
                          Responsive.hGap(context, 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bomba de Água',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Responsive.vGap(context, 4),
                                Text(
                                  'Controle manual da bomba da estufa',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 14),
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      Responsive.vGap(context, 32),

                      // ÍCONE GRANDE
                      Container(
                        width: Responsive.scale(context, 140),
                        height: Responsive.scale(context, 140),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isPumpOn 
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          border: Border.all(
                            color: _isPumpOn 
                                ? Colors.blueAccent.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          _isPumpOn
                              ? Icons.water_drop
                              : Icons.water_drop_outlined,
                          size: Responsive.scale(context, 72),
                          color: _isPumpOn
                              ? Colors.blueAccent
                              : Colors.grey.shade500,
                        ),
                      ),
                      
                      Responsive.vGap(context, 20),

                      // STATUS
                      Text(
                        _isPumpOn ? 'BOMBA LIGADA' : 'BOMBA DESLIGADA',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 24),
                          fontWeight: FontWeight.bold,
                          color: _isPumpOn 
                              ? Colors.blueAccent
                              : Colors.grey.shade600,
                        ),
                      ),

                      Responsive.vGap(context, 8),

                      // MENSAGEM DE STATUS
                      Text(
                        _isPumpOn 
                            ? 'A bomba está irrigando as plantas'
                            : 'A bomba está em modo de espera',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 16),
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      Responsive.vGap(context, 32),

                      // CONTROLE DO SWITCH
                      Container(
                        padding: EdgeInsets.all(Responsive.scale(context, 20)),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'CONTROLE MANUAL',
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 14),
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                letterSpacing: 1.2,
                              ),
                            ),
                            
                            Responsive.vGap(context, 16),
                            
                            // SWITCH COM LABELS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'OFF',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 16),
                                    fontWeight: FontWeight.w600,
                                    color: !_isPumpOn 
                                        ? Colors.red
                                        : Colors.grey[400],
                                  ),
                                ),
                                
                                Responsive.hGap(context, 20),
                                
                                Transform.scale(
                                  scale: Responsive.scale(context, 1.2),
                                  child: Switch(
                                    value: _isPumpOn,
                                    activeColor: Colors.blueAccent,
                                    activeTrackColor: Colors.blueAccent.withOpacity(0.5),
                                    inactiveThumbColor: Colors.grey[600],
                                    inactiveTrackColor: Colors.grey[300],
                                    onChanged: (value) async {
                                      setState(() => _isPumpOn = value);
                                      final messenger = ScaffoldMessenger.of(context);
                                      await Provider.of<FirebaseService>(context,
                                              listen: false)
                                          .setWaterPumpState(value);
                                      if (!mounted) return;
                                      messenger.showSnackBar(SnackBar(
                                          content: Text(value
                                              ? '✅ Bomba ligada'
                                              : '⏸️ Bomba desligada'),
                                          backgroundColor: value 
                                              ? Colors.green
                                              : Colors.orange,
                                      ));
                                    },
                                  ),
                                ),
                                
                                Responsive.hGap(context, 20),
                                
                                Text(
                                  'ON',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 16),
                                    fontWeight: FontWeight.w600,
                                    color: _isPumpOn 
                                        ? Colors.green
                                        : Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                            
                            Responsive.vGap(context, 12),
                            
                            // MENSAGEM INFORMATIVA
                            Text(
                              'Use o controle manual para ligar/desligar imediatamente.',
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 14),
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      Responsive.vGap(context, 24),

                      // INFORMAÇÕES ADICIONAIS (APENAS PARA TABLET/DESKTOP)
                      if (!Responsive.isPhone(context))
                        Container(
                          padding: EdgeInsets.all(Responsive.scale(context, 16)),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[700],
                                size: Responsive.fontSize(context, 20),
                              ),
                              Responsive.hGap(context, 12),
                              Expanded(
                                child: Text(
                                  'Dica: Monitore a umidade do solo antes de ligar a bomba manualmente.',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 14),
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
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