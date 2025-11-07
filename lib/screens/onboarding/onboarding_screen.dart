import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/onb1.jpg',
      'title': '',
      'subtitle': '',
    },
    {
      'image': 'assets/images/onb2.jpg',
      'title': 'Compartilhe\nSuas receitas',
      'subtitle': 'Mostre seu talento culinário e inspire outras pessoas.',
    },
    {
      'image': 'assets/images/onb3.jpg',
      'title': 'Faça parte da\ncomunidade',
      'subtitle': 'Troque experiências com quem ama cozinhar.',
    },
    {
      'image': 'assets/images/onb4.jpg',
      'title': 'Dê o seu\ntoque final',
      'subtitle': 'Deixe sua criatividade ser o ingrediente principal.',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Animação de fade para textos
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Animação de scale para logo
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _scaleController.forward();
    _fadeController.forward();

    // Auto-scroll apenas na primeira página após 3 segundos
    if (_currentPage == 0) {
      _autoScrollTimer = Timer(Duration(seconds: 3), () {
        if (mounted && _currentPage == 0) {
          _nextPage();
        }
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      // Reset animações
      _fadeController.reset();
      _fadeController.forward();

      _pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go('/create-account');
    }
  }

  void _skipToEnd() {
    context.go('/create-account');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _currentPage == 0 ? _nextPage : null,
        child: Stack(
          children: [
            // PageView com as telas
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                _fadeController.reset();
                _fadeController.forward();
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(index);
              },
            ),

            // Botão Skip (apenas páginas 1-3)
            if (_currentPage > 0 && _currentPage < _pages.length - 1)
              Positioned(
                top: 50,
                right: 20,
                child: TextButton(
                  onPressed: _skipToEnd,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black26,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Pular',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Indicador de progresso (páginas 1-3)
            if (_currentPage > 0)
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: _buildProgressIndicator(),
              ),

            // Botão de navegação (páginas 1-3)
            if (_currentPage > 0)
              Positioned(
                bottom: 40,
                right: 30,
                child: _buildNavigationButton(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagem de fundo com overlay gradiente
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_pages[index]['image']!),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
        ),

        // ✅ LOGO NO TOPO CENTRALIZADO (página 0)
        if (index == 0)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                children: [
                  // Container com sombra para destaque
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFA9500).withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Nome do app
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Saborê',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        fontSize: 48,
                        letterSpacing: 2,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 3),
                            blurRadius: 12,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Subtítulo do app
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Receitas que aquecem o coração',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Logo pequeno (páginas 1-3)
        if (index > 0)
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

        // Conteúdo de texto (páginas 1-3)
        if (index > 0)
          Positioned(
            bottom: 200,
            left: 30,
            right: 30,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título com animação
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 600),
                    tween: Tween(begin: -50.0, end: 0.0),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(value, 0),
                        child: child,
                      );
                    },
                    child: Text(
                      _pages[index]['title']!,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        fontSize: 42,
                        height: 1.2,
                        letterSpacing: -1.5,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Linha decorativa
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFA9500),
                          Color(0xFFFF6B35),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Subtítulo
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 800),
                    tween: Tween(begin: -30.0, end: 0.0),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(value, 0),
                        child: child,
                      );
                    },
                    child: Text(
                      _pages[index]['subtitle']!,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.white.withOpacity(0.95),
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Dica de toque (apenas página 0)
        if (index == 0)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    'Toque para começar',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  // Ícone animado
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 1500),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 10 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFA9500).withOpacity(0.3),
                        border: Border.all(
                          color: Color(0xFFFA9500),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.touch_app,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_pages.length - 1, (index) {
            final isActive = index == _currentPage - 1;
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: isActive ? 40 : 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isActive
                    ? Color(0xFFFA9500)
                    : Colors.white.withOpacity(0.4),
                boxShadow: isActive
                    ? [
                  BoxShadow(
                    color: Color(0xFFFA9500).withOpacity(0.4),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
                    : null,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavigationButton() {
    final isLastPage = _currentPage == _pages.length - 1;

    return GestureDetector(
      onTap: _nextPage,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFA9500),
              Color(0xFFFF6B35),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFA9500).withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          isLastPage ? Icons.check : Icons.arrow_forward,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}