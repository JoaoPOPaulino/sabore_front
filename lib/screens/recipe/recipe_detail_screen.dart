// lib/screens/recipe/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✨ Importar
import 'package:go_router/go_router.dart';
import 'package:sabore_app/models/models.dart'; // ✨ Importar
import 'package:sabore_app/providers/recipe_provider.dart'; // ✨ Importar
import '../../widgets/select_recipe_book_modal.dart';

// ✨ Mudar para ConsumerStatefulWidget
class RecipeDetailScreen extends ConsumerStatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  // ✨ Mudar para ConsumerState
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  bool isBookmarked = false;
  bool showFullIngredients = false;

  // ✨ REMOVIDO o mapa de 'recipe' mock

  @override
  Widget build(BuildContext context) {
    // ✨ LÓGICA: Busca a receita real usando o provider
    final recipeAsync = ref.watch(recipeDetailProvider(int.parse(widget.recipeId)));

    return recipeAsync.when(
      data: (recipe) {
        // ✨ A UI principal é construída com a receita real
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(recipe),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRecipeHeader(recipe),
                    // ✨ MUDANÇA: UI refatorada para usar dados reais do model
                    _buildRecipeInfo(recipe),
                    _buildIngredientsSection(recipe),
                    if (showFullIngredients) _buildFullRecipeContent(recipe),
                    SizedBox(height: 20),
                    _buildCookButton(),
                    if (!showFullIngredients) ...[
                      SizedBox(height: 30),
                      // ✨ MUDANÇA: Galeria e Comentários removidos
                      _buildCommentsButton(recipe),
                    ],
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFA9500))),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: Text('Erro')),
        body: Center(child: Text('Erro ao carregar receita: $err')),
      ),
    );
  }

  Widget _buildSliverAppBar(Recipe recipe) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF7CB342),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            // ✨ LÓGICA: Usa o 'isSaved' real da receita
            color: recipe.isSaved ? Color(0xFFFA9500) : Color(0xFF3C4D18),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              recipe.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              if (!recipe.isSaved) {
                _showBookmarkModal();
              } else {
                // TODO: Adicionar lógica para remover o save
              }
            },
          ),
        ),
        // TODO: Adicionar lógica real de avaliação
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF7CB342),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.star, color: Colors.white, size: 20),
            onPressed: () {},
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              // ✨ LÓGICA: Usa a imagem real da receita
              image: NetworkImage(recipe.image ?? 'https://via.placeholder.com/400'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ Colors.transparent, Colors.black.withOpacity(0.7) ],
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title, // ✨ LÓGICA: Usa o título real
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeHeader(Recipe recipe) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(recipe.userImage ?? 'https://via.placeholder.com/50'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.userName ?? 'Chef Saborê', // ✨ LÓGICA
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                // TODO: O model não tem 'recipesCount' do usuário,
                // você precisaria de um provider de 'UserDetails' para isso.
                Text(
                  'Autor(a) da receita',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF7CB342),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  '${recipe.averageRating ?? 0.0}', // ✨ LÓGICA
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✨ UI ATUALIZADA: Mostra dados reais do Model
  Widget _buildRecipeInfo(Recipe recipe) {
    // Lógica para extrair a categoria e estado
    String category = recipe.category ?? 'Geral';
    String state = 'N/A';
    if(category.contains(' - ')) {
      var parts = category.split(' - ');
      category = parts[0];
      state = parts[1];
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3E0), // ✨ Cor de card
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            Icons.access_time,
            '${recipe.preparationTime}',
            'Minutos',
          ),
          _buildInfoItem(
            Icons.restaurant,
            '${recipe.servings}',
            'Porções',
          ),
          if (state != 'N/A')
            _buildInfoItem(
              Icons.map,
              state,
              'Estado',
            ),
          _buildInfoItem(
            Icons.category,
            category,
            'Categoria',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFFFA9500), size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF3C4D18),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // ✨ UI ATUALIZADA: Mostra List<String>
  Widget _buildIngredientsSection(Recipe recipe) {
    final displayIngredients = showFullIngredients
        ? recipe.ingredients
        : recipe.ingredients.take(3).toList(); // Mostra 3 por padrão

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredientes',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 16),
          ...displayIngredients.map((ingredient) => Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFFF3E0), // ✨ Cor de card
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Color(0xFFFA9500), size: 20),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    ingredient, // ✨ LÓGICA: Mostra o ingrediente (String)
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildFullRecipeContent(Recipe recipe) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'Modo de preparo',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 16),
          ...recipe.steps.asMap().entries.map((entry) { // ✨ LÓGICA: usa 'steps'
            int index = entry.key;
            String step = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFFFA9500),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF666666),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCookButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            showFullIngredients = !showFullIngredients;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFA9500),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showFullIngredients ? 'Ocultar Preparo' : 'Começar a cozinhar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            if (!showFullIngredients) ...[
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  // ✨ UI ATUALIZADA: Botão para ver comentários
  Widget _buildCommentsButton(Recipe recipe) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comentários',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 12),
          // TODO: Criar tela de comentários e navegar para ela
          GestureDetector(
            onTap: () {
              // context.push('/recipe/${recipe.id}/comments');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tela de comentários em breve!')));
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ver ${recipe.commentsCount} comentários',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF666666),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey[500], size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookmarkModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectRecipeBookModal(),
    ).then((selectedBook) {
      if (selectedBook != null) {
        setState(() {
          isBookmarked = true;
          // TODO: Chamar provider para salvar
          // ref.read(recipesProvider.notifier).toggleSave(int.parse(widget.recipeId));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Receita salva em "${selectedBook['title']}"!'),
            backgroundColor: Color(0xFF7CB342),
          ),
        );
      }
    });
  }
}