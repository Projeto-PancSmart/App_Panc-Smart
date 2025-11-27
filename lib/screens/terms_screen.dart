import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Termos de Uso')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Termos de Uso do Sistema de Estufa Inteligente',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '1. Aceitação dos Termos\n\n'
              'Ao utilizar este aplicativo, você concorda com estes termos de uso.\n\n'
              '2. Uso do Sistema\n\n'
              'O sistema permite o monitoramento e controle remoto de uma estufa inteligente.\n\n'
              '3. Responsabilidades\n\n'
              'O usuário é responsável pelo uso adequado do sistema e pelos dispositivos controlados.\n\n'
              '4. Privacidade\n\n'
              'Seus dados são protegidos e não serão compartilhados com terceiros.\n\n'
              '5. Limitações\n\n'
              'O sistema depende da conexão com a internet e dos sensores físicos.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}