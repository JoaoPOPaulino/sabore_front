import 'package:flutter/material.dart';
import 'services/email_service.dart';

class TestEmailScreen extends StatefulWidget {
  @override
  State<TestEmailScreen> createState() => _TestEmailScreenState();
}

class _TestEmailScreenState extends State<TestEmailScreen> {
  final _emailController = TextEditingController();
  final _emailService = EmailService();
  bool _loading = false;
  String _result = '';

  Future<void> _testEmail() async {
    if (_emailController.text.isEmpty) {
      setState(() => _result = '❌ Digite um email');
      return;
    }

    setState(() {
      _loading = true;
      _result = '📧 Enviando email...';
    });

    try {
      final code = await _emailService.sendVerificationEmail(
        _emailController.text,
        'Teste',
      );

      setState(() {
        _loading = false;
        _result = '✅ Email enviado!\n📧 Código: $code\n\nVerifique sua caixa de entrada e spam.';
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _result = '❌ Erro: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste de Email'),
        backgroundColor: Color(0xFFFA9500),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Teste o envio de email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Seu Email',
                hintText: 'exemplo@gmail.com',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loading ? null : _testEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFA9500),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Enviar Email de Teste',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 30),

            if (_result.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _result.contains('✅')
                      ? Colors.green[50]
                      : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _result.contains('✅')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                child: Text(
                  _result,
                  style: TextStyle(
                    fontSize: 14,
                    color: _result.contains('✅')
                        ? Colors.green[900]
                        : Colors.red[900],
                  ),
                ),
              ),

            SizedBox(height: 20),

            Text(
              'Configurações do EmailJS:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Service ID: service_wtft4kd\n'
                  'Template ID: template_emyh9js\n'
                  'User ID: TSh_PRfSTgC-DHbAd',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}