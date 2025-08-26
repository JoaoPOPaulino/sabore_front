import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/onb1.jpg',
      'title': '',
      'subtitle': '',
    },
    {
      'image': 'assets/images/onb2.jpg',
      'title': 'Compartilhe\nSuas receitas',
      'subtitle': 'Mostre seu talento e inspire outras pessoas.',
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // 👉 Na tela 0, qualquer clique avança
        onTap: _currentPage == 0 ? _nextPage : null,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _pages[index]['image']!,
                      fit: BoxFit.cover,
                    ),
                    // 👉 Logo como imagem
                    Positioned(
                      top: index == 0 ? 426 : -34,
                      left: index == 0 ? 3 : 62,
                      child: SizedBox(
                        width: index == 0 ? 369 : 252,
                        height: index == 0 ? 369 : 252,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    // Conteúdo só aparece a partir da 2ª tela
                    if (index > 0)
                      Positioned(
                        bottom: 180,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _pages[index]['title']!,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 40,
                                height: 48 / 40, // line-height
                                letterSpacing: -0.04 * 40, // -4% do tamanho
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              _pages[index]['subtitle']!,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
            // Progress bar customizado - só aparece a partir da 2ª tela
            if (_currentPage > 0)
              Positioned(
                top: 737,
                left: 21,
                child: Container(
                  width: 100,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Color(0xFF3C4D18), // Cor de fundo
                    borderRadius: BorderRadius.circular(3.5),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: (100 * _currentPage) / (_pages.length - 1), // Calcula o progresso baseado nas telas visíveis (excluindo a primeira)
                        height: 7,
                        decoration: BoxDecoration(
                          color: Color(0xFFFA9500), // Cor do progresso
                          borderRadius: BorderRadius.circular(3.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Seta só aparece a partir da 2ª tela
            if (_currentPage > 0)
              Positioned(
                bottom: 30,
                right: 20,
                child: GestureDetector(
                  onTap: _currentPage < _pages.length - 1
                      ? _nextPage
                      : () => context.go('/create-account'),
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}