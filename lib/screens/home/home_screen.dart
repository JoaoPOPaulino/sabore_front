// home_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ScrollController _scrollController;

  // Lista de estados brasileiros com suas receitas
  final List<Map<String, String>> states = [
    {'name': 'Tocantins', 'recipes': '50 receitas'},
    {'name': 'Minas Gerais', 'recipes': '40 receitas'},
    {'name': 'Goiás', 'recipes': '70 receitas'},
    {'name': 'Maranhão', 'recipes': '30 receitas'},
    {'name': 'Bahia', 'recipes': '85 receitas'},
    {'name': 'São Paulo', 'recipes': '120 receitas'},
    {'name': 'Rio de Janeiro', 'recipes': '95 receitas'},
    {'name': 'Pernambuco', 'recipes': '60 receitas'},
    {'name': 'Amazonas', 'recipes': '45 receitas'},
    {'name': 'Pará', 'recipes': '55 receitas'},
  ];

  @override
  void initState() {
    super.initState();
    // Inicializa o ScrollController começando no meio da lista virtual
    _scrollController = ScrollController(
      initialScrollOffset: states.length * 50 * 132.0, // 50 é o meio de 100 repetições
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Conteúdo principal
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/images/chef.jpg'),
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
                        context.push('/categories');
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

                // Estados Brasileiros
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

                // CARROSSEL DE ESTADOS COM SCROLL FUNCIONANDO
                Container(
                  height: 140,
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(), // Garante scroll sempre ativo
                      itemCount: states.length * 100, // Multiplica para simular infinito
                      itemBuilder: (context, index) {
                        // Calcula o índice real usando módulo
                        final realIndex = index % states.length;
                        final state = states[realIndex];

                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 6,
                            right: 6,
                          ),
                          child: InkWell(
                            onTap: () {
                              print('🗺️ State card tapped: ${state['name']}');
                              context.push('/states');
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/chef.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.4),
                                      BlendMode.darken
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
                ),

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
                ),
                SizedBox(height: 12),
                _buildTopRecipeCard(
                  'Brownie de chocolate',
                  '45min • 8 ingredientes',
                  'assets/images/chef.jpg',
                  context,
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
                      context.go('/categories');
                    },
                  ),
                  // Add button
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: Color(0xFFFA9500),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: 28),
                      onPressed: () {
                        print('➕ Add button pressed');
                      },
                    ),
                  ),
                  // Notifications
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white, size: 28),
                    onPressed: () {
                      print('🔔 Notifications button pressed');
                    },
                  ),
                  // Profile
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white, size: 28),
                    onPressed: () {
                      print('👤 Profile button pressed');
                      context.push('/setup-profile');
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

  Widget _buildTopRecipeCard(String title, String subtitle, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('🍳 Recipe card tapped: $title');
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