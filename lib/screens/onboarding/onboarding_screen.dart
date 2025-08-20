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
      'title': 'Compartilhe Suas receitas',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur...',
    },
    {
      'image': 'assets/images/onb3.jpg',
      'title': 'Faça parte da comunidade',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur...',
    },
    {
      'image': 'assets/images/onb4.jpg',
      'title': 'Dê o seu toque final',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(_pages[index]['image']!, fit: BoxFit.cover),
                  Positioned(
                    bottom: 100,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        Text('Saborê', style: TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold)),
                        if (_pages[index]['title']!.isNotEmpty) ...[
                          SizedBox(height: 20),
                          Text(_pages[index]['title']!, style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white)),
                          SizedBox(height: 10),
                          Text(_pages[index]['subtitle']!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) => _buildDot(index)),
            ),
          ),
          if (_currentPage == _pages.length - 1)
            Positioned(
              bottom: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () => context.go('/create-account'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Color(0xFFFF5722) : Colors.grey,
      ),
    );
  }
}