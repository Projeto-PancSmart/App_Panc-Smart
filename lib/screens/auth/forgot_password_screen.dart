// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

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
      appBar: AppBar(title: const Text('Recuperar Senha')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ScaleTransition(
              scale: _anim,
              child: FadeTransition(
                opacity: _anim,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Recuperar Senha',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        if (!_emailSent) ...[
                          Text(
                              'Digite seu email para receber um link de recuperação',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Email'),
                          ),
                          const SizedBox(height: 18),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: _resetPassword,
                                      child: const Text('Enviar Link')),
                                ),
                        ] else ...[
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 92),
                          const SizedBox(height: 12),
                          Text('Email enviado com sucesso!',
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 6),
                          Text('Verifique sua caixa de entrada.',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 18),
                          Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Voltar ao Login'))),
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
