import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class EmailService {
  static const String _serviceId = 'service_eir4hpc';
  static const String _templateId = 'template_d9rqkv9';
  static const String _userId = 'TSh_PRfSTgC-DHbAd';

  String _generateCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  Future<String> sendVerificationEmail(String toEmail, String userName) async {
    final code = _generateCode();

    print('📧 Tentando enviar email para: $toEmail');
    print('🔢 Código gerado: $code');

    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost', // ✅ IMPORTANTE
        },
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

      print('📨 Status da resposta: ${response.statusCode}');
      print('📨 Corpo da resposta: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Email enviado com sucesso para $toEmail');
        return code;
      } else {
        print('❌ Erro ao enviar email: ${response.statusCode}');
        print('❌ Resposta: ${response.body}');
        throw Exception('Erro ao enviar email: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exceção ao enviar email: $e');
      rethrow;
    }
  }

  Future<String> sendRecoveryEmail(String toEmail) async {
    final code = _generateCode();

    print('📧 Tentando enviar email de recuperação para: $toEmail');

    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
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
        return code;
      } else {
        print('❌ Erro: ${response.statusCode} - ${response.body}');
        throw Exception('Erro ao enviar email');
      }
    } catch (e) {
      print('❌ Exceção: $e');
      rethrow;
    }
  }
}