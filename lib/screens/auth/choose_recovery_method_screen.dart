import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseRecoveryMethodScreen extends ConsumerStatefulWidget {
  final String email;
  final String phone;

  const ChooseRecoveryMethodScreen({
    Key? key,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  ConsumerState<ChooseRecoveryMethodScreen> createState() =>
      _ChooseRecoveryMethodScreenState();
}

class _ChooseRecoveryMethodScreenState
    extends ConsumerState<ChooseRecoveryMethodScreen> {
  String _selectedMethod = 'email'; // ✅ Método selecionado

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
        child: Padding(
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

              // Título
              const Text(
                'Método de\nverificação',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: 42,
                  height: 1.2,
                  color: Color(0xFF3C4D18),
                ),
              ),

              const SizedBox(height: 16),

              // Subtítulo
              const Text(
                'Escolha como você quer verificar',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),

              const SizedBox(height: 40),

              // Opções de método
              Row(
                children: [
                  // Email
                  Expanded(
                    child: _buildMethodCard(
                      context: context,
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: _maskEmail(widget.email),
                      color: _selectedMethod == 'email'
                          ? const Color(0xFFFFF3E0)
                          : const Color(0xFFFFF3E0).withOpacity(0.5),
                      isHighlighted: _selectedMethod == 'email',
                      isSelected: _selectedMethod == 'email',
                      onTap: () {
                        setState(() {
                          _selectedMethod = 'email';
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 20),

                  // SMS
                  Expanded(
                    child: _buildMethodCard(
                      context: context,
                      icon: Icons.phone_android,
                      title: 'SMS',
                      subtitle: _maskPhone(widget.phone),
                      color: _selectedMethod == 'sms'
                          ? const Color(0xFF7CB342)
                          : const Color(0xFF7CB342).withOpacity(0.5),
                      isHighlighted: _selectedMethod == 'sms',
                      isSelected: _selectedMethod == 'sms',
                      onTap: () {
                        setState(() {
                          _selectedMethod = 'sms';
                        });
                      },
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // ✅ Botão Próximo (agora usa o método selecionado)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () =>
                      _handleMethodSelection(context, _selectedMethod),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA9500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFFFA9500).withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Próximo',
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isHighlighted = false,
    bool isSelected = false, // ✅ Adicionado
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: const Color(0xFFFA9500), width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? const Color(0xFF3C4D18)
                    : const Color(0xFF3C4D18).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: isHighlighted ? Colors.white : const Color(0xFF3C4D18),
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: isHighlighted ? Colors.white : const Color(0xFF3C4D18),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                color: isHighlighted
                    ? Colors.white.withOpacity(0.9)
                    : const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 3) {
      return '${username[0]}***@$domain';
    }

    return '${username.substring(0, 3)}***@$domain';
  }

  String _maskPhone(String phone) {
    if (phone.length < 4) return phone;
    return '${phone.substring(0, phone.length - 4)}****';
  }

  void _handleMethodSelection(BuildContext context, String method) {
    context.push(
      '/verify-recovery-code',
      extra: {
        'method': method,
        'email': widget.email,
        'phone': widget.phone,
      },
    );
  }
}
