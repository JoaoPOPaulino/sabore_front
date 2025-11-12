import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../providers/auth_provider.dart';
import '../../providers/recipe_book_provider.dart';
import '../../widgets/select_recipe_book_modal.dart';
import '../../widgets/profile_image_widget.dart';
import '../../widgets/phone_verification_banner.dart';
import '../../providers/notification_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(currentUserDataProvider);
    final firstName = userData?['name']?.toString().split(' ').first ?? 'Chef';

    if (userData != null) {
      print('🏠 HOME userData: ${userData.keys}');
      print('🖼️ profileImage: ${userData['profileImage']}');
      print('📸 profileImageBytes: ${userData['profileImageBytes'] != null ? 'HAS BYTES' : 'NO BYTES'}');
    }

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Container(
            height: 300,
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

          FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(userData, firstName),
                  SizedBox(height: 20),
                  PhoneVerificationBanner(),
                  SizedBox(height: 24),
                  _buildSearchBar(),
                  SizedBox(height: 24),
                  _buildCategoriesSection(),
                  SizedBox(height: 32),
                  _buildFeaturedRecipe(),
                  SizedBox(height: 32),
                  InfiniteStatesCarousel(),
                  SizedBox(height: 32),
                  _buildPopularRecipesSection(),
                  SizedBox(height: 32),
                  _buildNewRecipesSection(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          _buildBottomNavigationBar(userData),
        ],
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic>? userData, String firstName) {
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            print('👤 Profile button pressed');
            context.push('/profile/${userData?['id'] ?? '1'}');
          },
          child: Hero(
            tag: 'profile_image',
            child: ProfileImageWidget(userData: userData, radius: 28),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                firstName,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  color: Color(0xFF3C4D18),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.notifications_outlined, color: Color(0xFFFA9500)),
                onPressed: () {
                  print('🔔 Notifications pressed');
                  context.push('/notifications');
                },
              ),
            ),
            // Badge de notificações não lidas
            unreadCountAsync.when(
              data: (count) {
                if (count == 0) return SizedBox.shrink();

                return Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Center(
                      child: Text(
                        count > 99 ? '99+' : count.toString(),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => SizedBox.shrink(),
              error: (_, __) => SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        print('🔍 Search bar tapped');
        context.push('/search');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Color(0xFF999999), size: 22),
            SizedBox(width: 12),
            Text(
              'O que você quer cozinhar hoje?',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: Color(0xFF999999),
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFFFA9500),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.tune, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'name': 'Juninas', 'icon': '🎉', 'color': Color(0xFFFA9500)},
      {'name': 'Doces', 'icon': '🍰', 'color': Color(0xFFE91E63)},
      {'name': 'Salgados', 'icon': '🥐', 'color': Color(0xFF7CB342)},
      {'name': 'Bebidas', 'icon': '🧃', 'color': Color(0xFF00BCD4)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorias',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF3C4D18),
          ),
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return Container(
                margin: EdgeInsets.only(right: 12),
                child: _buildCategoryChip(
                  category['name'] as String,
                  category['icon'] as String,
                  category['color'] as Color,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String name, String icon, Color color) {
    return GestureDetector(
      onTap: () {
        print('🏷️ Category tapped: $name');
        context.push('/categories');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              icon,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedRecipe() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receita do Dia',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Especial de hoje',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFFA9500),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Destaque',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            print('🍰 Featured recipe tapped');
            context.push('/recipe/2');
          },
          child: Hero(
            tag: 'featured_recipe',
            child: Container(
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/chef.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF7CB342),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'NOVO',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Canjica zero lactose',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              _buildRecipeInfo(Icons.access_time, '1h20min'),
                              SizedBox(width: 16),
                              _buildRecipeInfo(Icons.restaurant, '9 itens'),
                              SizedBox(width: 16),
                              _buildRecipeInfo(Icons.star, '4.8'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: _buildBookmarkButton('Canjica zero lactose', 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularRecipesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Receitas Populares',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color(0xFF3C4D18),
              ),
            ),
            TextButton(
              onPressed: () {
                print('🔝 Ver tudo - Popular');
                context.push('/categories');
              },
              child: Row(
                children: [
                  Text(
                    'Ver tudo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFFFA9500),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFA9500)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildRecipeCard(
          'Bolo de milho sem açúcar',
          '1h20min',
          '9 ingredientes',
          'Chef Ana',
          4.8,
          'assets/images/chef.jpg',
          1,
          isPopular: true,
        ),
        SizedBox(height: 12),
        _buildRecipeCard(
          'Brownie de chocolate',
          '45min',
          '8 ingredientes',
          'Chef Carlos',
          4.9,
          'assets/images/chef.jpg',
          3,
          isPopular: true,
        ),
      ],
    );
  }

  Widget _buildNewRecipesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Novas Receitas',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF3C4D18),
          ),
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSmallRecipeCard('Pizza Margherita', 'assets/images/chef.jpg', 4),
              _buildSmallRecipeCard('Tapioca Recheada', 'assets/images/chef.jpg', 5),
              _buildSmallRecipeCard('Pão de Queijo', 'assets/images/chef.jpg', 6),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard(
      String title,
      String time,
      String ingredients,
      String author,
      double rating,
      String imagePath,
      int recipeId, {
        bool isPopular = false,
      }) {
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
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  if (isPopular)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFFA9500),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.trending_up, color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Popular',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
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
                          rating.toString(),
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

  Widget _buildSmallRecipeCard(String title, String imagePath, int recipeId) {
    return GestureDetector(
      onTap: () {
        print('🍳 Small recipe tapped: $title');
        context.push('/recipe/$recipeId');
      },
      child: Container(
        width: 160,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF7CB342),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'NOVO',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkButton(String title, int recipeId) {
    return Consumer(
      builder: (context, ref, child) {
        final currentUserId = ref.watch(currentUserDataProvider)?['id'] as int?;

        if (currentUserId == null) {
          return Container();
        }

        final isSavedAsync = ref.watch(
          isRecipeSavedProvider(RecipeSaveParams(userId: currentUserId, recipeId: recipeId)),
        );

        return GestureDetector(
          onTap: () {
            print('🔖 Bookmark tapped: $title');
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
      },
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
            _buildNavItem(Icons.home, true, () {
              print('🏠 Home - already here');
            }),
            _buildNavItem(Icons.search, false, () {
              print('🔍 Search');
              context.go('/search');
            }),
            _buildNavItemFAB(Icons.add, () {
              context.push('/add-recipe');
            }),
            _buildNavItem(Icons.notifications_outlined, false, () {
              print('🔔 Notifications');
              context.push('/notifications');
            }),
            _buildNavItem(Icons.person_outline, false, () {
              print('👤 Profile');
              context.push('/profile/${userData?['id'] ?? '1'}');
            }),
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

class InfiniteStatesCarousel extends StatefulWidget {
  const InfiniteStatesCarousel({Key? key}) : super(key: key);

  @override
  State<InfiniteStatesCarousel> createState() => _InfiniteStatesCarouselState();
}

class _InfiniteStatesCarouselState extends State<InfiniteStatesCarousel> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  final List<Map<String, String>> states = [
    {'name': 'Tocantins', 'recipes': '50 receitas', 'emoji': '🌾'},
    {'name': 'São Paulo', 'recipes': '120 receitas', 'emoji': '🏙️'},
    {'name': 'Paraná', 'recipes': '65 receitas', 'emoji': '🌲'},
    {'name': 'Rio de Janeiro', 'recipes': '95 receitas', 'emoji': '🏖️'},
    {'name': 'Maranhão', 'recipes': '30 receitas', 'emoji': '🦐'},
    {'name': 'Goiás', 'recipes': '70 receitas', 'emoji': '🌽'},
    {'name': 'Minas Gerais', 'recipes': '85 receitas', 'emoji': '🧀'},
    {'name': 'Bahia', 'recipes': '75 receitas', 'emoji': '🥥'},
    {'name': 'Pernambuco', 'recipes': '60 receitas', 'emoji': '🦞'},
    {'name': 'Ceará', 'recipes': '55 receitas', 'emoji': '🦀'},
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: states.length * 1000,
      viewportFraction: 0.4,
    );

    _currentPage = states.length * 1000;

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estados Brasileiros',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Explore receitas típicas',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                print('🗺️ Ver todos estados');
                context.push('/states');
              },
              child: Row(
                children: [
                  Text(
                    'Ver tudo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFFFA9500),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFFA9500)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        Container(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final stateIndex = index % states.length;
              final state = states[stateIndex];
              final isCenter = (index - _currentPage).abs() == 0;

              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: isCenter ? 0 : 10,
                ),
                child: GestureDetector(
                  onTap: () {
                    _timer.cancel();
                    print('🗺️ State tapped: ${state['name']}');
                    context.push('/states');

                    Timer(Duration(seconds: 5), () {
                      if (mounted) {
                        _timer = Timer.periodic(Duration(seconds: 3), (timer) {
                          if (mounted) {
                            _currentPage++;
                            _pageController.animateToPage(
                              _currentPage,
                              duration: Duration(milliseconds: 600),
                              curve: Curves.easeInOutCubic,
                            );
                          }
                        });
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isCenter ? 0.15 : 0.08),
                          blurRadius: isCenter ? 15 : 8,
                          offset: Offset(0, isCenter ? 8 : 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/chef.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          if (isCenter)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFA9500),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.white, size: 10),
                                    SizedBox(width: 4),
                                    Text(
                                      'Popular',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state['emoji']!,
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  state['name']!,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.restaurant_menu,
                                      color: Colors.white70,
                                      size: 12,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      state['recipes']!,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
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
            },
          ),
        ),

        SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(states.length, (index) {
            final isActive = (_currentPage % states.length) == index;
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: isActive ? 24 : 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isActive ? Color(0xFFFA9500) : Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(4),
                boxShadow: isActive
                    ? [
                  BoxShadow(
                    color: Color(0xFFFA9500).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
                    : [],
              ),
            );
          }),
        ),
      ],
    );
  }
}