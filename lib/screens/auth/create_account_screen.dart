import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateAccountScreen extends StatelessWidget {
  static const String route = '/create-account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackgroundImage(),
        _buildLogo(),
        _buildContent(context),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Image.asset(
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
    );
  }

  Widget _buildLogo() {
    return Positioned(
      top: -47,
      left: 67,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.asset(
          'assets/images/logo.png',
          width: 252,
          height: 252,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Positioned(
      bottom: 140,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 10),
          _buildSubtitle(context),
          SizedBox(height: 40),
          _buildEmailButton(context),
          SizedBox(height: 20),
          _buildSocialButtons(),
          SizedBox(height: 20),
          _buildLoginLink(context),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return SizedBox(
      width: 275,
      height: 96,
      child: Text(
        'Crie a sua conta',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          fontSize: 40,
          height: 48 / 40,
          letterSpacing: -0.04 * 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'Junte-se à nossa comunidade e compartilhe suas receitas favoritas com o mundo.',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white,
        fontFamily: 'Montserrat',
      ),
    );
  }

  Widget _buildEmailButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 315,
        height: 60,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFA9500),
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSocialButton(
          text: 'Google',
          icon: Icons.g_mobiledata,
          iconColor: Colors.red,
          onPressed: () {
            // TODO: Implementar integração com Google
          },
        ),
        _buildSocialButton(
          text: 'Apple',
          icon: Icons.apple,
          iconColor: Colors.black,
          onPressed: () {
            // TODO: Implementar integração com Apple
          },
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
      width: 152.5,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor),
        label: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Center(
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
    );
  }
}
