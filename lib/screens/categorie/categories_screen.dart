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
                    Icon(
                      Icons.search,
                      color: Color(0xFFFA9500),
                      size: 28,
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
                    Icon(
                      Icons.tune,
                      color: Color(0xFFFA9500),
                      size: 24,
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Grid de categorias
                _buildCategoriesGrid(),
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
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.white, size: 28),
                    onPressed: () => context.go('/home'),
                  ),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: Color(0xFFFA9500),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white, size: 28),
                    onPressed: () => context.push('/setup-profile'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    // Lista de categorias com diferentes tamanhos
    final categories = [
      CategoryItem('Receitas\nJuninas', 'assets/images/chef.jpg', CategorySize.large),
      CategoryItem('Zero lactose', 'assets/images/chef.jpg', CategorySize.medium),
      CategoryItem('Zero Glúten', 'assets/images/chef.jpg', CategorySize.large),
      CategoryItem('Zero açúcar', 'assets/images/chef.jpg', CategorySize.medium),
    ];

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
                  ),
                  SizedBox(height: 12),
                  // Zero açúcar
                  _buildCategoryCard(
                    'Zero açúcar',
                    'assets/images/chef.jpg',
                    height: 134,
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
            // Zero Glúten (grande)
            Expanded(
              flex: 1,
              child: _buildCategoryCard(
                'Zero Glúten',
                'assets/images/chef.jpg',
                height: 134,
              ),
            ),
            SizedBox(width: 12),
            // Categoria adicional
            Expanded(
              flex: 1,
              child: _buildCategoryCard(
                'Fit & Light',
                'assets/images/chef.jpg',
                height: 134,
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
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildCategoryCard(
                'Doces',
                'assets/images/chef.jpg',
                height: 100,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String imagePath, {required double height}) {
    return Container(
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
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: title.length > 15 ? 16 : 18,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

// Enums para organização
enum CategorySize { small, medium, large }

class CategoryItem {
  final String title;
  final String imagePath;
  final CategorySize size;

  CategoryItem(this.title, this.imagePath, this.size);
}