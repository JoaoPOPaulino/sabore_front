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
        _buildOverlay(),
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

  Widget _buildOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 12),
          _buildSubtitle(context),
          SizedBox(height: 40),
          _buildEmailButton(context),
          SizedBox(height: 16),
          _buildSocialButtons(),
          SizedBox(height: 30),
          _buildLoginLink(context),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Crie a sua conta',
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
        fontSize: 42,
        height: 1.2,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'Junte-se à nossa comunidade e compartilhe suas receitas favoritas com o mundo.',
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 15,
        color: Colors.white.withOpacity(0.9),
        height: 1.4,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFA9500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: Color(0xFFFA9500).withOpacity(0.4),
        ),
        onPressed: () => context.go('/signup'),
        icon: Icon(Icons.email, color: Colors.white, size: 22),
        label: Text(
          'Crie sua conta com e-mail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildSocialButton(
            text: 'Google',
            icon: Icons.g_mobiledata,
            iconColor: Colors.red,
            onPressed: () {},
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildSocialButton(
            text: 'Apple',
            icon: Icons.apple,
            iconColor: Colors.black,
            onPressed: () {},
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
      height: 60,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor, size: 24),
        label: Text(
          text,
          style: TextStyle(
            color: Colors.black87,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => context.go('/login'),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            'Já possui uma conta? Login',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
              decorationThickness: 2,
              fontFamily: 'Montserrat',
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}