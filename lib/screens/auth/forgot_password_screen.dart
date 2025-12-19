// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/responsive.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  late final AnimationController _animController;
  late final Animation<double> _anim;

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu email')),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.resetPassword(_emailController.text.trim());

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 360));
    _anim = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
        // ADICIONADO: Tamanho responsivo para o título do AppBar
        titleTextStyle: TextStyle(
          fontSize: Responsive.fontSize(context, 18),
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        // CORRIGIDO: padding usando método mais apropriado
        padding: Responsive.paddingSymmetric(
          context: context,
          horizontal: Responsive.isPhone(context) ? 20 : 40,
          vertical: 40,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.isPhone(context) 
                  ? Responsive.widthPercent(context, 0.9) // 90% em celular
                  : Responsive.scale(context, 500), // valor fixo escalado em tablet/desktop
            ),
            child: ScaleTransition(
              scale: _anim,
              child: FadeTransition(
                opacity: _anim,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Aumentei de 14 para 16
                  ),
                  child: Padding(
                    // CORRIGIDO: padding interno responsivo
                    padding: Responsive.paddingAll(context, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // TÍTULO COM FONTE RESPONSIVA
                        Text(
                          'Recuperar Senha',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 24),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        Responsive.vGap(context, 12),
                        
                        if (!_emailSent) ...[
                          // TEXTO EXPLICATIVO RESPONSIVO
                          Text(
                            'Digite seu email para receber um link de recuperação',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 16),
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          Responsive.vGap(context, 24),
                          
                          // CAMPO DE EMAIL RESPONSIVO
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              labelText: 'Email',
                              // ADICIONADO: estilo responsivo para o label
                              labelStyle: TextStyle(
                                fontSize: Responsive.fontSize(context, 16),
                              ),
                            ),
                            // ADICIONADO: estilo responsivo para o texto digitado
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 16),
                            ),
                          ),
                          
                          Responsive.vGap(context, 24),
                          
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  // BOTÃO RESPONSIVO - altura fixa mas escalável
                                  height: Responsive.scale(context, 52),
                                  child: ElevatedButton(
                                    onPressed: _resetPassword,
                                    child: Text(
                                      'Enviar Link',
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(context, 16),
                                      ),
                                    ),
                                  ),
                                ),
                        ] else ...[
                          // ÍCONE DE SUCESSO RESPONSIVO
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: Responsive.scale(context, 100), // Aumentei de 92 para 100
                          ),
                          
                          Responsive.vGap(context, 20), // Aumentei de 12 para 20
                          
                          // TÍTULO DE SUCESSO RESPONSIVO
                          Text(
                            'Email enviado com sucesso!',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 22),
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          Responsive.vGap(context, 12), // Aumentei de 6 para 12
                          
                          // MENSAGEM DE SUCESSO RESPONSIVA
                          Text(
                            'Verifique sua caixa de entrada.',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 16),
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          Responsive.vGap(context, 32), // Aumentei de 18 para 32
                          
                          // BOTÃO VOLTAR RESPONSIVO
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: Responsive.scale(context, 200),
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Voltar ao Login',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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