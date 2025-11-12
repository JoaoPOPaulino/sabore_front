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
      children: [
        Expanded(
          child: _buildGoogleButton(),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildAppleButton(),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: () {
          print('Google login pressed');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/images/google_logo.png',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Google',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppleButton() {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: () {
          print('Apple login pressed');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.apple,
              size: 26,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Apple',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ],
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