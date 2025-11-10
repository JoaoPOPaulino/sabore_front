import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../services/mock_auth_service.dart';

class VerifyRecoveryCodeScreen extends ConsumerStatefulWidget {
  final String method;
  final String email;
  final String phone;

  const VerifyRecoveryCodeScreen({
    Key? key,
    required this.method,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  ConsumerState<VerifyRecoveryCodeScreen> createState() =>
      _VerifyRecoveryCodeScreenState();
}

class _VerifyRecoveryCodeScreenState
    extends ConsumerState<VerifyRecoveryCodeScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;
  bool _canResend = true;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _sendCode();
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

  // ✅ ENVIA O CÓDIGO USANDO O MockAuthService
  Future<void> _sendCode() async {
    try {
      final authService = ref.read(authServiceProvider) as MockAuthService;
      final destination = widget.method == 'email' ? widget.email : widget.phone;

      // ✅ CHAMA O MÉTODO QUE IMPRIME NO CONSOLE
      await authService.sendRecoveryCode(destination, widget.method);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.method == 'email'
                  ? '📧 Código enviado para seu e-mail'
                  : '📱 Código enviado via SMS',
            ),
            backgroundColor: const Color(0xFF7CB342),
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
        _showErrorMessage('Erro ao enviar código');
      }
    }
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
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

  // ✅ VERIFICA O CÓDIGO USANDO O MockAuthService
  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();

    if (code.length != 4) {
      _showErrorMessage('Digite o código completo');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ✅ VALIDA O CÓDIGO
      final authService = ref.read(authServiceProvider) as MockAuthService;
      final destination = widget.method == 'email' ? widget.email : widget.phone;

      await authService.verifyRecoveryCode(destination, code);

      if (mounted) {
        // ✅ Navega passando o email
        context.push('/reset-password', extra: {'email': widget.email});
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
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF7CB342),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logo2.png',
                  width: 150,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 60),

              const Text(
                'Código',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: 48,
                  color: Color(0xFF3C4D18),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                widget.method == 'email'
                    ? 'Insira o código que chegou no seu e-mail'
                    : 'Insira o código que chegou no seu SMS',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),

              const SizedBox(height: 50),

              // Campos do código
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildCodeField(index)),
              ),

              const SizedBox(height: 40),

              // Botão Verificar
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA9500),
                    disabledBackgroundColor: const Color(0xFFE0E0E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFFFA9500).withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Verificar e confirmar',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Reenviar código
              Center(
                child: _canResend
                    ? GestureDetector(
                  onTap: _sendCode,
                  child: const Text(
                    'Reenviar código',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF7CB342),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
                    : Text(
                  'Reenviar em $_resendCountdown segundos',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),
              ),

              const SizedBox(height: 100),

              // Teclado numérico
              _buildNumericKeypad(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeField(int index) {
    final isFocused = _focusNodes[index].hasFocus;
    final hasValue = _controllers[index].text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: hasValue
            ? const Color(0xFFFA9500).withOpacity(0.1)
            : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isFocused
              ? const Color(0xFFFA9500)
              : hasValue
              ? const Color(0xFFFA9500).withOpacity(0.3)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isFocused
                ? const Color(0xFFFA9500).withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 32,
          color: Color(0xFF3C4D18),
        ),
        decoration: const InputDecoration(
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

          if (index == 3 && value.isNotEmpty) {
            HapticFeedback.mediumImpact();
            _verifyCode();
          }

          setState(() {});
        },
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildKeypadRow(['7', '8', '9']),
          const SizedBox(height: 15),
          _buildKeypadRow(['4', '5', '6']),
          const SizedBox(height: 15),
          _buildKeypadRow(['1', '2', '3']),
          const SizedBox(height: 15),
          _buildKeypadRow(['', '0', 'backspace']),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKeypadButton(key)).toList(),
    );
  }

  Widget _buildKeypadButton(String key) {
    if (key.isEmpty) return const SizedBox(width: 80);

    return GestureDetector(
      onTap: () => _handleKeypadInput(key),
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: key == 'backspace'
              ? const Icon(
            Icons.backspace_outlined,
            color: Color(0xFF3C4D18),
            size: 28,
          )
              : Text(
            key,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 28,
              color: Color(0xFF3C4D18),
            ),
          ),
        ),
      ),
    );
  }

  void _handleKeypadInput(String key) {
    HapticFeedback.lightImpact();

    final emptyIndex = _controllers.indexWhere((c) => c.text.isEmpty);

    if (key == 'backspace') {
      for (int i = 3; i >= 0; i--) {
        if (_controllers[i].text.isNotEmpty) {
          _controllers[i].clear();
          _focusNodes[i].requestFocus();
          setState(() {});
          break;
        }
      }
    } else if (emptyIndex != -1) {
      _controllers[emptyIndex].text = key;
      if (emptyIndex < 3) {
        _focusNodes[emptyIndex + 1].requestFocus();
      } else {
        _verifyCode();
      }
      setState(() {});
    }
  }
}