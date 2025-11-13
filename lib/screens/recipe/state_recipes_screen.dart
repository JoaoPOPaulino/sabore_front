// lib/screens/recipe/state_recipes_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sabore_app/providers/state_provider.dart';
import 'package:sabore_app/providers/auth_provider.dart';

class StateRecipesScreen extends ConsumerWidget {
  final String stateName;
  final String stateEmoji;
  final int stateColor;

  const StateRecipesScreen({
    Key? key,
    required this.stateName,
    required this.stateEmoji,
    required this.stateColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(currentUserDataProvider);
    final recipesAsync = ref.watch(recipesByStateProvider(stateName));

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // Gradiente de fundo
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(stateColor).withOpacity(0.3),
                  Color(0xFFFAFAFA),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context),

                // Conteúdo
                Expanded(
                  child: recipesAsync.when(
                    data: (recipes) => _buildRecipesList(context, recipes),
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(stateColor),
                        ),
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Erro ao carregar receitas'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Navigation
          _buildBottomNavigationBar(context, userData),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(stateColor),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Saborê',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: Color(0xFFFA9500),
                ),
              ),
              Spacer(),
              SizedBox(width: 44), // Espaço para balancear
            ],
          ),
          SizedBox(height: 24),
          // Badge do estado
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(stateColor),
                  Color(stateColor).withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(stateColor).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stateEmoji,
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stateName,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Receitas Típicas',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesList(BuildContext context, List<dynamic> recipes) {
    if (recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Color(stateColor).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 64,
                color: Color(stateColor),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Nenhuma receita encontrada',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Seja o primeiro a adicionar!',
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

    return ListView.builder(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 100, // ← ADICIONAR PADDING INFERIOR PARA NÃO CORTAR
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _buildRecipeCard(context, recipe);
      },
    );
  }

  Widget _buildRecipeCard(BuildContext context, dynamic recipe) {
    return GestureDetector(
      onTap: () {
        print('🍽️ Navegando para receita: ${recipe.id}');
        context.push('/recipe/${recipe.id}');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagem
            Container(
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                image: DecorationImage(
                  image: AssetImage(recipe.image ?? 'assets/images/chef.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Conteúdo
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Color(0xFF999999)),
                        SizedBox(width: 4),
                        Text(
                          '${recipe.preparationTime}min',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.star, size: 14, color: Color(0xFFFA9500)),
                        SizedBox(width: 4),
                        Text(
                          recipe.averageRating?.toStringAsFixed(1) ?? '0.0',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3C4D18),
                          ),
                        ),
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

  Widget _buildBottomNavigationBar(BuildContext context, Map<String, dynamic>? userData) {
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
            _buildNavItem(Icons.search, false, () => context.push('/search')),
            _buildNavItemFAB(Icons.add, () => context.push('/add-recipe')),
            _buildNavItem(Icons.notifications_outlined, false, () => context.push('/notifications')),
            _buildNavItem(Icons.person_outline, false, () => context.push('/profile/${userData?['id'] ?? '1'}')),
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