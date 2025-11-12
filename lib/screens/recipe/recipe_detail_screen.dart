import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sabore_app/models/models.dart';
import 'package:sabore_app/providers/recipe_provider.dart';
import 'package:sabore_app/providers/auth_provider.dart';
import 'package:sabore_app/services/mock_notification_service.dart';
import '../../widgets/select_recipe_book_modal.dart';
import '../../providers/recipe_book_provider.dart';

// Alias para facilitar o uso
final recipeDetailProvider = recipeByIdProvider;

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

    // 🔔 CRIAR NOTIFICAÇÃO DE COMENTÁRIO
    try {
      final recipeId = int.parse(widget.recipeId);
      final recipe = await ref.read(recipeByIdProvider(recipeId).future);

      if (recipe.userId != currentUser['id']) {
        final notificationService = MockNotificationService();
        notificationService.createCommentNotification(
          targetUserId: recipe.userId,
          fromUserId: currentUser['id'] as int,
          fromUserName: currentUser['name'],
          fromUserImage: currentUser['profileImage'],
          recipeId: recipe.id,
          recipeName: recipe.title,
          commentText: newComment['comment'],
        );
      }
    } catch (e) {
      print('❌ Erro ao criar notificação: $e');
    }

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
    final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;

    // Verificar se a receita está salva
    final isSavedAsync = currentUserId != null
        ? ref.watch(isRecipeSavedProvider(RecipeSaveParams(
      userId: currentUserId,
      recipeId: recipe.id,
    )))
        : AsyncValue.data(false);

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
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF7CB342),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.star, color: Colors.white, size: 20),
            onPressed: () {
              _showRatingDialog(recipe);
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: recipe.image != null && recipe.image!.startsWith('http')
                  ? NetworkImage(recipe.image!)
                  : AssetImage(recipe.image ?? 'assets/images/chef.jpg') as ImageProvider,
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

  Widget _buildRecipeHeader(Recipe recipe) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.push('/profile/${recipe.userId}');
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: recipe.userImage != null && recipe.userImage!.startsWith('http')
                  ? NetworkImage(recipe.userImage!)
                  : AssetImage('assets/images/chef.jpg') as ImageProvider,
            ),
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
    // Converter List<Ingredient> para List<String>
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tela de comentários em breve!')),
              );
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
                    'Ver ${recipe.commentsCount ?? 0} comentários',
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

        // Invalidar provider para atualizar UI
        final currentUserId = ref.read(currentUserDataProvider)?['id'] as int?;
        if (currentUserId != null) {
          ref.invalidate(isRecipeSavedProvider(RecipeSaveParams(
            userId: currentUserId,
            recipeId: recipeId,
          )));
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