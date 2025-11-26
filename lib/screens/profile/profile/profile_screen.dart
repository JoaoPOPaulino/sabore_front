import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sabore_app/models/models.dart';
import 'package:sabore_app/providers/recipe_provider.dart';
import 'package:sabore_app/providers/auth_provider.dart';
import 'package:sabore_app/providers/recipe_book_provider.dart';
import 'package:sabore_app/widgets/profile_image_widget.dart';
import 'package:sabore_app/widgets/select_recipe_book_modal.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String selectedTab = 'Receitas';
  bool _isFollowLoading = false;

  final List<Map<String, dynamic>> _mockReviews = [
    {
      'authorName': 'Carlos Souza',
      'authorImage': 'assets/images/chef.jpg',
      'rating': 5.0,
      'comment': 'Absolutamente incrível!',
    },
  ];

  // ✅ FUNÇÃO HELPER PARA CRIAR ImageProvider CORRETO
  ImageProvider _getRecipeImageProvider(Recipe recipe) {
    // Verificar se tem bytes (WEB)
    if (recipe.imageBytes != null) {
      return MemoryImage(recipe.imageBytes!);
    }

    // Verificar se tem imagem
    if (recipe.image == null || recipe.image!.isEmpty) {
      return AssetImage('assets/images/chef.jpg');
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

  @override
  Widget build(BuildContext context) {
    final int userIdAsInt = int.tryParse(widget.userId) ?? 0;
    final profileDataAsync = ref.watch(userProfileProvider(userIdAsInt));
    final currentUserId = (ref.watch(currentUserDataProvider))?['id'];
    final bool isOwnProfile = userIdAsInt == currentUserId;

    return profileDataAsync.when(
      data: (profileData) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeaderWithProfile(profileData, isOwnProfile),
              ),
              SliverToBoxAdapter(
                child: _buildStatsSection(profileData, isOwnProfile, userIdAsInt),
              ),
              SliverToBoxAdapter(
                child: _buildTabButtons(isOwnProfile),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: _buildTabContent(isOwnProfile, userIdAsInt),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFA9500)),
        ),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Icon(Icons.arrow_back, color: Color(0xFF3C4D18)),
          ),
          title: Text('Erro', style: TextStyle(color: Color(0xFF3C4D18))),
        ),
        body: Center(child: Text('Erro ao carregar perfil: $err')),
      ),
    );
  }

  Widget _buildHeaderWithProfile(Map<String, dynamic> userData, bool isOwnProfile) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          child: _buildCoverImage(userData),
        ),
        Positioned(
          top: 50,
          left: 16,
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF7CB342),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: isOwnProfile ? 70 : 16,
          child: _buildShareButton(context, widget.userId, userData['username']),
        ),
        if (isOwnProfile)
          Positioned(
            top: 50,
            right: 16,
            child: _buildSettingsButton(context),
          ),
        Positioned(
          bottom: -60,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Hero(
              tag: 'profile_image_${widget.userId}',
              child: ProfileImageWidget(userData: userData, radius: 60),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context, String userId, String? username) {
    return GestureDetector(
      onTap: () {
        final textToShare = 'Confira este chef incrível no Saborê! @${username ?? ''} \nhttps://sabore.app/profile/$userId';
        Share.share(textToShare);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.share,
          color: Color(0xFF3C4D18),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/settings'),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFFA9500),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.settings,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCoverImage(Map<String, dynamic> userData) {
    final hasCoverImage = (kIsWeb && userData['coverImageBytes'] != null) ||
        (!kIsWeb && userData['coverImage'] != null);

    final webBytes = userData['coverImageBytes'];
    final mobilePath = userData['coverImage'];

    if (!hasCoverImage) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFA9500).withOpacity(0.3),
              Color(0xFF7CB342).withOpacity(0.3),
            ],
          ),
        ),
      );
    }

    ImageProvider? imageProvider;
    if (kIsWeb && webBytes is Uint8List) {
      imageProvider = MemoryImage(webBytes);
    } else if (!kIsWeb && mobilePath is String && mobilePath.isNotEmpty) {
      if (mobilePath.startsWith('assets/')) {
        imageProvider = AssetImage(mobilePath);
      } else {
        imageProvider = FileImage(File(mobilePath));
      }
    } else {
      return Container(color: Color(0xFFFFF3E0));
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStatsSection(Map<String, dynamic> userData, bool isOwnProfile, int userIdAsInt) {
    final followersCountAsync = ref.watch(followersCountProvider(userIdAsInt));
    final followingCountAsync = ref.watch(followingCountProvider(userIdAsInt));
    final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;

    return Container(
      margin: EdgeInsets.fromLTRB(20, 80, 20, 0),
      child: Column(
        children: [
          Text(
            '@${userData['username'] ?? 'username'}',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Color(0xFFFA9500),
            ),
          ),
          SizedBox(height: 4),
          Text(
            userData['name'] ?? 'Usuário',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
          SizedBox(height: 20),

          if (!isOwnProfile) _buildFollowButton(context, userIdAsInt),

          SizedBox(height: 20),

          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFFFFF8F0),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(userData['recipesCount'].toString(), 'Receitas'),
                Container(height: 40, width: 1, color: Color(0xFFE0E0E0)),

                GestureDetector(
                  onTap: () {
                    context.push(
                      '/followers/${userIdAsInt}',
                      extra: {'userName': userData['name'] ?? 'Usuário'},
                    );
                  },
                  child: followersCountAsync.when(
                    data: (count) => _buildStatColumn(count.toString(), 'Seguidores'),
                    loading: () => _buildStatColumn('...', 'Seguidores'),
                    error: (_, __) => _buildStatColumn(userData['followersCount'].toString(), 'Seguidores'),
                  ),
                ),

                Container(height: 40, width: 1, color: Color(0xFFE0E0E0)),

                GestureDetector(
                  onTap: () {
                    context.push(
                      '/following/${userIdAsInt}',
                      extra: {'userName': userData['name'] ?? 'Usuário'},
                    );
                  },
                  child: isOwnProfile && currentUserId != null
                      ? ref.watch(followingCountProvider(currentUserId)).when(
                    data: (count) => _buildStatColumn(count.toString(), 'Seguindo'),
                    loading: () => _buildStatColumn('...', 'Seguindo'),
                    error: (_, __) => _buildStatColumn(userData['followingCount'].toString(), 'Seguindo'),
                  )
                      : followingCountAsync.when(
                    data: (count) => _buildStatColumn(count.toString(), 'Seguindo'),
                    loading: () => _buildStatColumn('...', 'Seguindo'),
                    error: (_, __) => _buildStatColumn(userData['followingCount'].toString(), 'Seguindo'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context, int userIdAsInt) {
    final isFollowing = ref.watch(followStateProvider(userIdAsInt));

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            child: ElevatedButton(
              onPressed: _isFollowLoading ? null : () => _handleFollowToggle(userIdAsInt),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFollowing ? Colors.white : Color(0xFF7CB342),
                foregroundColor: isFollowing ? Color(0xFF7CB342) : Colors.white,
                side: BorderSide(
                  color: Color(0xFF7CB342),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                elevation: isFollowing ? 0 : 4,
                shadowColor: Color(0xFF7CB342).withOpacity(0.3),
              ),
              child: _isFollowLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isFollowing ? Color(0xFF7CB342) : Colors.white,
                  ),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFollowing ? Icons.check_circle : Icons.person_add,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    isFollowing ? 'Seguindo' : 'Seguir',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 12),

        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFA9500), Color(0xFFFF6B35)],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFA9500).withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: _handleMessage,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleFollowToggle(int userIdToFollow) async {
    final authService = ref.read(authServiceProvider);
    final currentUserId = ref.read(currentUserDataProvider)?['id'] as int?;

    if (currentUserId == null) return;

    setState(() {
      _isFollowLoading = true;
    });

    try {
      final isNowFollowing = await authService.toggleFollow(userIdToFollow);

      ref.invalidate(followersProvider(userIdToFollow));
      ref.invalidate(followersCountProvider(userIdToFollow));
      ref.invalidate(followingProvider(currentUserId));
      ref.invalidate(followingCountProvider(currentUserId));
      ref.invalidate(followStateProvider(userIdToFollow));
      ref.invalidate(userProfileProvider(userIdToFollow));
      ref.invalidate(userProfileProvider(currentUserId));

      if (mounted) {
        setState(() {
          _isFollowLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  isNowFollowing ? Icons.check_circle : Icons.remove_circle_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isNowFollowing
                        ? 'Você começou a seguir este chef!'
                        : 'Você deixou de seguir este chef',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: isNowFollowing ? Color(0xFF7CB342) : Color(0xFF999999),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFollowLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao seguir/deixar de seguir'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleMessage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMessageModal(),
    );
  }

  Widget _buildMessageModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enviar Mensagem',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Color(0xFFFA9500),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Mensagens em Breve!',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3C4D18),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Estamos trabalhando nesta funcionalidade.\nEm breve você poderá conversar com outros chefs!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Color(0xFF999999),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFA9500),
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Entendi',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Color(0xFF3C4D18),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButtons(bool isOwnProfile) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Expanded(child: _buildTabButton('Receitas')),
          SizedBox(width: 8),
          Expanded(child: _buildTabButton('Galeria')),
          SizedBox(width: 8),
          if (isOwnProfile) ...[
            Expanded(child: _buildTabButton('Salvos')),
          ] else ...[
            Expanded(child: _buildTabButton('Avaliações')),
          ]
        ],
      ),
    );
  }

  Widget _buildTabButton(String title) {
    bool isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = title),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFA9500) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Color(0xFFFA9500) : Color(0xFFE0E0E0),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Color(0xFFFA9500).withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? Colors.white : Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(bool isOwnProfile, int userId) {
    switch (selectedTab) {
      case 'Receitas':
        final userRecipes = ref.watch(userRecipesProvider(userId));
        return userRecipes.when(
          data: (recipes) {
            if (recipes.isEmpty) {
              return _buildEmptyStateSliver(
                icon: Icons.restaurant_menu,
                title: 'Nenhuma receita ainda',
                subtitle: isOwnProfile ? 'Compartilhe suas receitas favoritas!' : 'Este usuário ainda não postou receitas.',
                buttonText: isOwnProfile ? 'Adicionar Receita' : null,
                onPressed: isOwnProfile ? () => context.push('/add-recipe') : null,
              );
            }
            return _buildRecipesList(recipes);
          },
          loading: () => SliverToBoxAdapter(
            child: Container(
              height: 200,
              child: Center(child: CircularProgressIndicator(color: Color(0xFFFA9500))),
            ),
          ),
          error: (err, stack) => SliverToBoxAdapter(
            child: Container(
              height: 200,
              padding: EdgeInsets.all(20),
              child: Center(child: Text('Erro ao carregar receitas: ${err.toString()}', textAlign: TextAlign.center)),
            ),
          ),
        );
      case 'Galeria':
        final userRecipes = ref.watch(userRecipesProvider(userId));
        return userRecipes.when(
          data: (recipes) {
            final recipesWithImages = recipes.where((r) => r.image != null && r.image!.isNotEmpty).toList();

            if (recipesWithImages.isEmpty) {
              return _buildEmptyStateSliver(
                icon: Icons.photo_library_outlined,
                title: 'Nenhuma foto ainda',
                subtitle: isOwnProfile
                    ? 'As fotos das suas receitas aparecerão aqui.'
                    : 'Este usuário ainda não postou fotos.',
              );
            }

            return _buildGalleryGrid(recipesWithImages);
          },
          loading: () => SliverToBoxAdapter(
            child: Container(
              height: 200,
              child: Center(child: CircularProgressIndicator(color: Color(0xFFFA9500))),
            ),
          ),
          error: (err, stack) => _buildEmptyStateSliver(
            icon: Icons.error_outline,
            title: 'Erro ao carregar',
            subtitle: 'Não foi possível carregar a galeria.',
          ),
        );
      case 'Avaliações':
        return _buildReviewsList();
      case 'Salvos':
        if (!isOwnProfile) return SliverToBoxAdapter();

        final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;
        if (currentUserId == null) {
          return _buildEmptyStateSliver(
            icon: Icons.bookmark_border,
            title: 'Erro',
            subtitle: 'Não foi possível carregar receitas salvas.',
          );
        }

        final savedRecipesAsync = ref.watch(savedRecipesProvider(currentUserId));

        return savedRecipesAsync.when(
          data: (recipes) {
            if (recipes.isEmpty) {
              return _buildEmptyStateSliver(
                icon: Icons.bookmark_border,
                title: 'Nenhuma receita salva',
                subtitle: 'Suas receitas favoritas aparecerão aqui.',
              );
            }
            return _buildRecipesList(recipes);
          },
          loading: () => SliverToBoxAdapter(
            child: Container(
              height: 200,
              child: Center(child: CircularProgressIndicator(color: Color(0xFFFA9500))),
            ),
          ),
          error: (err, stack) => _buildEmptyStateSliver(
            icon: Icons.error_outline,
            title: 'Erro ao carregar',
            subtitle: 'Não foi possível carregar as receitas salvas.',
          ),
        );
      default:
        return SliverToBoxAdapter(child: SizedBox.shrink());
    }
  }

  Widget _buildRecipesList(List<Recipe> recipes) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final recipe = recipes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildRecipeCard(
              recipe.title,
              '${recipe.preparationTime} min',
              '${recipe.ingredients.length} ingredientes',
              recipe.userName ?? 'Chef Saborê',
              recipe.averageRating ?? 0.0,
              recipe.image ?? 'assets/images/chef.jpg',
              recipe.id,
              isPopular: recipe.likesCount > 10,
              recipe: recipe, // ✅ PASSAR O OBJETO RECIPE
            ),
          );
        },
        childCount: recipes.length,
      ),
    );
  }

  // ✅ GALERIA CORRIGIDA PARA WEB
  Widget _buildGalleryGrid(List<Recipe> recipes) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final recipe = recipes[index];

          // ✅ USAR FUNÇÃO HELPER
          final imageProvider = _getRecipeImageProvider(recipe);

          return GestureDetector(
            onTap: () {
              print('🖼️ Galeria - Receita clicada: ${recipe.title}');
              context.push('/recipe/${recipe.id}');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    if (recipe.likesCount > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 10,
                              ),
                              SizedBox(width: 3),
                              Text(
                                '${recipe.likesCount}',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: recipes.length,
      ),
    );
  }

  Widget _buildReviewsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return _buildReviewCard(_mockReviews[index]);
        },
        childCount: _mockReviews.length,
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(review['authorImage']),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  review['authorName'],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF3C4D18),
                  ),
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < (review['rating'] as double).floor() ? Icons.star : Icons.star_border,
                    color: Color(0xFFFA9500),
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            review['comment'],
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateSliver({
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 60, color: Color(0xFFE0E0E0)),
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
            if (buttonText != null && onPressed != null) ...[
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFA9500),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ✅ RECIPE CARD CORRIGIDO PARA WEB
  Widget _buildRecipeCard(
      String title,
      String time,
      String ingredients,
      String author,
      double rating,
      String imagePath,
      int recipeId, {
        bool isPopular = false,
        Recipe? recipe, // ✅ ADICIONAR PARÂMETRO recipe
      }) {

    ImageProvider imageProvider;

    // ✅ SE TEM RECIPE, USAR FUNÇÃO HELPER
    if (recipe != null) {
      imageProvider = _getRecipeImageProvider(recipe);
    } else {
      // Fallback antigo
      if (imagePath.startsWith('assets/')) {
        imageProvider = AssetImage(imagePath);
      } else if (kIsWeb) {
        imageProvider = AssetImage('assets/images/chef.jpg');
      } else {
        imageProvider = FileImage(File(imagePath));
      }
    }

    return GestureDetector(
      onTap: () {
        print('🍳 Recipe tapped: $title');
        context.push('/recipe/$recipeId');
      },
      child: Container(
        height: 140,
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
            Container(
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF3C4D18),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_outline, color: Color(0xFF999999), size: 14),
                        SizedBox(width: 4),
                        Text(
                          author,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFA9500), size: 16),
                        SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF3C4D18),
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.access_time, color: Color(0xFF999999), size: 14),
                        SizedBox(width: 4),
                        Text(
                          time,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: _buildBookmarkButton(title, recipeId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkButton(String title, int recipeId) {
    final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;

    if (currentUserId == null) {
      return Container();
    }

    final isSavedAsync = ref.watch(
      isRecipeSavedProvider(RecipeSaveParams(userId: currentUserId, recipeId: recipeId)),
    );

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SelectRecipeBookModal(recipeId: recipeId),
        ).then((selectedBook) {
          if (selectedBook != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Receita salva em "${selectedBook['title']}"!'),
                backgroundColor: Color(0xFF7CB342),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFFFF3E0),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: isSavedAsync.when(
          data: (isSaved) => Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: Color(0xFFFA9500),
            size: 20,
          ),
          loading: () => Icon(
            Icons.bookmark_border,
            color: Color(0xFFFA9500),
            size: 20,
          ),
          error: (_, __) => Icon(
            Icons.bookmark_border,
            color: Color(0xFFFA9500),
            size: 20,
          ),
        ),
      ),
    );
  }
}