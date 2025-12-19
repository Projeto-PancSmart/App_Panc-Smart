import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/responsive.dart';
import 'terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        titleTextStyle: TextStyle(
          fontSize: Responsive.fontSize(context, 18),
          fontWeight: FontWeight.w600,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(Responsive.scale(context, 16)),
        children: [
          // CABEÇALHO DO USUÁRIO
          Container(
            padding: EdgeInsets.all(Responsive.scale(context, 20)),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: Responsive.scale(context, 60),
                  height: Responsive.scale(context, 60),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person, 
                    color: Colors.white,
                    size: Responsive.fontSize(context, 28),
                  ),
                ),
                
                SizedBox(width: Responsive.scale(context, 16)),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuário',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 18),
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      
                      SizedBox(height: Responsive.scale(context, 6)),
                      
                      Text(
                        'perfil@exemplo.com',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 14),
                          color: Colors.grey[700],
                        ),
                      ),
                      
                      SizedBox(height: Responsive.scale(context, 8)),
                      
                      // BADGE DE STATUS (apenas em tablets/desktop)
                      if (!Responsive.isPhone(context))
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.scale(context, 10),
                            vertical: Responsive.scale(context, 4),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: Responsive.fontSize(context, 12),
                                color: Colors.green,
                              ),
                              SizedBox(width: Responsive.scale(context, 6)),
                              Text(
                                'Conta verificada',
                                style: TextStyle(
                                  fontSize: Responsive.fontSize(context, 12),
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                
                // BOTÃO EDITAR
                Container(
                  width: Responsive.scale(context, 40),
                  height: Responsive.scale(context, 40),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Funcionalidade em desenvolvimento'),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      size: Responsive.fontSize(context, 18),
                      color: Colors.grey[700],
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: Responsive.scale(context, 24)),

          // SEÇÃO: CONFIGURAÇÕES DA CONTA
          // CORREÇÃO: Passe o context para o método
          _buildSectionTitle(context, 'Configurações da Conta'),
          
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    size: Responsive.fontSize(context, 22),
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Notificações',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: Responsive.scale(context, 0.9),
                    child: Switch(
                      value: true,
                      activeColor: Colors.blue,
                      onChanged: (value) {},
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Responsive.scale(context, 16),
                    vertical: Responsive.scale(context, 8),
                  ),
                  onTap: () {},
                ),
                
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[200],
                  indent: Responsive.scale(context, 72),
                ),
                
                ListTile(
                  leading: Icon(
                    Icons.language,
                    size: Responsive.fontSize(context, 22),
                    color: Colors.purple,
                  ),
                  title: Text(
                    'Idioma',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Português (BR)',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 14),
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: Responsive.scale(context, 8)),
                      Icon(
                        Icons.chevron_right,
                        size: Responsive.fontSize(context, 20),
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Responsive.scale(context, 16),
                    vertical: Responsive.scale(context, 8),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),

          SizedBox(height: Responsive.scale(context, 24)),

          // SEÇÃO: AJUDA E SUPORTE
          // CORREÇÃO: Passe o context para o método
          _buildSectionTitle(context, 'Ajuda e Suporte'),
          
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.security,
                    size: Responsive.fontSize(context, 22),
                    color: Colors.green,
                  ),
                  title: Text(
                    'Termos de Uso e Privacidade',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: Responsive.fontSize(context, 20),
                    color: Colors.grey[400],
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Responsive.scale(context, 16),
                    vertical: Responsive.scale(context, 8),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsScreen(),
                      ),
                    );
                  },
                ),
                
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[200],
                  indent: Responsive.scale(context, 72),
                ),
                
                ListTile(
                  leading: Icon(
                    Icons.help,
                    size: Responsive.fontSize(context, 22),
                    color: Colors.orange,
                  ),
                  title: Text(
                    'Ajuda e Suporte',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: Responsive.fontSize(context, 20),
                    color: Colors.grey[400],
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Responsive.scale(context, 16),
                    vertical: Responsive.scale(context, 8),
                  ),
                  onTap: () {},
                ),
                
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey[200],
                  indent: Responsive.scale(context, 72),
                ),
                
                ListTile(
                  leading: Icon(
                    Icons.info,
                    size: Responsive.fontSize(context, 22),
                    color: Colors.blue,
                  ),
                  title: Text(
                    'Sobre o Aplicativo',
                    style: TextStyle(
                      fontSize: Responsive.fontSize(context, 16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: Responsive.fontSize(context, 20),
                    color: Colors.grey[400],
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Responsive.scale(context, 16),
                    vertical: Responsive.scale(context, 8),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),

          SizedBox(height: Responsive.scale(context, 32)),

          // BOTÃO DE SAIR
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isPhone(context) 
                  ? Responsive.scale(context, 8) 
                  : Responsive.scale(context, 32),
            ),
            child: SizedBox(
              height: Responsive.scale(context, 52),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: Colors.red.withOpacity(0.3),
                ),
                onPressed: () {
                  if (!Responsive.isPhone(context)) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar saída'),
                        content: const Text('Tem certeza que deseja sair da sua conta?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Provider.of<AuthService>(context, listen: false).signOut();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text('Sair', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Provider.of<AuthService>(context, listen: false).signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                icon: Icon(
                  Icons.logout,
                  size: Responsive.fontSize(context, 18),
                ),
                label: Text(
                  'Sair da Conta',
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: Responsive.scale(context, 24)),
          
          // VERSÃO DO APP
          Center(
            child: Text(
              'Versão 1.0.0',
              style: TextStyle(
                fontSize: Responsive.fontSize(context, 12),
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CORREÇÃO: Adicione o parâmetro BuildContext
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: Responsive.scale(context, 8),
        bottom: Responsive.scale(context, 8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: Responsive.fontSize(context, 14),
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}