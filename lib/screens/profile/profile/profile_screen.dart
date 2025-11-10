import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sabore_app/models/models.dart';
import 'package:sabore_app/providers/recipe_provider.dart';
import 'package:sabore_app/providers/auth_provider.dart';
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

  // Mocks para abas não implementadas
  final List<String> _mockGalleryImages = [
    'assets/images/chef.jpg',
    'assets/images/chef.jpg',
    'assets/images/chef.jpg',
    'assets/images/chef.jpg',
  ];
  final List<Map<String, dynamic>> _mockReviews = [
    {
      'authorName': 'Carlos Souza',
      'authorImage': 'assets/images/chef.jpg',
      'rating': 5.0,
      'comment': 'Absolutamente incrível!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Converte o ID da rota (String) para int
    final int userIdAsInt = int.tryParse(widget.userId) ?? 0;

    // Busca o perfil do usuário (seu ou de outro)
    final profileDataAsync = ref.watch(userProfileProvider(userIdAsInt));
    // Pega o ID do usuário logado para comparar
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
                child: _buildStatsSection(profileData, isOwnProfile),
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
            BoxShadow( color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 2), ),
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
      // Fallback se os dados estiverem malformados
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

  Widget _buildStatsSection(Map<String, dynamic> userData, bool isOwnProfile) {
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

          if (!isOwnProfile)
            _buildFollowButtonWide(context)
          else
            _buildEditProfileButton(context),

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
                _buildStatColumn(userData['followersCount'].toString(), 'Seguidores'),
                Container(height: 40, width: 1, color: Color(0xFFE0E0E0)),
                _buildStatColumn(userData['followingCount'].toString(), 'Seguindo'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context.push('/edit-profile'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFA9500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          'Editar Perfil',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFollowButtonWide(BuildContext context) {
    bool isFollowing = false; // TODO: Lógica real de seguir
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () { /* TODO: Lógica de seguir */ },
        style: ElevatedButton.styleFrom(
          backgroundColor: isFollowing ? Colors.white : Color(0xFF7CB342),
          foregroundColor: isFollowing ? Color(0xFF7CB342) : Colors.white,
          side: isFollowing ? BorderSide(color: Color(0xFF7CB342), width: 2) : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          isFollowing ? 'Seguindo' : 'Seguir',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 16),
        ),
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
        return _buildGalleryGrid();

      case 'Avaliações':
        return _buildReviewsList();

      case 'Salvos':
        if (!isOwnProfile) return SliverToBoxAdapter();

        // TODO: Substituir por um provider real de receitas salvas
        return _buildEmptyStateSliver(
          icon: Icons.bookmark_border,
          title: 'Nenhuma receita salva',
          subtitle: 'Suas receitas favoritas aparecerão aqui.',
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
            ),
          );
        },
        childCount: recipes.length,
      ),
    );
  }

  Widget _buildGalleryGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(_mockGalleryImages[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        childCount: _mockGalleryImages.length,
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
                    i < (review['rating'] as double).floor()
                        ? Icons.star
                        : Icons.star_border,
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

  Widget _buildRecipeCard(
      String title,
      String time,
      String ingredients,
      String author,
      double rating,
      String imagePath,
      int recipeId, { // Mudado para int
        bool isPopular = false,
      }) {
    ImageProvider imageProvider;
    if (imagePath.startsWith('assets/')) {
      imageProvider = AssetImage(imagePath);
    } else {
      imageProvider = FileImage(File(imagePath));
    }

    return GestureDetector(
      onTap: () {
        print('🍳 Recipe tapped: $title');
        context.push('/recipe/$recipeId'); // Envia o int como string
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
              child: _buildBookmarkButton(title),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkButton(String title) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SelectRecipeBookModal(),
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
        child: Icon(
          Icons.bookmark_border,
          color: Color(0xFFFA9500),
          size: 20,
        ),
      ),
    );
  }
}