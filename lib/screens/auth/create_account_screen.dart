import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_button.dart';

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Usando chef.jpg conforme pubspec.yaml
          Image.asset(
            'assets/images/chef.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: Center(
                  child: Text(
                    'Imagem não encontrada',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Text(
                'Saborê',
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                )
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crie a sua conta',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Junte-se à nossa comunidade e compartilhe suas receitas favoritas com o mundo.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                CustomButton(
                    text: 'Crie sua conta com e-mail',
                    onPressed: () => context.go('/signup'),
                    icon: Icons.email
                ),
                SizedBox(height: 10),
                CustomButton(
                    text: 'Google',
                    onPressed: () {/* Integre Google SignIn */},
                    icon: Icons.g_mobiledata
                ),
                SizedBox(height: 10),
                CustomButton(
                    text: 'Apple',
                    onPressed: () {/* Integre Apple SignIn */},
                    icon: Icons.apple
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Já possui uma conta? Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}