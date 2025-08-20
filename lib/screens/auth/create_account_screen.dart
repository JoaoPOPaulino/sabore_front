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
          Image.asset('assets/images/chef.png', fit: BoxFit.cover),
          Positioned(
            top: 50,
            left: 20,
            child: Text('Saborê', style: TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Crie a sua conta', style: Theme.of(context).textTheme.headlineLarge),
                SizedBox(height: 10),
                Text('Lorem ipsum dolor sit amet, consectetur...', style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 40),
                CustomButton(text: 'Crie sua conta com e-mail', onPressed: () => context.go('/signup'), icon: Icons.email),
                SizedBox(height: 10),
                CustomButton(text: 'Google', onPressed: () {/* Integre Google SignIn */}, icon: Icons.g_mobiledata),
                SizedBox(height: 10),
                CustomButton(text: 'Apple', onPressed: () {/* Integre Apple SignIn */}, icon: Icons.apple),
              ],
            ),
          ),
        ],
      ),
    );
  }
}