import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneCodeController = TextEditingController(text: '+55');
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final Dio _dio = Dio(BaseOptions(baseUrl: apiUrl));
  final storage = FlutterSecureStorage();
  bool _obscurePassword = true;
  String _passwordStrength = '';

  // Validação síncrona de e-mail para o TextFormField
  String? _validateEmailFormat(String? email) {
    if (email == null || email.isEmpty) {
      return 'Campo obrigatório';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }

  // Validação assíncrona de e-mail (usada no _signup)
  Future<String?> _checkEmailAvailability(String email) async {
    try {
      final response = await _dio.get('/check-email', queryParameters: {'email': email});
      if (response.data['exists']) {
        return 'Este e-mail já está em uso';
      }
      return null;
    } catch (e) {
      return 'Erro ao verificar o e-mail';
    }
  }

  // Validação de telefone
  String? _validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return null; // Telefone é opcional
    if (!RegExp(r'^\d{10,11}$').hasMatch(phone)) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }
    return null;
  }

  // Validação de força de senha
  String _checkPasswordStrength(String password) {
    if (password.length < 8) return 'Fraca';
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasUppercase && hasLowercase && hasDigit && hasSpecial && password.length >= 12) {
      return 'Forte';
    } else if (hasUppercase && hasLowercase && hasDigit) {
      return 'Média';
    } else {
      return 'Fraca';
    }
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      // Validação assíncrona do e-mail
      final emailError = await _checkEmailAvailability(_emailController.text);
      if (emailError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(emailError)),
        );
        return;
      }

      try {
        await ref.read(authProvider.notifier).signup(
          _nameController.text,
          _emailController.text,
          '${_phoneCodeController.text}${_phoneController.text}',
          _passwordController.text,
        );
        context.go('/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no cadastro: Tente novamente')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF3C4D18)),
          onPressed: () => context.go('/create-account'),
        ),
      ),
      body: Stack(
        children: [
          // Logo no topo
          Positioned(
            top: -22,
            left: 96,
            child: Opacity(
              opacity: 1,
              child: Transform.rotate(
                angle: 0,
                child: Image.asset(
                  'assets/images/logo2.png',
                  width: 187,
                  height: 187,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Título e subtítulo
          Positioned(
            top: 180,
            left: 30,
            child: SizedBox(
              width: 275,
              height: 83,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cadastro',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      height: 48 / 40,
                      letterSpacing: -0.04 * 40,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Preencha seus dados nos campos abaixo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 1,
                      letterSpacing: -0.04 * 12,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Campos de formulário
          Positioned(
            top: 295,
            left: 30,
            child: SizedBox(
              width: 315,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'Nome completo',
                      controller: _nameController,
                      validatorMessage: 'Campo obrigatório',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      validator: _validateEmailFormat,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 70, // Reduzido para evitar overflow
                          child: CustomTextField(
                            label: 'Código',
                            controller: _phoneCodeController,
                            validatorMessage: 'Código obrigatório',
                          ),
                        ),
                        SizedBox(width: 5),
                        Text('|', style: TextStyle(fontSize: 24, color: Colors.grey)),
                        SizedBox(width: 5),
                        SizedBox(
                          width: 215, // Ajustado para caber dentro de 315px
                          child: CustomTextField(
                            label: 'Telefone',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            validator: _validatePhone,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      label: 'Senha',
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      validatorMessage: 'Campo obrigatório',
                      onChanged: (value) {
                        setState(() {
                          _passwordStrength = _checkPasswordStrength(value);
                        });
                      },
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_passwordStrength.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Força da senha: $_passwordStrength',
                            style: TextStyle(
                              color: _passwordStrength == 'Forte'
                                  ? Colors.green
                                  : _passwordStrength == 'Média'
                                  ? Colors.orange
                                  : Colors.red,
                            ),
                          ),
                          if (_passwordStrength != 'Forte')
                            Text(
                              'Dica: Use no mínimo 8 caracteres, incluindo uma letra maiúscula, uma minúscula, um número e um caractere especial.',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    SizedBox(height: 40),
                    CustomButton(
                      text: 'Cadastrar',
                      onPressed: _signup,
                      icon: Icons.person_add,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // "Já possui uma conta? Login"
          Positioned(
            top: 612,
            left: 109,
            child: SizedBox(
              width: 157,
              height: 15,
              child: GestureDetector(
                onTap: () => context.go('/login'),
                child: Text(
                  'Já possui uma conta? Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    height: 1,
                    letterSpacing: -0.04 * 12,
                    color: Color(0xFF3C4D18),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          // "Ao se cadastrar..."
          Positioned(
            top: 668,
            left: 44,
            child: SizedBox(
              width: 271,
              height: 40,
              child: Text(
                'Ao se cadastrar você estará concordando com os Termos e Condições',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  height: 20 / 12,
                  letterSpacing: -0.04 * 12,
                  color: Color(0xFF3C4D18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}