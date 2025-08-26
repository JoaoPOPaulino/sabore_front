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
  static const String route = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneCodeController = TextEditingController(text: '+55');
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // Services
  final Dio _dio = Dio(BaseOptions(baseUrl: apiUrl));
  final storage = FlutterSecureStorage();

  // State
  bool _obscurePassword = true;
  String _passwordStrength = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneCodeController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFF3C4D18)),
        onPressed: () => context.go('/create-account'),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildLogo(),
        _buildHeader(),
        _buildForm(),
        _buildFooterLinks(),
        _buildTermsText(),
      ],
    );
  }

  Widget _buildLogo() {
    return Positioned(
      top: -22,
      left: 96,
      child: Image.asset(
        'assets/images/logo2.png',
        width: 187,
        height: 187,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
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
    );
  }

  Widget _buildForm() {
    return Positioned(
      top: 295,
      left: 30,
      child: SizedBox(
        width: 315,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameField(),
              SizedBox(height: 10),
              _buildEmailField(),
              SizedBox(height: 10),
              _buildPhoneFields(),
              SizedBox(height: 10),
              _buildPasswordField(),
              SizedBox(height: 10),
              _buildPasswordStrengthIndicator(),
              SizedBox(height: 40),
              _buildSignupButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      label: 'Nome completo',
      controller: _nameController,
      validatorMessage: 'Campo obrigatório',
      keyboardType: TextInputType.name,
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      label: 'Email',
      controller: _emailController,
      validator: _validateEmailFormat,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPhoneFields() {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: CustomTextField(
            label: 'Código',
            controller: _phoneCodeController,
            validatorMessage: 'Obrigatório',
            keyboardType: TextInputType.phone,
          ),
        ),
        SizedBox(width: 5),
        Text('|', style: TextStyle(fontSize: 24, color: Colors.grey)),
        SizedBox(width: 5),
        SizedBox(
          width: 215,
          child: CustomTextField(
            label: 'Telefone (opcional)',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 11,
            validator: _validatePhone,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
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
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    if (_passwordStrength.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Força da senha: $_passwordStrength',
          style: TextStyle(
            color: _getPasswordStrengthColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
        if (_passwordStrength != 'Forte') ...[
          SizedBox(height: 4),
          Text(
            'Dica: Use no mínimo 8 caracteres, incluindo uma letra maiúscula, uma minúscula, um número e um caractere especial.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ],
    );
  }

  Color _getPasswordStrengthColor() {
    switch (_passwordStrength) {
      case 'Forte':
        return Colors.green;
      case 'Média':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Widget _buildSignupButton() {
    return CustomButton(
      text: 'Cadastrar',
      onPressed: _signup,
      icon: Icons.person_add,
    );
  }

  Widget _buildFooterLinks() {
    return Positioned(
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
    );
  }

  Widget _buildTermsText() {
    return Positioned(
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
    );
  }

  // Validation Methods
  String? _validateEmailFormat(String? email) {
    if (email == null || email.isEmpty) {
      return 'Campo obrigatório';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }

  String? _validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return null; // Telefone é opcional
    if (!RegExp(r'^\d{10,11}$').hasMatch(phone)) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }
    return null;
  }

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

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final emailError = await _checkEmailAvailability(_emailController.text);
      if (emailError != null) {
        _showErrorMessage(emailError);
        return;
      }

      await ref.read(authProvider.notifier).signup(
        _nameController.text,
        _emailController.text,
        '${_phoneCodeController.text}${_phoneController.text}',
        _passwordController.text,
      );
      // Remova a navegação explícita e confie no redirecionamento do GoRouter
    } catch (e) {
      _showErrorMessage('Erro no cadastro: Tente novamente');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}