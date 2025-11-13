// lib/screens/categories_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sabore_app/providers/auth_provider.dart';
import 'package:sabore_app/providers/category_provider.dart';
import 'dart:math' as math;

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(currentUserDataProvider);
    final categoriesAsync = ref.watch(categoriesWithCountProvider);

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // Gradiente de fundo
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF8F0),
                  Color(0xFFFAFAFA),
                ],
              ),
            ),
          ),

          // Conteúdo
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(userData),

                // Conteúdo principal
                Expanded(
                  child: categoriesAsync.when(
                    data: (categories) => _buildCategoriesContent(categories),
                    loading: () => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFFA9500),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Carregando categorias...',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Erro ao carregar categorias',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Navigation
          _buildBottomNavigationBar(userData),
        ],
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic>? userData) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF7CB342),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
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
                  context.push('/search');
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search,
                    color: Color(0xFFFA9500),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Categorias',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Tamanho = popularidade 📊',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesContent(List<CategoryData> categories) {
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 80,
              color: Color(0xFFE0E0E0),
            ),
            SizedBox(height: 16),
            Text(
              'Nenhuma categoria encontrada',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _buildDynamicMasonryGrid(categories),
    );
  }

  Widget _buildDynamicMasonryGrid(List<CategoryData> categories) {
    // Normalizar tamanhos baseados na quantidade de receitas
    final maxCount = categories.first.recipesCount.toDouble();
    final minCount = categories.last.recipesCount.toDouble();

    return Column(
      children: _buildMasonryRows(categories, maxCount, minCount),
    );
  }

  List<Widget> _buildMasonryRows(
      List<CategoryData> categories,
      double maxCount,
      double minCount,
      ) {
    final List<Widget> rows = [];
    int index = 0;

    while (index < categories.length) {
      // Padrão alternado: Grande + Pequeno, Pequeno + Grande
      final isEvenRow = (rows.length % 2 == 0);

      if (index < categories.length) {
        final leftCategory = categories[index];
        final rightCategory =
        index + 1 < categories.length ? categories[index + 1] : null;

        rows.add(
          _buildMasonryRow(
            leftCategory,
            rightCategory,
            maxCount,
            minCount,
            isEvenRow,
          ),
        );

        index += rightCategory != null ? 2 : 1;
      }
    }

    return rows;
  }

  Widget _buildMasonryRow(
      CategoryData leftCategory,
      CategoryData? rightCategory,
      double maxCount,
      double minCount,
      bool leftLarger,
      ) {
    // Calcular alturas proporcionais
    final leftHeight = _calculateHeight(leftCategory.recipesCount, maxCount, minCount);
    final rightHeight = rightCategory != null
        ? _calculateHeight(rightCategory.recipesCount, maxCount, minCount)
        : 150.0;

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card esquerdo
          Expanded(
            flex: leftLarger ? 3 : 2,
            child: _buildCategoryCard(
              leftCategory,
              leftHeight,
              0,
            ),
          ),

          if (rightCategory != null) ...[
            SizedBox(width: 12),
            // Card direito
            Expanded(
              flex: leftLarger ? 2 : 3,
              child: _buildCategoryCard(
                rightCategory,
                rightHeight,
                1,
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _calculateHeight(int count, double maxCount, double minCount) {
    // Normalizar entre 150 (min) e 280 (max)
    const minHeight = 150.0;
    const maxHeight = 280.0;

    if (maxCount == minCount) return minHeight;

    final normalized = (count - minCount) / (maxCount - minCount);
    return minHeight + (normalized * (maxHeight - minHeight));
  }

  Widget _buildCategoryCard(
      CategoryData category,
      double height,
      int index,
      ) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.3),
          end: Offset.zero,
        ).animate(animation),
        child: GestureDetector(
          onTap: () {
            print('🏷️ Category tapped: ${category.name}');
            _showCategoryBottomSheet(category);
          },
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(category.color),
                  Color(category.color).withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(category.color).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Pattern de fundo
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/images/chef.jpg'),
                        fit: BoxFit.cover,
                        opacity: 0.15,
                      ),
                    ),
                  ),
                ),

                // Badge de quantidade no topo direito
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 14,
                          color: Color(category.color),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${category.recipesCount}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(category.color),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Conteúdo
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        category.emoji,
                        style: TextStyle(fontSize: height > 200 ? 48 : 32),
                      ),
                      SizedBox(height: 8),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          fontSize: height > 200 ? 24 : 18,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${category.recipesCount} ${category.recipesCount == 1 ? 'receita' : 'receitas'}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(CategoryData category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(category.color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category.emoji,
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Color(0xFF3C4D18),
                          ),
                        ),
                        Text(
                          '${category.recipesCount} receitas disponíveis',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ),

            Divider(height: 32),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Em breve: lista de receitas',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        color: Color(0xFF999999),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Icon(
                        Icons.construction,
                        size: 64,
                        color: Color(0xFFE0E0E0),
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

  Widget _buildBottomNavigationBar(Map<String, dynamic>? userData) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 75,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF3C4D18),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF3C4D18).withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, false, () => context.go('/home')),
            _buildNavItem(Icons.search, true, () {}), // Ativo
            _buildNavItemFAB(Icons.add, () => context.push('/add-recipe')),
            _buildNavItem(Icons.notifications_outlined, false,
                    () => context.push('/notifications')),
            _buildNavItem(Icons.person_outline, false,
                    () => context.push('/profile/${userData?['id'] ?? '1'}')),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFFFA9500) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white70,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildNavItemFAB(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFA9500), Color(0xFFFF6B35)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFA9500).withOpacity(0.4),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
