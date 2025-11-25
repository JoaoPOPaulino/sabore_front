import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SmsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;
  String? _lastPhoneNumber;

  // Armazena códigos para teste (apenas em desenvolvimento)
  final Map<String, String> _testCodes = {};

  /// Envia SMS com código de verificação
  Future<String> sendVerificationSms(String phoneNumber) async {
    try {
      print('📱 Iniciando envio de SMS para: $phoneNumber');

      // Formata o número para o padrão internacional
      final formattedPhone = _formatPhoneNumber(phoneNumber);
      _lastPhoneNumber = formattedPhone;

      final completer = Completer<String>();

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),

        // ✅ Verificação automática (Android pode fazer isso)
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('✅ Verificação automática completa');
          if (!completer.isCompleted) {
            completer.complete(_verificationId ?? '');
          }
        },

        // ❌ Se houver erro
        verificationFailed: (FirebaseAuthException e) {
          print('❌ Erro na verificação: ${e.code} - ${e.message}');
          if (!completer.isCompleted) {
            completer.completeError(_getErrorMessage(e));
          }
        },

        // 📱 Quando o código é enviado com sucesso
        codeSent: (String verificationId, int? resendToken) {
          print('📱 SMS enviado! VerificationId: $verificationId');
          _verificationId = verificationId;

          // Gera código de teste para desenvolvimento
          final testCode = _generateTestCode();
          _testCodes[formattedPhone] = testCode;
          print('🔢 Código de teste (DEV): $testCode');

          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },

        // ⏱️ Timeout
        codeAutoRetrievalTimeout: (String verificationId) {
          print('⏱️ Timeout na recuperação automática');
          _verificationId = verificationId;
        },
      );

      return await completer.future;
    } catch (e) {
      print('❌ Erro ao enviar SMS: $e');
      throw Exception('Erro ao enviar SMS: $e');
    }
  }

  /// Verifica o código inserido pelo usuário
  Future<bool> verifyCode(String smsCode) async {
    if (_verificationId == null) {
      throw Exception('Nenhuma verificação em andamento');
    }

    try {
      print('🔍 Verificando código: $smsCode');

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      // Tenta fazer o sign-in com a credencial
      final userCredential = await _auth.signInWithCredential(credential);

      print('✅ Código verificado com sucesso!');
      print('✅ UID: ${userCredential.user?.uid}');

      // Limpa o estado após verificação bem-sucedida
      _verificationId = null;
      _lastPhoneNumber = null;

      return true;
    } on FirebaseAuthException catch (e) {
      print('❌ Erro ao verificar código: ${e.code} - ${e.message}');

      if (e.code == 'invalid-verification-code') {
        throw Exception('Código inválido');
      } else if (e.code == 'session-expired') {
        throw Exception('Código expirado. Solicite um novo código.');
      }

      throw Exception(_getErrorMessage(e));
    } catch (e) {
      print('❌ Erro inesperado: $e');
      throw Exception('Erro ao verificar código');
    }
  }

  /// Formata o número de telefone para o padrão internacional
  String _formatPhoneNumber(String phone) {
    // Remove caracteres não numéricos
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // Se já começa com +, retorna como está
    if (cleaned.startsWith('+')) {
      return cleaned;
    }

    // Se começa com 55 (Brasil), adiciona +
    if (cleaned.startsWith('55')) {
      return '+$cleaned';
    }

    // Se não tem código do país, assume Brasil (+55)
    if (cleaned.length == 11 || cleaned.length == 10) {
      return '+55$cleaned';
    }

    return cleaned;
  }

  /// Gera código de teste para desenvolvimento
  String _generateTestCode() {
    return '${DateTime.now().millisecondsSinceEpoch % 10000}'.padLeft(4, '0');
  }

  /// Converte erros do Firebase em mensagens amigáveis
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Número de telefone inválido';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Autenticação por SMS não habilitada';
      case 'missing-client-identifier':
        return 'Erro de configuração. Contate o suporte.';
      case 'quota-exceeded':
        return 'Limite de SMS excedido. Tente novamente mais tarde.';
      default:
        return e.message ?? 'Erro ao enviar SMS';
    }
  }

  /// Limpa o estado atual
  void clearState() {
    _verificationId = null;
    _lastPhoneNumber = null;
  }

  /// Retorna o último número usado (para debug)
  String? get lastPhoneNumber => _lastPhoneNumber;

  /// Retorna o código de teste (apenas DEV)
  String? getTestCode(String phone) {
    final formatted = _formatPhoneNumber(phone);
    return _testCodes[formatted];
  }
}