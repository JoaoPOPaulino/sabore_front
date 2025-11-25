import 'package:flutter/material.dart';
import 'services/sms_service.dart';

class TestSmsScreen extends StatefulWidget {
  @override
  State<TestSmsScreen> createState() => _TestSmsScreenState();
}

class _TestSmsScreenState extends State<TestSmsScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _smsService = SmsService();

  bool _loading = false;
  bool _codeSent = false;
  String _result = '';
  String? _verificationId;

  Future<void> _sendSms() async {
    if (_phoneController.text.isEmpty) {
      setState(() => _result = '❌ Digite um número de telefone');
      return;
    }

    setState(() {
      _loading = true;
      _result = '📱 Enviando SMS...';
    });

    try {
      _verificationId = await _smsService.sendVerificationSms(
        _phoneController.text,
      );

      setState(() {
        _loading = false;
        _codeSent = true;
        _result = '✅ SMS enviado!\n📱 VerificationId: $_verificationId\n\nDigite o código recebido abaixo.';
      });

      // Mostra código de teste se disponível (DEV)
      final testCode = _smsService.getTestCode(_phoneController.text);
      if (testCode != null) {
        setState(() {
          _result += '\n\n🔢 Código de teste (DEV): $testCode';
        });
      }

    } catch (e) {
      setState(() {
        _loading = false;
        _result = '❌ Erro: ${e.toString()}';
      });
    }
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) {
      setState(() => _result = '❌ Digite o código recebido');
      return;
    }

    setState(() {
      _loading = true;
      _result = '🔍 Verificando código...';
    });

    try {
      final isValid = await _smsService.verifyCode(_codeController.text);

      setState(() {
        _loading = false;
        if (isValid) {
          _result = '✅ Código verificado com sucesso!\n🎉 Telefone confirmado!';
        } else {
          _result = '❌ Código inválido';
        }
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
        title: Text('Teste de SMS'),
        backgroundColor: Color(0xFF7CB342),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Teste o envio de SMS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Campo de telefone
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              enabled: !_codeSent,
              decoration: InputDecoration(
                labelText: 'Número de Telefone',
                hintText: '+5563999999999',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                helperText: 'Formato: +55 DDD NÚMERO',
              ),
            ),

            SizedBox(height: 20),

            // Botão enviar SMS
            ElevatedButton(
              onPressed: (_loading || _codeSent) ? null : _sendSms,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7CB342),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _loading && !_codeSent
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Enviar SMS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            if (_codeSent) ...[
              SizedBox(height: 30),
              Divider(),
              SizedBox(height: 20),

              // Campo de código
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Código Recebido',
                  hintText: '123456',
                  prefixIcon: Icon(Icons.sms),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Botão verificar código
              ElevatedButton(
                onPressed: _loading ? null : _verifyCode,
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
                  'Verificar Código',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Botão para reiniciar
              TextButton(
                onPressed: () {
                  setState(() {
                    _codeSent = false;
                    _codeController.clear();
                    _result = '';
                  });
                  _smsService.clearState();
                },
                child: Text('Enviar para outro número'),
              ),
            ],

            SizedBox(height: 30),

            // Resultado
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

            // Informações
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Informações',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• Use o formato internacional: +55 DDD NÚMERO\n'
                        '• Exemplo: +5563999999999\n'
                        '• O Firebase Auth será usado para envio real\n'
                        '• Certifique-se de ter saldo/créditos no Firebase',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}