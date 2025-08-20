import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_button.dart';
import '../../constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Dio _dio = Dio(BaseOptions(baseUrl: apiUrl));
  final storage = FlutterSecureStorage();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authProvider.notifier).login(_emailController.text, _passwordController.text);
        context.go('/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro no login: Tente novamente')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => context.go('/create-account'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Login', style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Text('Preencha seus dados nos campos abaixo', style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 20),
              CustomTextField(label: 'Email', controller: _emailController, validatorMessage: 'Campo obrigatório'),
              SizedBox(height: 10),
              CustomTextField(label: 'Password', obscureText: true, controller: _passwordController, validatorMessage: 'Campo obrigatório'),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {/* Implemente forgot password */},
                child: Text('Esqueceu a senha?', style: TextStyle(color: Colors.green)),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => context.go('/signup'),
                child: Text('Não possui uma conta? Cadastro', style: TextStyle(color: Colors.green)),
              ),
              Spacer(),
              CustomButton(text: 'Login', onPressed: _login),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: CustomButton(text: 'Google', onPressed: () {/* Google login */}, icon: Icons.g_mobiledata)),
                  SizedBox(width: 10),
                  Expanded(child: CustomButton(text: 'Apple', onPressed: () {/* Apple login */}, icon: Icons.apple)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}