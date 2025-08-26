import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String route = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Services
  final Dio _dio = Dio(BaseOptions(baseUrl: apiUrl));
  final storage = FlutterSecureStorage();

  // State
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
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
              'Login',
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
              _buildEmailField(),
              SizedBox(height: 15),
              _buildPasswordField(),
              SizedBox(height: 15),
              _buildForgotPasswordLink(),
              SizedBox(height: 40),
              _buildLoginButton(),
              SizedBox(height: 20),
              _buildSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      label: 'Email',
      controller: _emailController,
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      label: 'Senha',
      obscureText: _obscurePassword,
      controller: _passwordController,
      validatorMessage: 'Campo obrigatório',
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

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _handleForgotPassword,
        child: Text(
          'Esqueceu a senha?',
          style: TextStyle(
            color: Color(0xFF3C4D18),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return CustomButton(
      text: 'Entrar',
      onPressed: _login,
      icon: Icons.login,
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            text: 'Google',
            icon: Icons.g_mobiledata,
            iconColor: Colors.red,
            onPressed: _handleGoogleLogin,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildSocialButton(
            text: 'Apple',
            icon: Icons.apple,
            iconColor: Colors.black,
            onPressed: _handleAppleLogin,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String text,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor),
        label: Text(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Positioned(
      bottom: 100,
      left: 30,
      right: 30,
      child: Center(
        child: GestureDetector(
          onTap: () => context.go('/signup'),
          child: Text(
            'Não possui uma conta? Cadastre-se',
            style: TextStyle(
              color: Color(0xFF3C4D18),
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  // Validation Methods
  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Campo obrigatório';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }

  // Event Handlers
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).login(
        _emailController.text,
        _passwordController.text,
      );
      context.go('/home');
    } catch (e) {
      _showErrorMessage('Erro no login: Verifique suas credenciais');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleForgotPassword() {
    // TODO: Implementar recuperação de senha
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }

  void _handleGoogleLogin() {
    // TODO: Implementar login com Google
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login com Google em desenvolvimento')),
    );
  }

  void _handleAppleLogin() {
    // TODO: Implementar login com Apple
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login com Apple em desenvolvimento')),
    );
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