// home_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../providers/auth_provider.dart';
import '../../widgets/profile_image_widget.dart';
import '../../widgets/select_recipe_book_modal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(currentUserDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('👤 Profile button pressed');
                        context.push('/profile/${userData?['id'] ?? '1'}');
                      },
                      child: ProfileImageWidget(userData: userData, radius: 25),
                    ),
                    Text(
                      'Saborê',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: Color(0xFFFA9500),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('🔍 Search icon tapped');
                        context.push('/search'); // NOVA ROTA PARA BUSCA
                      },
                      child: Icon(
                        Icons.search,
                        color: Color(0xFFFA9500),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Título principal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'O que você quer\ncozinhar hoje?',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xFF3C4D18),
                        height: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: Color(0xFFFA9500),
                        size: 24,
                      ),
                      onPressed: () {
                        print('🎛️ Filter button pressed');
                        context.push('/categories');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Botões de categoria
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryButton('Receitas Juninas', context),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildCategoryButton('Brownie', context),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildCategoryButton('Pizza', context),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Receita do dia
                Text(
                  'Receita do dia',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    print('🍰 Recipe of the day tapped');
                    context.push('/recipe/2'); // Navegar para receita do dia
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/images/chef.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.darken
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Canjica zero lactose',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Estados Brasileiros - CARROSSEL AUTOMÁTICO INFINITO
                InfiniteStatesCarousel(),

                SizedBox(height: 30),

                // Top Receitas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Receitas',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('🔝 Top recipes "Ver tudo" tapped');
                        context.push('/categories');
                      },
                      child: Text(
                        'Ver tudo',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF3C4D18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Cards de receitas
                _buildTopRecipeCard(
                  'Bolo de milho sem açúcar',
                  '1h20min • 9 ingredientes',
                  'assets/images/chef.jpg',
                  context,
                  '1', // ID da receita
                ),
                SizedBox(height: 12),
                _buildTopRecipeCard(
                  'Brownie de chocolate',
                  '45min • 8 ingredientes',
                  'assets/images/chef.jpg',
                  context,
                  '3', // ID da receita
                ),
              ],
            ),
          ),

          // Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF3C4D18),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Home - ativo
                  IconButton(
                    icon: Icon(Icons.home, color: Color(0xFFFA9500), size: 28),
                    onPressed: () {
                      print('🏠 Home button pressed - already here');
                    },
                  ),
                  // Search
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white, size: 28),
                    onPressed: () {
                      print('🔍 Search button pressed in bottom nav');
                      context.go('/search');
                    },
                  ),
                  // Add button
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white, size: 28),
                    onPressed: () {
                      context.push('/add-recipe');
                    },
                  ),
                  // Notifications
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white, size: 28),
                    onPressed: () {
                      print('🔔 Notifications button pressed');
                      context.push('/notifications');
                    },
                  ),
                  // Profile - CORRIGIDO
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white, size: 28),
                    onPressed: () {
                      print('👤 Profile button pressed');
                      final userId = userData?['id'] ?? '1';
                      context.push('/profile/$userId');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('🏷️ Category button tapped: $text');
        context.push('/categories');
      },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Color(0xFFFA9500),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRecipeCard(String title, String subtitle, String imagePath, BuildContext context, String recipeId) {
    return GestureDetector(
      onTap: () {
        print('🍳 Recipe card tapped: $title');
        context.push('/recipe/$recipeId'); // Navegar para detalhes da receita
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  print('🔖 Bookmark tapped for: $title');
                  // Mostrar modal para salvar receita
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => SelectRecipeBookModal(),
                  ).then((selectedBook) {
                    if (selectedBook != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Receita "$title" salva em "${selectedBook['title']}"!'),
                          backgroundColor: Color(0xFF7CB342),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '1h20min',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.restaurant, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '9 ingredientes',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe do carrossel automático infinito
class InfiniteStatesCarousel extends StatefulWidget {
  const InfiniteStatesCarousel({Key? key}) : super(key: key);

  @override
  State<InfiniteStatesCarousel> createState() => _InfiniteStatesCarouselState();
}

class _InfiniteStatesCarouselState extends State<InfiniteStatesCarousel> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  final List<Map<String, String>> states = [
    {'name': 'Tocantins', 'recipes': '50 receitas'},
    {'name': 'São Paulo', 'recipes': '120 receitas'},
    {'name': 'Paraná', 'recipes': '65 receitas'},
    {'name': 'Rio de Janeiro', 'recipes': '95 receitas'},
    {'name': 'Maranhão', 'recipes': '30 receitas'},
    {'name': 'Goiás', 'recipes': '70 receitas'},
    {'name': 'Minas Gerais', 'recipes': '85 receitas'},
    {'name': 'Bahia', 'recipes': '75 receitas'},
    {'name': 'Pernambuco', 'recipes': '60 receitas'},
    {'name': 'Ceará', 'recipes': '55 receitas'},
  ];

  @override
  void initState() {
    super.initState();

    // Inicializa o PageController começando no "meio" para simular infinito
    _pageController = PageController(
      initialPage: states.length * 1000,
      viewportFraction: 0.35, // Mostra aproximadamente 3 cards por vez
    );

    _currentPage = states.length * 1000;

    // Timer para avançar automaticamente a cada 3 segundos
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Estados Brasileiros',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xFF3C4D18),
              ),
            ),
            TextButton(
              onPressed: () {
                print('🗺️ States "Ver tudo" pressed');
                context.push('/states');
              },
              child: Text(
                'Ver tudo',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF3C4D18),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),

        // Carrossel infinito
        Container(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              // Usa módulo para criar loop infinito
              final stateIndex = index % states.length;
              final state = states[stateIndex];

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () {
                    // Pausa o timer quando usuário interage
                    _timer.cancel();

                    print('🗺️ State card tapped: ${state['name']}');
                    context.push('/states');

                    // Reinicia o timer após 5 segundos
                    Timer(Duration(seconds: 5), () {
                      if (mounted) {
                        _timer = Timer.periodic(Duration(seconds: 3), (timer) {
                          if (mounted) {
                            _currentPage++;
                            _pageController.animateToPage(
                              _currentPage,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        });
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage('assets/images/chef.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state['name']!,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            state['recipes']!,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 10),

        // Indicadores de posição
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(states.length, (index) {
            final isActive = (_currentPage % states.length) == index;
            return Container(
              width: isActive ? 20 : 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive ? Color(0xFFFA9500) : Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}