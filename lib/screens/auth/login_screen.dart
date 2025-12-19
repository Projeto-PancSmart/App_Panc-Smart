// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../services/auth_service.dart';
import '../../utils/responsive.dart';
import '../../models/user.dart';
import '../home_screen.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Extract form widget so we can reuse in tablet layout
  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Brand / header - APENAS PARA CELULAR
          if (Responsive.isPhone(context)) ...[
            Row(
              children: [
                Container(
                  width: Responsive.scale(context, 56),
                  height: Responsive.scale(context, 56),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.eco,
                    color: Colors.white,
                    size: Responsive.fontSize(context, 32),
                  ),
                ),
                Responsive.hGap(context, 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Panc Smart',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Responsive.vGap(context, 4),
                      Text(
                        'Bem-vindo — monitore sua estufa com eficiência',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 12),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Responsive.vGap(context, 20),
          ],

          // Form fields
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              labelText: 'Email',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Responsive.scale(context, 12),
                vertical: Responsive.scale(context, 12),
              ),
              labelStyle: TextStyle(
                fontSize: Responsive.fontSize(context, 14),
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

          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              labelText: 'Senha',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: Responsive.scale(context, 12),
                vertical: Responsive.scale(context, 12),
              ),
              labelStyle: TextStyle(
                fontSize: Responsive.fontSize(context, 14),
              ),
            ),
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira sua senha';
              }
              return null;
            },
          ),

          Responsive.vGap(context, 8),

          // Link para esqueci senha - CELULAR
          if (Responsive.isPhone(context))
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const ForgotPasswordScreen(),
                  ),
                ),
                child: Text(
                  'Esqueci minha senha',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 14),
                  ),
                ),
              ),
            ),

          Responsive.vGap(context, 24),

          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: Responsive.scale(context, 52),
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: Responsive.fontSize(context, 16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

          Responsive.vGap(context, 16),

          // Links inferiores
          if (Responsive.isPhone(context)) ...[
            Center(
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const RegisterScreen(),
                  ),
                ),
                child: Text(
                  'Não tem uma conta? Criar conta',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 14),
                  ),
                ),
              ),
            ),
          ] else ...[
            // TABLET/DESKTOP: botões lado a lado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const RegisterScreen(),
                    ),
                  ),
                  child: Text(
                    'Criar conta',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 14),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child: Text(
                    'Esqueci minha senha',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final auth = Provider.of<AuthService>(context, listen: false);
      User? user = await auth.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (user != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro no login. Verifique suas credenciais.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // CORREÇÃO: Use apenas isTablet ou isDesktop
          final isTabletOrDesktop = Responsive.isTablet(context) || 
                                     Responsive.isDesktop(context);

          if (isTabletOrDesktop) {
            final cardWidth = math.min(
              Responsive.scale(context, 1000), 
              constraints.maxWidth * 0.9
            );
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.scale(context, 24),
                vertical: Responsive.scale(context, 40),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // LADO ESQUERDO: APRESENTAÇÃO
                        Expanded(
                          flex: 4,
                          child: Container(
                            padding: EdgeInsets.all(Responsive.scale(context, 22)),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Responsive.scale(context, 84),
                                  height: Responsive.scale(context, 84),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.eco,
                                    color: Colors.white,
                                    size: Responsive.fontSize(context, 44),
                                  ),
                                ),
                                Responsive.vGap(context, 20),
                                Text(
                                  'Panc Smart',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 28),
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                Responsive.vGap(context, 12),
                                Text(
                                  'Bem-vindo — monitore sua estufa com eficiência',
                                  style: TextStyle(
                                    fontSize: Responsive.fontSize(context, 16),
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // LADO DIREITO: FORMULÁRIO
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.all(Responsive.scale(context, 32)),
                            child: _buildForm(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          // LAYOUT PARA CELULAR
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.scale(context, 20),
              vertical: Responsive.scale(context, 40),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.scale(context, 560),
                ),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(Responsive.scale(context, 24)),
                    child: _buildForm(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}