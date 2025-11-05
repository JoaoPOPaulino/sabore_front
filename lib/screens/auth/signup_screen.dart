import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../services/mock_auth_service.dart';

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
  final _confirmPasswordController = TextEditingController();

  // State
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _passwordStrength = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneCodeController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
        height: 100,
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
          SizedBox(height: 15),
          _buildConfirmPasswordField(),
          SizedBox(height: 10),
          _buildPasswordStrengthIndicator(),
          SizedBox(height: 40),
          _buildSignupButton(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
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
            prefixIcon: Icon(Icons.person_outline, color: Color(0xFFFA9500)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            if (value.trim().split(' ').length < 2) {
              return 'Digite seu nome completo';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
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
            prefixIcon: Icon(Icons.email_outlined, color: Color(0xFFFA9500)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
          validator: _validateEmailFormat,
        ),
      ),
    );
  }

  Widget _buildPhoneFields() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Icon(Icons.phone_outlined, color: Color(0xFFFA9500)),
            ),
            SizedBox(width: 8),
            Container(
              width: 70,
              child: TextFormField(
                controller: _phoneCodeController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d+]')),
                  LengthLimitingTextInputFormatter(4),
                ],
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Color(0xFF3C4D18),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Código';
                  }
                  if (!value.startsWith('+')) {
                    return 'Use +';
                  }
                  return null;
                },
              ),
            ),
            Container(
              height: 30,
              width: 1,
              color: Color(0xFFCCCCCC),
            ),
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                  _PhoneInputFormatter(),
                ],
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  color: Color(0xFF3C4D18),
                ),
                decoration: InputDecoration(
                  hintText: '(00) 00000-0000',
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
      ),
    );
  }

  Widget _buildPasswordField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
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
            prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFFA9500)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
            if (value.length < 8) {
              return 'A senha deve ter no mínimo 8 caracteres';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Color(0xFF3C4D18),
          ),
          decoration: InputDecoration(
            hintText: 'Confirmar senha',
            hintStyle: TextStyle(
              color: Color(0xFF999999),
              fontFamily: 'Montserrat',
            ),
            prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFFA9500)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: Color(0xFF999999),
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            if (value != _passwordController.text) {
              return 'As senhas não coincidem';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    if (_passwordStrength.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Força da senha: ',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontFamily: 'Montserrat',
              ),
            ),
            Text(
              _passwordStrength,
              style: TextStyle(
                color: _getPasswordStrengthColor(),
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                fontSize: 14,
              ),
            ),
          ],
        ),
        if (_passwordStrength != 'Forte') ...[
          SizedBox(height: 4),
          Text(
            'Use no mínimo 8 caracteres com letras maiúsculas, minúsculas, números e símbolos.',
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
      height: 60,
      child: ElevatedButton(
        onPressed: _signup,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFA9500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: Color(0xFFFA9500).withOpacity(0.3),
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
    if (phone == null || phone.isEmpty) {
      return 'Campo obrigatório';
    }

    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      return 'Número inválido';
    }

    final ddd = int.tryParse(cleanPhone.substring(0, 2));
    if (ddd == null || ddd < 11 || ddd > 99) {
      return 'DDD inválido';
    }

    if (cleanPhone.length == 11 && !cleanPhone.startsWith(RegExp(r'\d{2}9'))) {
      return 'Celular deve começar com 9';
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
      final authService = ref.read(authServiceProvider);

      // Verifica se é MockAuthService ou AuthService real
      if (authService is MockAuthService) {
        final isAvailable = await authService.checkEmailAvailability(email);
        if (!isAvailable) {
          return 'Este e-mail já está em uso';
        }
      } else {
        // Para AuthService real (quando implementar)
        final isAvailable = await (authService as dynamic).checkEmailAvailability(email);
        if (!isAvailable) {
          return 'Este e-mail já está em uso';
        }
      }

      return null;
    } catch (e) {
      print('Error checking email: $e');
      return null;
    }
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Verifica disponibilidade do email
      final emailError = await _checkEmailAvailability(_emailController.text);
      if (emailError != null) {
        _showErrorMessage(emailError);
        setState(() => _isLoading = false);
        return;
      }

      // Remove formatação do telefone
      final cleanPhone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
      final fullPhone = '${_phoneCodeController.text}$cleanPhone';

      // Faz o cadastro
      await ref.read(authProvider.notifier).signup(
        _nameController.text.trim(),
        _emailController.text.trim(),
        fullPhone,
        _passwordController.text,
      );

      // ✅ ADICIONE ESTA NAVEGAÇÃO EXPLÍCITA
      if (mounted) {
        print('✅ Signup successful, navigating to setup profile');
        context.go('/setup-profile');
      }
    } on ApiException catch (e) {
      _showErrorMessage(e.message);
    } catch (e) {
      _showErrorMessage('Erro no cadastro. Tente novamente.');
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
        duration: Duration(seconds: 3),
      ),
    );
  }
}

// Formatador personalizado para telefone brasileiro
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    String formatted = '';

    if (text.length <= 2) {
      formatted = '($text';
    } else if (text.length <= 6) {
      formatted = '(${text.substring(0, 2)}) ${text.substring(2)}';
    } else if (text.length <= 10) {
      formatted = '(${text.substring(0, 2)}) ${text.substring(2, 6)}-${text.substring(6)}';
    } else {
      formatted = '(${text.substring(0, 2)}) ${text.substring(2, 7)}-${text.substring(7, 11)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}