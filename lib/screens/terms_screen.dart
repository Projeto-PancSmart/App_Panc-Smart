import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso'),
        // ADICIONADO: título responsivo
        titleTextStyle: TextStyle(
          fontSize: Responsive.fontSize(context, 18),
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.scale(context, 20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CABEÇALHO
            Container(
              padding: EdgeInsets.all(Responsive.scale(context, 20)),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blue[100]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: Responsive.scale(context, 50),
                    height: Responsive.scale(context, 50),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.security,
                      color: Colors.white,
                      size: Responsive.fontSize(context, 24),
                    ),
                  ),
                  SizedBox(width: Responsive.scale(context, 16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Termos de Uso e Política de Privacidade',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: Responsive.scale(context, 6)),
                        Text(
                          'Última atualização: 01/01/2024',
                          style: TextStyle(
                            fontSize: Responsive.fontSize(context, 14),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Responsive.scale(context, 24)),

            // TERMOS
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(Responsive.scale(context, 24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermSection(
                      context,
                      '1. Aceitação dos Termos',
                      'Ao acessar e utilizar o aplicativo Panc Smart - Sistema de Estufa Inteligente, você concorda em cumprir e estar vinculado a estes Termos de Uso. Se você não concordar com qualquer parte destes termos, não poderá utilizar o aplicativo.',
                    ),
                    
                    SizedBox(height: Responsive.scale(context, 20)),
                    
                    _buildTermSection(
                      context,
                      '2. Uso do Sistema',
                      'O aplicativo permite o monitoramento remoto e controle de parâmetros ambientais em estufas inteligentes. Você pode visualizar dados de sensores (temperatura, umidade, nível de água) e controlar dispositivos (bomba de água, LEDs, display LCD) através da interface.',
                    ),
                    
                    SizedBox(height: Responsive.scale(context, 20)),
                    
                    _buildTermSection(
                      context,
                      '3. Responsabilidades do Usuário',
                      'Você é responsável por:\n• Utilizar o sistema de forma adequada e segura\n• Manter suas credenciais de acesso confidenciais\n• Verificar regularmente o funcionamento dos dispositivos controlados\n• Não utilizar o sistema para atividades ilegais ou não autorizadas',
                    ),
                    
                    SizedBox(height: Responsive.scale(context, 20)),
                    
                    _buildTermSection(
                      context,
                      '4. Política de Privacidade',
                      'Coletamos apenas dados necessários para o funcionamento do sistema:\n• Dados de sensores para monitoramento\n• Informações de conta para autenticação\n• Preferências de configuração\n\nSeus dados não são compartilhados com terceiros e são protegidos com criptografia.',
                    ),
                    
                    SizedBox(height: Responsive.scale(context, 20)),
                    
                    _buildTermSection(
                      context,
                      '5. Limitações e Garantias',
                      'O sistema depende de:\n• Conexão estável com a internet\n• Funcionamento adequado dos sensores físicos\n• Energia elétrica para operação dos dispositivos\n\nNão nos responsabilizamos por danos causados por mau uso ou condições fora do nosso controle.',
                    ),
                    
                    SizedBox(height: Responsive.scale(context, 20)),
                    
                    _buildTermSection(
                      context,
                      '6. Modificações nos Termos',
                      'Reservamos o direito de modificar estes termos a qualquer momento. As alterações entrarão em vigor imediatamente após a publicação no aplicativo. O uso contínuo do aplicativo após quaisquer modificações constitui sua aceitação dos novos termos.',
                    ),
                    
                    SizedBox(height: Responsive.scale(context, 20)),
                    
                    _buildTermSection(
                      context,
                      '7. Suporte Técnico',
                      'Oferecemos suporte técnico através do email: suporte@pancsmart.com\n\nHorário de atendimento: Segunda a Sexta, das 9h às 18h.',
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: Responsive.scale(context, 24)),

            // SEÇÃO DE CONCORDÂNCIA (apenas para telas maiores)
            if (!Responsive.isPhone(context))
              Container(
                padding: EdgeInsets.all(Responsive.scale(context, 20)),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.green[100]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: Responsive.fontSize(context, 24),
                    ),
                    SizedBox(width: Responsive.scale(context, 16)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Você concordou com estes termos',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 16),
                              fontWeight: FontWeight.w600,
                              color: Colors.green[800],
                            ),
                          ),
                          SizedBox(height: Responsive.scale(context, 6)),
                          Text(
                            'Ao criar sua conta e utilizar o aplicativo, você aceitou automaticamente estes Termos de Uso.',
                            style: TextStyle(
                              fontSize: Responsive.fontSize(context, 14),
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: Responsive.scale(context, 24)),

            // BOTÕES
            Row(
              children: [
                // BOTÃO VOLTAR
                Expanded(
                  child: SizedBox(
                    height: Responsive.scale(context, 50),
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Colors.grey[400]!,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 16),
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: Responsive.scale(context, 16)),
                
                // BOTÃO ACEITAR (se relevante)
                Expanded(
                  child: SizedBox(
                    height: Responsive.scale(context, 50),
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Termos aceitos',
                              style: TextStyle(
                                fontSize: Responsive.fontSize(context, 14),
                              ),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Aceitar Termos',
                        style: TextStyle(
                          fontSize: Responsive.fontSize(context, 16),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: Responsive.scale(context, 32)),
          ],
        ),
      ),
    );
  }

  // MÉTODO PARA CRIAR SEÇÕES DE TERMOS
  Widget _buildTermSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Responsive.scale(context, 30),
              height: Responsive.scale(context, 30),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  title.split('.')[0], // Pega o número
                  style: TextStyle(
                    fontSize: Responsive.fontSize(context, 12),
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(width: Responsive.scale(context, 12)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: Responsive.fontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: Responsive.scale(context, 12)),
        
        Padding(
          padding: EdgeInsets.only(left: Responsive.scale(context, 42)),
          child: Text(
            content,
            style: TextStyle(
              fontSize: Responsive.fontSize(context, 15),
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}