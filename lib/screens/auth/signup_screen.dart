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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFFE65100)))
          : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF7CB342),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => context.go('/create-account'),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogo(),
            SizedBox(height: 40),
            _buildHeader(),
            SizedBox(height: 30),
            _buildForm(),
            SizedBox(height: 20),
            _buildFooterLinks(),
            SizedBox(height: 15),
            _buildTermsText(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/images/logo2.png',
        width: 187,
        height: 100, // Ajustado para não ocupar muito espaço
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cadastro',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 40,
            color: Color(0xFF3C4D18),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Preencha seus dados nos campos abaixo',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNameField(),
          SizedBox(height: 15),
          _buildEmailField(),
          SizedBox(height: 15),
          _buildPhoneFields(),
          SizedBox(height: 15),
          _buildPasswordField(),
          SizedBox(height: 10),
          _buildPasswordStrengthIndicator(),
          SizedBox(height: 40),
          _buildSignupButton(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _nameController,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16,
          color: Color(0xFF3C4D18),
        ),
        decoration: InputDecoration(
          hintText: 'Nome completo',
          hintStyle: TextStyle(
            color: Color(0xFF999999),
            fontFamily: 'Montserrat',
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16,
          color: Color(0xFF3C4D18),
        ),
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(
            color: Color(0xFF999999),
            fontFamily: 'Montserrat',
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        validator: _validateEmailFormat,
      ),
    );
  }

  Widget _buildPhoneFields() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            child: TextFormField(
              controller: _phoneCodeController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                color: Color(0xFF3C4D18),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Obrigatório';
                }
                return null;
              },
            ),
          ),
          Container(
            height: 20,
            width: 1,
            color: Color(0xFFCCCCCC),
          ),
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                color: Color(0xFF3C4D18),
              ),
              decoration: InputDecoration(
                hintText: 'Telefone',
                hintStyle: TextStyle(
                  color: Color(0xFF999999),
                  fontFamily: 'Montserrat',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              ),
              validator: _validatePhone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F5DC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16,
          color: Color(0xFF3C4D18),
        ),
        decoration: InputDecoration(
          hintText: 'Senha',
          hintStyle: TextStyle(
            color: Color(0xFF999999),
            fontFamily: 'Montserrat',
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Color(0xFF999999),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        onChanged: (value) {
          setState(() {
            _passwordStrength = _checkPasswordStrength(value);
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
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
            fontFamily: 'Montserrat',
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
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _signup,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE65100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Cadastrar',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Center(
      child: GestureDetector(
        onTap: () => context.go('/login'),
        child: Text(
          'Já possui uma conta? Login',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF3C4D18),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Center(
      child: Text(
        'Ao se cadastrar você estará concordando com os\nTermos e Condições',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Color(0xFF666666),
          height: 1.4,
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