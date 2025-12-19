// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../services/auth_service.dart';
import '../../utils/responsive.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  late final AnimationController _animController;
  late final Animation<double> _anim;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('As senhas não coincidem')),
        );
        return;
      }

      setState(() => _isLoading = true);
      final auth = Provider.of<AuthService>(context, listen: false);
      try {
        final user = await auth.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
        );
        if (!mounted) return;
        if (user != null) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Conta criada com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro desconhecido ao criar conta.')),
          );
        }
      } on fb.FirebaseAuthException catch (e) {
        if (!mounted) return;
        final message = e.message ?? 'Erro ao criar conta: ${e.code}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar conta: ${e.toString()}')),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        // ADICIONADO: título responsivo
        titleTextStyle: TextStyle(
          fontSize: Responsive.fontSize(context, 18),
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        // CORRIGIDO: padding responsivo
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isPhone(context) 
              ? Responsive.scale(context, 20) 
              : Responsive.scale(context, 40),
          vertical: Responsive.scale(context, 36),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.isPhone(context) 
                  ? double.infinity 
                  : Responsive.scale(context, 560),
            ),
            child: ScaleTransition(
              scale: _anim,
              child: FadeTransition(
                opacity: _anim,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    // CORRIGIDO: padding interno responsivo
                    padding: EdgeInsets.all(Responsive.scale(context, 24)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // TÍTULO RESPONSIVO
                          Text(
                            'Criar Conta',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 24),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          Responsive.vGap(context, 8),
                          
                          // SUBTÍTULO RESPONSIVO
                          Text(
                            'Crie sua conta para gerenciar sua estufa com eficiência',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 14),
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          Responsive.vGap(context, 24),
                          
                          // CAMPO NOME RESPONSIVO
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nome Completo',
                              prefixIcon: const Icon(Icons.person),
                              // ADICIONADO: estilos responsivos
                              labelStyle: TextStyle(
                                fontSize: Responsive.fontSize(context, 14),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Responsive.scale(context, 12),
                                vertical: Responsive.scale(context, 14),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira seu nome';
                              }
                              return null;
                            },
                          ),
                          
                          Responsive.vGap(context, 16),
                          
                          // CAMPO EMAIL RESPONSIVO
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              labelStyle: TextStyle(
                                fontSize: Responsive.fontSize(context, 14),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Responsive.scale(context, 12),
                                vertical: Responsive.scale(context, 14),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira seu email';
                              }
                              return null;
                            },
                          ),
                          
                          Responsive.vGap(context, 16),
                          
                          // CAMPO SENHA RESPONSIVO
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: const Icon(Icons.lock),
                              labelStyle: TextStyle(
                                fontSize: Responsive.fontSize(context, 14),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Responsive.scale(context, 12),
                                vertical: Responsive.scale(context, 14),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, insira uma senha';
                              }
                              if (value.length < 6) {
                                return 'A senha deve ter pelo menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          
                          Responsive.vGap(context, 16),
                          
                          // CAMPO CONFIRMAR SENHA RESPONSIVO
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirmar Senha',
                              prefixIcon: const Icon(Icons.lock_outline),
                              labelStyle: TextStyle(
                                fontSize: Responsive.fontSize(context, 14),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: Responsive.scale(context, 12),
                                vertical: Responsive.scale(context, 14),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, confirme sua senha';
                              }
                              return null;
                            },
                          ),
                          
                          Responsive.vGap(context, 24),
                          
                          // BOTÃO RESPONSIVO
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  height: Responsive.scale(context, 52),
                                  child: ElevatedButton(
                                    onPressed: _register,
                                    child: Text(
                                      'Criar Conta', 
                                      style: TextStyle(
                                        fontSize: Responsive.fontSize(context, 16),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                          
                          Responsive.vGap(context, 16),
                          
                          // LINK VOLTAR RESPONSIVO
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Já tem uma conta? Entrar',
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 14),
                              ),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}