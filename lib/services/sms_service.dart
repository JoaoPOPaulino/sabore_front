import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SmsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;

  // Envia SMS com código
  Future<void> sendVerificationSms(
      String phoneNumber, {
        required Function(String) onCodeSent,
        required Function(String) onError,
        Function(PhoneAuthCredential)? onAutoVerified,
      }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),

        // ✅ Quando o código é enviado
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('✅ Verificação automática completa');
          if (onAutoVerified != null) {
            onAutoVerified(credential);
          }
        },

        // ❌ Se houver erro
        verificationFailed: (FirebaseAuthException e) {
          print('❌ Erro na verificação: ${e.message}');
          onError(e.message ?? 'Erro ao enviar SMS');
        },

        // 📱 Quando o código é enviado
        codeSent: (String verificationId, int? resendToken) {
          print('📱 SMS enviado! VerificationId: $verificationId');
          _verificationId = verificationId;
          onCodeSent(verificationId);
        },

        // ⏱️ Timeout
        codeAutoRetrievalTimeout: (String verificationId) {
          print('⏱️ Timeout na verificação');
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      print('❌ Erro ao enviar SMS: $e');
      onError('Erro ao enviar SMS: $e');
    }
  }

  // Verifica o código inserido pelo usuário
  Future<bool> verifyCode(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      print('✅ Código verificado com sucesso!');
      return true;
    } catch (e) {
      print('❌ Código inválido: $e');
      return false;
    }
  }
}