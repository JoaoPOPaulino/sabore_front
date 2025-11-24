import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class EmailService {
  static const String _serviceId = 'service_wtft4kd';
  static const String _templateId = 'template_emyh9js';
  static const String _userId = 'TSh_PRfSTgC-DHbAd';

  // Gera código de 4 dígitos
  String _generateCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  // Envia email com código
  Future<String> sendVerificationEmail(String toEmail, String userName) async {
    final code = _generateCode();

    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _userId,
          'template_params': {
            'to_email': toEmail,
            'to_name': userName,
            'verification_code': code,
            'app_name': 'Saborê',
          },
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Email enviado com sucesso para $toEmail');
        print('📧 Código: $code'); // ⚠️ REMOVER EM PRODUÇÃO
        return code;
      } else {
        print('❌ Erro ao enviar email: ${response.statusCode}');
        throw Exception('Erro ao enviar email');
      }
    } catch (e) {
      print('❌ Erro: $e');
      // ⚠️ FALLBACK PARA DESENVOLVIMENTO: retorna código mockado
      print('⚠️ MODO DESENVOLVIMENTO - Código: $code');
      return code;
    }
  }

  // Envia email de recuperação de senha
  Future<String> sendRecoveryEmail(String toEmail) async {
    final code = _generateCode();

    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId, // Use outro template se quiser
          'user_id': _userId,
          'template_params': {
            'to_email': toEmail,
            'to_name': 'Usuário',
            'verification_code': code,
            'app_name': 'Saborê',
            'message_type': 'Recuperação de Senha',
          },
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Email de recuperação enviado para $toEmail');
        print('📧 Código: $code'); // ⚠️ REMOVER EM PRODUÇÃO
        return code;
      } else {
        throw Exception('Erro ao enviar email de recuperação');
      }
    } catch (e) {
      print('❌ Erro: $e');
      print('⚠️ MODO DESENVOLVIMENTO - Código: $code');
      return code;
    }
  }
}