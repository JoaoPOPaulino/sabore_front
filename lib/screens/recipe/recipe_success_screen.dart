import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecipeSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Auto-redirect após 3 segundos
    Future.delayed(Duration(seconds: 3), () {
      if (context.mounted) {
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: Color(0xFFFA9500),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Text(
                'SABORÊ',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w900,
                  fontSize: 48,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 80),

              // Título principal
              Text(
                'Delícia',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w900,
                  fontSize: 64,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Subtítulo
              Text(
                'Receita criada com sucesso!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),

              Spacer(),

              // Botão Voltar
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7CB342),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Voltar',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}