import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagem de fundo
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

          // Logo no topo
          Positioned(
            top: -47,
            left: 67,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Opacity(
                opacity: 1,
                child: Transform.rotate(
                  angle: 0,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 252,
                    height: 252,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Conteúdo principal
          Positioned(
            bottom: 140,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título estilizado
                SizedBox(
                  width: 275,
                  height: 96,
                  child: Text(
                    'Crie a sua conta',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      height: 48 / 40,
                      letterSpacing: -0.04 * 40, // -4%
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Subtítulo
                Text(
                  'Junte-se à nossa comunidade e compartilhe suas receitas favoritas com o mundo.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),

                // Botão principal (centralizado)
                Center(
                  child: SizedBox(
                    width: 315,
                    height: 60,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.go('/signup'),
                      icon: Icon(Icons.email, color: Colors.white),
                      label: Text(
                        'Crie sua conta com e-mail',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Botões Google e Apple lado a lado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 152.5,
                      height: 60,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {/* Integração Google */},
                        icon: Icon(Icons.g_mobiledata, color: Colors.red),
                        label: Text(
                          'Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 152.5,
                      height: 60,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {/* Integração Apple */},
                        icon: Icon(Icons.apple, color: Colors.black),
                        label: Text(
                          'Apple',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        fontFamily: 'Montserrat',
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