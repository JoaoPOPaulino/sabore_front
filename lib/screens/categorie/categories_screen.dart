// categories_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                // Header com botão de voltar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Botão de voltar
                        GestureDetector(
                          onTap: () {
                            print('⬅️ Back button tapped');
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFFFA9500).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Color(0xFFFA9500),
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage('assets/images/chef.jpg'),
                        ),
                      ],
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
                        print('🔍 Search icon tapped in categories');
                        // Implementar busca nas categorias
                      },
                      child: Icon(
                        Icons.search,
                        color: Color(0xFFFA9500),
                        size: 28,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Título e filtro
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categorias',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('🎛️ Filter icon tapped');
                        _showFilterBottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFFFA9500).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: Color(0xFFFA9500),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Grid de categorias
                _buildCategoriesGrid(context),
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
                  // Home
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.white, size: 28),
                    onPressed: () {
                      print('🏠 Home button pressed from categories');
                      context.go('/home');
                    },
                  ),
                  // Search - ativo
                  IconButton(
                    icon: Icon(Icons.search, color: Color(0xFFFA9500), size: 28),
                    onPressed: () {
                      print('🔍 Search button pressed - already in categories');
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
                        print('➕ Add button pressed from categories');
                        // Implementar adicionar receita
                      },
                    ),
                  ),
                  // Notifications
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white, size: 28),
                    onPressed: () {
                      print('🔔 Notifications button pressed from categories');
                      // Implementar notificações
                    },
                  ),
                  // Profile
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white, size: 28),
                    onPressed: () {
                      print('👤 Profile button pressed from categories');
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

  Widget _buildCategoriesGrid(BuildContext context) {
    return Column(
      children: [
        // Primeira linha
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Receitas Juninas (grande)
            Expanded(
              flex: 1,
              child: _buildCategoryCard(
                'Receitas\nJuninas',
                'assets/images/chef.jpg',
                height: 280,
                context: context,
              ),
            ),
            SizedBox(width: 12),
            // Coluna direita
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  // Zero lactose
                  _buildCategoryCard(
                    'Zero lactose',
                    'assets/images/chef.jpg',
                    height: 134,
                    context: context,
                  ),
                  SizedBox(height: 12),
                  // Zero açúcar
                  _buildCategoryCard(
                    'Zero açúcar',
                    'assets/images/chef.jpg',
                    height: 134,
                    context: context,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        // Segunda linha
        Row(
          children: [
            // Zero Glúten
            Expanded(
              flex: 1,
              child: _buildCategoryCard(
                'Zero Glúten',
                'assets/images/chef.jpg',
                height: 134,
                context: context,
              ),
            ),
            SizedBox(width: 12),
            // Fit & Light
            Expanded(
              flex: 1,
              child: _buildCategoryCard(
                'Fit & Light',
                'assets/images/chef.jpg',
                height: 134,
                context: context,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),

        // Terceira linha - items menores na parte inferior
        Row(
          children: [
            Expanded(
              child: _buildCategoryCard(
                'Vegano',
                'assets/images/chef.jpg',
                height: 100,
                context: context,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildCategoryCard(
                'Doces',
                'assets/images/chef.jpg',
                height: 100,
                context: context,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
      String title,
      String imagePath, {
        required double height,
        required BuildContext context,
      }) {
    return GestureDetector(
      onTap: () {
        print('🏷️ Category tapped: $title');
        _showCategoryBottomSheet(context, title);
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: title.length > 15 ? 16 : 18,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(0xFFFA9500),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Ver receitas',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context, String categoryTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categoryTitle,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Color(0xFF3C4D18)),
                  ),
                ],
              ),
            ),
            Divider(),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filtros rápidos
                    Text(
                      'Filtros rápidos:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterChip('Fácil'),
                        _buildFilterChip('Médio'),
                        _buildFilterChip('Difícil'),
                        _buildFilterChip('Rápido'),
                        _buildFilterChip('Vegetariano'),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Lista de receitas exemplo
                    Text(
                      'Receitas populares:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    SizedBox(height: 12),

                    Expanded(
                      child: ListView(
                        children: [
                          _buildRecipeListItem(
                            'Bolo de milho ${categoryTitle.toLowerCase()}',
                            '45 min • Fácil',
                            'assets/images/chef.jpg',
                          ),
                          _buildRecipeListItem(
                            'Pudim ${categoryTitle.toLowerCase()}',
                            '2h • Médio',
                            'assets/images/chef.jpg',
                          ),
                          _buildRecipeListItem(
                            'Brigadeiro ${categoryTitle.toLowerCase()}',
                            '20 min • Fácil',
                            'assets/images/chef.jpg',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 12,
          color: Color(0xFF3C4D18),
        ),
      ),
      selected: false,
      onSelected: (bool selected) {
        print('Filter selected: $label - $selected');
      },
      backgroundColor: Colors.grey[100],
      selectedColor: Color(0xFFFA9500).withOpacity(0.3),
      checkmarkColor: Color(0xFF3C4D18),
    );
  }

  Widget _buildRecipeListItem(String title, String subtitle, String imagePath) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtros',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Color(0xFF3C4D18)),
                  ),
                ],
              ),
            ),
            Divider(),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dificuldade:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterChip('Fácil'),
                        _buildFilterChip('Médio'),
                        _buildFilterChip('Difícil'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Tempo de preparo:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterChip('Até 30 min'),
                        _buildFilterChip('30-60 min'),
                        _buildFilterChip('Mais de 1h'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Tipo de dieta:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterChip('Vegetariano'),
                        _buildFilterChip('Vegano'),
                        _buildFilterChip('Sem glúten'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enums para organização (mantidos do código original)
enum CategorySize { small, medium, large }

class CategoryItem {
  final String title;
  final String imagePath;
  final CategorySize size;

  CategoryItem(this.title, this.imagePath, this.size);
}