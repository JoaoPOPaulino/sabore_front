// lib/screens/recipe/recipe_detail_screen.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sabore_app/models/models.dart';
import 'package:sabore_app/providers/recipe_provider.dart';
import 'package:sabore_app/providers/auth_provider.dart';
import 'package:sabore_app/widgets/profile_image_widget.dart';
import '../../widgets/select_recipe_book_modal.dart';
import '../../providers/recipe_book_provider.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  bool isBookmarked = false;
  bool showFullIngredients = false;

  // Controllers e estados para comentários
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmittingComment = false;
  double _userRating = 5.0;
  List<Map<String, dynamic>> _comments = [];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // ✅ FUNÇÃO HELPER PARA CRIAR ImageProvider CORRETO
  ImageProvider _getRecipeImageProvider(Recipe recipe) {
    // Verificar se tem bytes (WEB)
    if (recipe.imageBytes != null) {
      print('✅ Usando MemoryImage para receita ${recipe.id}');
      return MemoryImage(recipe.imageBytes!);
    }

    // Verificar se tem imagem
    if (recipe.image == null || recipe.image!.isEmpty) {
      return AssetImage('assets/images/chef.jpg');
    }

    // Se é URL HTTP/HTTPS
    if (recipe.image!.startsWith('http')) {
      return NetworkImage(recipe.image!);
    }

    // Se começa com assets/, usar AssetImage
    if (recipe.image!.startsWith('assets/')) {
      return AssetImage(recipe.image!);
    }

    // Se está na WEB mas não tem bytes, usar placeholder
    if (kIsWeb) {
      print('⚠️ Imagem sem bytes na WEB: ${recipe.image}');
      return AssetImage('assets/images/chef.jpg');
    }

    // Mobile/Desktop: usar FileImage
    return FileImage(File(recipe.image!));
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final currentUser = ref.read(currentUserDataProvider);
    if (currentUser == null) return;

    setState(() {
      _isSubmittingComment = true;
    });

    await Future.delayed(Duration(milliseconds: 800));

    final newComment = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'userId': currentUser['id'],
      'userName': currentUser['name'],
      'userImage': currentUser['profileImage'],
      'comment': _commentController.text.trim(),
      'rating': _userRating,
      'timestamp': DateTime.now(),
    };

    setState(() {
      _comments.insert(0, newComment);
      _isSubmittingComment = false;
      _commentController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Comentário adicionado com sucesso!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFF7CB342),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeId = int.parse(widget.recipeId);
    final recipeAsync = ref.watch(recipeDetailProvider(recipeId));

    return recipeAsync.when(
      data: (recipe) {
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
                    _buildRecipeInfo(recipe),
                    _buildIngredientsSection(recipe),
                    if (showFullIngredients) _buildFullRecipeContent(recipe),
                    SizedBox(height: 20),
                    _buildCookButton(),
                    if (!showFullIngredients) ...[
                      SizedBox(height: 30),
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
        appBar: AppBar(
          title: Text('Erro'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Erro ao carregar receita'),
              SizedBox(height: 8),
              Text('$err', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(Recipe recipe) {
    final currentUserId = ref.watch(currentUserDataProvider)?['id'];
    final isAuthor = currentUserId != null && int.parse(currentUserId.toString()) == recipe.userId;

    // ✅ ADICIONAR ESTA LINHA:
    final isSavedAsync = currentUserId != null
        ? ref.watch(isRecipeSavedProvider(RecipeSaveParams(userId: int.parse(currentUserId.toString()), recipeId: recipe.id)))
        : const AsyncValue.data(false);

    // ✅ USAR FUNÇÃO HELPER PARA IMAGEM
    final imageProvider = _getRecipeImageProvider(recipe);

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
      // ✅ MENU DE OPÇÕES (APENAS PARA O AUTOR)
      actions: [
        isSavedAsync.when(
          data: (isSaved) => Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSaved ? Color(0xFFFA9500) : Color(0xFF3C4D18),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                if (!isSaved) {
                  _showBookmarkModal(recipe.id);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Receita já está salva!'),
                      backgroundColor: Color(0xFFFA9500),
                    ),
                  );
                }
              },
            ),
          ),
          loading: () => Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF3C4D18),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.bookmark_border, color: Colors.white, size: 20),
              onPressed: null,
            ),
          ),
          error: (_, __) => Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF3C4D18),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.bookmark_border, color: Colors.white, size: 20),
              onPressed: () => _showBookmarkModal(recipe.id),
            ),
          ),
        ),
        // ✅ MENU DE 3 PONTINHOS (APENAS PARA O AUTOR)
        if (isAuthor)
          PopupMenuButton<String>(
            icon: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.more_vert, color: Color(0xFF3C4D18)),
            ),
            onSelected: (value) {
              if (value == 'edit') {
                _editRecipe(recipe);
              } else if (value == 'delete') {
                _deleteRecipe(recipe);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFF7CB342), size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Editar',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Excluir',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
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

  // ✅ NOVO: Editar receita
  void _editRecipe(Recipe recipe) {
    context.push('/add-recipe', extra: {'recipe': recipe});
  }

  // ✅ NOVO: Excluir receita
  Future<void> _deleteRecipe(Recipe recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text(
              'Excluir Receita',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF3C4D18),
              ),
            ),
          ],
        ),
        content: Text(
          'Tem certeza que deseja excluir "${recipe.title}"?\n\nEsta ação não pode ser desfeita.',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Excluir',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final currentUserId = ref.read(currentUserDataProvider)?['id'];
        if (currentUserId == null) throw Exception('Usuário não autenticado');

        await ref.read(recipesProvider.notifier).deleteRecipe(
          recipe.id,
          int.parse(currentUserId.toString()),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Receita excluída com sucesso!'),
              backgroundColor: Color(0xFF7CB342),
            ),
          );
          context.go('/home'); // Redirecionar para home
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Erro ao excluir receita: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildRecipeHeader(Recipe recipe) {
    // ✅ BUSCAR DADOS ATUALIZADOS DO AUTOR
    final authorDataAsync = ref.watch(userProfileProvider(recipe.userId));

    return Padding(
      padding: EdgeInsets.all(20),
      child: authorDataAsync.when(
        data: (authorData) {
          print('👤 Dados do autor ${recipe.userId}: ${authorData.keys}');
          print('📸 profileImage: ${authorData['profileImage']}');
          print('📸 profileImageBytes: ${authorData['profileImageBytes'] != null ? 'HAS BYTES' : 'NO BYTES'}');

          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.push('/profile/${recipe.userId}');
                },
                child: Hero(
                  tag: 'author_${recipe.userId}',
                  // ✅ USAR ProfileImageWidget COM DADOS ATUALIZADOS
                  child: ProfileImageWidget(
                    userData: authorData,
                    radius: 20,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorData['name'] ?? 'Chef Saborê',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
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
                      '${recipe.averageRating?.toStringAsFixed(1) ?? '0.0'}',
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
          );
        },
        loading: () => Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFF5F5F5),
              child: Icon(Icons.person, size: 16, color: Color(0xFFFA9500)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        error: (_, __) => Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/chef.jpg'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.userName ?? 'Chef Saborê',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeInfo(Recipe recipe) {
    String category = recipe.category ?? 'Geral';
    String? state;

    if (category.contains(' - ')) {
      var parts = category.split(' - ');
      category = parts[0];
      state = parts[1];
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3E0),
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
          if (state != null)
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

  Widget _buildIngredientsSection(Recipe recipe) {
    final displayIngredients = showFullIngredients
        ? recipe.ingredients
        : recipe.ingredients.take(3).toList();

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
              color: Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Color(0xFFFA9500), size: 20),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    ingredient,
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
          ...recipe.steps.asMap().entries.map((entry) {
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
          GestureDetector(
            onTap: () {
              context.push(
                '/recipe/${recipe.id}/comments',
                extra: {
                  'recipeTitle': recipe.title,
                  'recipeAuthorId': recipe.userId,
                },
              );
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFFA9500).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFFFA9500),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ver todos os comentários',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFF3C4D18),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${recipe.commentsCount ?? 0} comentários',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFFA9500),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookmarkModal(int recipeId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SelectRecipeBookModal(recipeId: recipeId),
    ).then((selectedBook) {
      if (selectedBook != null) {
        setState(() {
          isBookmarked = true;
        });

        final currentUserId = ref.read(currentUserDataProvider)?['id'] as int?;
        if (currentUserId != null) {
          ref.invalidate(isRecipeSavedProvider(RecipeSaveParams(userId: currentUserId, recipeId: recipeId)));
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Receita salva em "${selectedBook['title']}"!'),
              backgroundColor: Color(0xFF7CB342),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    });
  }

  void _showRatingDialog(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Avaliar Receita'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Como você avalia esta receita?'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _userRating ? Icons.star : Icons.star_border,
                    color: Color(0xFFFA9500),
                  ),
                  onPressed: () {
                    setState(() {
                      _userRating = (index + 1).toDouble();
                    });
                  },
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Avaliação salva: $_userRating estrelas'),
                  backgroundColor: Color(0xFF7CB342),
                ),
              );
            },
            child: Text('Avaliar'),
          ),
        ],
      ),
    );
  }
}