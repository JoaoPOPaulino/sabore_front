import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../services/mock_auth_service.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;
  bool _canResend = true;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _sendVerificationCode();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    final userData = ref.read(currentUserDataProvider);
    final email = userData?['email'];

    if (email == null) return;

    try {
      final authService = ref.read(authServiceProvider) as MockAuthService;
      await authService.sendEmailVerificationCode(email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código enviado para $email'),
            backgroundColor: Color(0xFF7CB342),
          ),
        );

        setState(() {
          _canResend = false;
          _resendCountdown = 60;
        });

        _startResendTimer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar código'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) {
          _canResend = true;
        } else {
          _startResendTimer();
        }
      });
    });
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();

    if (code.length != 4) {
      _showErrorMessage('Digite o código completo');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userData = ref.read(currentUserDataProvider);
      final email = userData?['email'];

      final authService = ref.read(authServiceProvider) as MockAuthService;
      await authService.verifyEmailCode(email, code);

      // Atualiza o estado local
      if (userData != null) {
        ref.read(currentUserDataProvider.notifier).state = {
          ...userData,
          'emailVerified': true,
        };
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ E-mail verificado com sucesso!'),
            backgroundColor: Color(0xFF7CB342),
          ),
        );

        await Future.delayed(Duration(milliseconds: 500));
        context.go('/home');
      }
    } catch (e) {
      _showErrorMessage(e.toString().replaceAll('Exception: ', ''));
      _clearCode();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearCode() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(currentUserDataProvider);
    final email = userData?['email'] ?? '';

    return Scaffold(
      backgroundColor: Color(0xFFFFF8F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 40),

              // Ícone
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFFFA9500).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.email_outlined,
                  size: 80,
                  color: Color(0xFFFA9500),
                ),
              ),

              SizedBox(height: 32),

              // Título
              Text(
                'Verifique seu e-mail',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: Color(0xFF3C4D18),
                ),
              ),

              SizedBox(height: 12),

              // Subtítulo
              Text(
                'Enviamos um código de 4 dígitos para',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),

              SizedBox(height: 8),

              Text(
                email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFFFA9500),
                ),
              ),

              SizedBox(height: 40),

              // Campos de código
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildCodeField(index)),
              ),

              SizedBox(height: 40),

              // Botão verificar
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFA9500),
                    disabledBackgroundColor: Color(0xFFE0E0E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Color(0xFFFA9500).withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : Text(
                    'Verificar',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Link reenviar
              _canResend
                  ? GestureDetector(
                onTap: _sendVerificationCode,
                child: Text(
                  'Reenviar código',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFFFA9500),
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
                  : Text(
                'Reenviar em $_resendCountdown segundos',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
              ),

              SizedBox(height: 40),

              // Dica
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Não recebeu? Verifique sua caixa de spam',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeField(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: Color(0xFF3C4D18),
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          // Auto-verifica quando todos estão preenchidos
          if (index == 3 && value.isNotEmpty) {
            _verifyCode();
          }
        },
      ),
    );
  }
}