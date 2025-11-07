import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Dio _dio = Dio(BaseOptions(baseUrl: apiUrl));
  final storage = FlutterSecureStorage();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _obscurePassword = true;
    print('LoginScreen: _obscurePassword inicializado como $_obscurePassword');
  }

  @override
  void dispose() {
    _emailController.dispose();
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
            SizedBox(height: 100), // Espaço para os botões sociais
            _buildSocialButtons(),
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
          'Login',
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
          _buildEmailField(),
          SizedBox(height: 15),
          _buildPasswordField(),
          SizedBox(height: 15),
          _buildForgotPasswordLink(),
          SizedBox(height: 40),
          _buildLoginButton(),
          SizedBox(height: 30),
          _buildFooterLinks(),
        ],
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
          validator: _validateEmail,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    print('Building password field with _obscurePassword = $_obscurePassword');
    return ClipRRect(
      borderRadius: BorderRadius.circular(25), // ✅ Clip para cortar as bordas
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Campo obrigatório';
            }
            return null;
          },
        ),
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
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFA9500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: Color(0xFFFA9500).withOpacity(0.3),
        ),
        child: Text(
          'Login',
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
        onTap: () => context.go('/signup'),
        child: Text(
          'Não possui uma conta? Cadastro',
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

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            iconPath: 'assets/images/google.png',
            onPressed: _handleGoogleLogin,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _buildSocialButton(
            iconPath: 'assets/images/apple-logo.png',
            onPressed: _handleAppleLogin,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String iconPath,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // ✅ Mais arredondado
        border: Border.all(color: Color(0xFFE0E0E0), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Center(
            child: Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtonWithIcon({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? email) {
    print('Validating email: $email');
    if (email == null || email.isEmpty) {
      return 'Campo obrigatório';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Por favor, insira um e-mail válido';
    }
    return null;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        final isFirstLogin = ref.read(isFirstLoginProvider);
        print('Login successful, first login: $isFirstLogin');

        if (isFirstLogin) {
          context.go('/setup-profile');
        } else {
          context.go('/home');
        }
      }
    } catch (e) {
      _showErrorMessage('Erro no login: Verifique suas credenciais');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleForgotPassword() {
    context.push('/forgot-password');
  }

  void _handleGoogleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login com Google em desenvolvimento')),
    );
  }

  void _handleAppleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login com Apple em desenvolvimento')),
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