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
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final Dio _dio = Dio(BaseOptions(baseUrl: apiUrl));
  final storage = FlutterSecureStorage();

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authProvider.notifier).signup(
          _nameController.text,
          _emailController.text,
          _phoneController.text,
          _passwordController.text,
        );
        context.go('/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro no cadastro: Tente novamente')));
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
              Text('Cadastro', style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 10),
              Text('Preencha seus dados nos campos abaixo', style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 20),
              CustomTextField(label: 'Nome completo', controller: _nameController, validatorMessage: 'Campo obrigatório'),
              SizedBox(height: 10),
              CustomTextField(label: 'Email', controller: _emailController, validatorMessage: 'Campo obrigatório'),
              SizedBox(height: 10),
              CustomTextField(label: 'Telefone', controller: _phoneController),
              SizedBox(height: 10),
              CustomTextField(label: 'Senha', obscureText: true, controller: _passwordController, validatorMessage: 'Campo obrigatório'),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Text('Já possui uma conta? Login', style: TextStyle(color: Colors.green)),
              ),
              SizedBox(height: 10),
              Text('Ao se cadastrar você está concordando com os Termos e Condições', style: Theme.of(context).textTheme.bodyMedium),
              Spacer(),
              CustomButton(text: 'Cadastrar', onPressed: _signup),
            ],
          ),
        ),
      ),
    );
  }
}