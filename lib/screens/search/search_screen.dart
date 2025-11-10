import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sabore_app/providers/auth_provider.dart';
import 'package:sabore_app/widgets/profile_image_widget.dart';
// TODO: Importar seu recipe_provider.dart
// import 'package:sabore_app/providers/recipe_provider.dart';

enum _SearchMode { recipes, users }

class SearchScreen extends ConsumerStatefulWidget {
  static const String route = '/search';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  _SearchMode _searchMode = _SearchMode.recipes;
  String _searchQuery = '';
  String _debouncedQuery = '';
  Timer? _debounce;

  List<String> recentSearches = [];
  String selectedFilter = 'Todos';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> filters = [
    'Todos', 'Doces', 'Salgados', 'Bebidas', 'Sem Lactose', 'Sem Glúten', 'Vegano',
  ];

  final List<Map<String, dynamic>> popularCategories = [
    {'name': 'Bolos', 'icon': '🎂', 'color': Color(0xFFFA9500)},
    {'name': 'Tortas', 'icon': '🥧', 'color': Color(0xFFE91E63)},
    {'name': 'Sobremesas', 'icon': '🍰', 'color': Color(0xFF9C27B0)},
    {'name': 'Salgados', 'icon': '🥐', 'color': Color(0xFF7CB342)},
  ];

  // MOCK DE RECEITAS
  final List<Map<String, dynamic>> allRecipes = [
    { 'id': '1', 'name': 'Bolo de milho sem açúcar', 'time': '1h20min', 'ingredients': 9, 'rating': 4.8, 'author': 'Chef Ana', 'category': 'Doces', 'image': 'assets/images/chef.jpg', 'difficulty': 'Fácil', 'calories': 250, },
    { 'id': '2', 'name': 'Brownie sem lactose', 'time': '45min', 'ingredients': 11, 'rating': 4.9, 'author': 'Chef Carlos', 'category': 'Doces', 'image': 'assets/images/chef.jpg', 'difficulty': 'Médio', 'calories': 320, },
    { 'id': '3', 'name': 'Pizza Margherita', 'time': '30min', 'ingredients': 8, 'rating': 4.7, 'author': 'Chef Maria', 'category': 'Salgados', 'image': 'assets/images/chef.jpg', 'difficulty': 'Fácil', 'calories': 280, },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    _loadRecentSearches();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _searchQuery = query;
      _searchMode = query.startsWith('@') ? _SearchMode.users : _SearchMode.recipes;
    });
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _debouncedQuery = query;
        });
      }
    });
  }

  void _loadRecentSearches() {
    setState(() {
      recentSearches = ['Bolo', '@chefana', 'Pizza', 'Suco'];
    });
  }

  void _saveRecentSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      recentSearches.remove(query);
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches = recentSearches.sublist(0, 10);
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            if (_searchQuery.isNotEmpty && _searchMode == _SearchMode.recipes)
              _buildQuickFilters(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildSearchBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    bool isUserSearch = _searchMode == _SearchMode.users;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Color(0xFFFA9500),
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(
                      isUserSearch ? Icons.person_outline : Icons.search,
                      color: Color(0xFFFA9500),
                      size: 20
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      autofocus: true,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Color(0xFF3C4D18),
                      ),
                      decoration: InputDecoration(
                        hintText: isUserSearch ? 'Buscar usuários...' : 'Buscar receitas...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFF999999),
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      onSubmitted: (value) {
                        _saveRecentSearch(value);
                        setState(() { _debouncedQuery = value; });
                      },
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: () => _searchController.clear(),
                      child: Icon(
                        Icons.close,
                        color: Color(0xFF999999),
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: _showAdvancedFilters,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFA9500), Color(0xFFFF6B35)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFA9500).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.tune,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFFA9500) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Color(0xFFFA9500) : Color(0xFFE0E0E0),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Color(0xFFFA9500).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
                    : [],
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Color(0xFF666666),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBody() {
    if (_searchQuery.isEmpty) {
      return _buildEmptyState();
    }

    if (_searchMode == _SearchMode.users) {
      final userQuery = _debouncedQuery.startsWith('@')
          ? _debouncedQuery.substring(1)
          : _debouncedQuery;

      final usersAsync = ref.watch(searchUsersProvider(userQuery));

      return usersAsync.when(
        data: (users) {
          if (users.isEmpty && userQuery.isNotEmpty) return _buildNoResults();
          return _buildUserResults(users);
        },
        loading: () => _buildLoadingIndicator(),
        error: (err, stack) => Center(child: Text('Erro: $err')),
      );
    }

    // TODO: Substitua pelo seu provider de receitas
    final recipeResults = allRecipes.where((recipe) {
      final query = _debouncedQuery.toLowerCase();
      final matchesQuery =
          recipe['name'].toLowerCase().contains(query) ||
              (recipe['category'] as String).toLowerCase().contains(query);
      final matchesFilter = selectedFilter == 'Todos' ||
          recipe['category'] == selectedFilter;
      return matchesQuery && matchesFilter;
    }).toList();

    if (recipeResults.isEmpty && _debouncedQuery.isNotEmpty) return _buildNoResults();
    return _buildRecipeResults(recipeResults);
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFFA9500)),
          SizedBox(height: 16),
          Text(
            _searchMode == _SearchMode.recipes
                ? 'Buscando receitas...'
                : 'Buscando usuários...',
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

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recentSearches.isNotEmpty) ...[
            _buildSectionTitle('Buscas Recentes', Icons.history),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((search) {
                return _buildRecentSearchChip(search);
              }).toList(),
            ),
            SizedBox(height: 24),
          ],
          _buildSectionTitle('Categorias Populares', Icons.category),
          SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: popularCategories.length,
            itemBuilder: (context, index) {
              final category = popularCategories[index];
              return _buildCategoryCard(category);
            },
          ),
          SizedBox(height: 24),
          _buildSectionTitle('Sugestões Populares', Icons.trending_up),
          SizedBox(height: 12),
          _buildPopularSuggestions(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Color(0xFFFA9500), size: 18),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3C4D18),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearchChip(String search) {
    bool isUserSearch = search.startsWith('@');
    return GestureDetector(
      onTap: () {
        _searchController.text = search;
        _searchController.selection = TextSelection.fromPosition(TextPosition(offset: _searchController.text.length));
        _searchFocusNode.requestFocus();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                isUserSearch ? Icons.person_outline : Icons.history,
                size: 16,
                color: isUserSearch ? Color(0xFFFA9500) : Color(0xFF999999)
            ),
            SizedBox(width: 8),
            Text(
              search,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                color: isUserSearch ? Color(0xFFFA9500) : Color(0xFF3C4D18),
                fontWeight: isUserSearch ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        _searchController.text = category['name'];
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: (category['color'] as Color).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  category['icon'],
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              category['name'],
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3C4D18),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSuggestions() {
    final suggestions = [
      'Sem açúcar',
      'Vegano',
      'Low carb',
      'Fit',
      'Rápido',
      'Fácil',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestions.map((suggestion) {
        return GestureDetector(
          onTap: () {
            _searchController.text = suggestion;
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFA9500).withOpacity(0.1),
                  Color(0xFFFF6B35).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFFFA9500).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department,
                    size: 14, color: Color(0xFFFA9500)),
                SizedBox(width: 6),
                Text(
                  suggestion,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFA9500),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoResults() {
    bool isUserSearch = _searchMode == _SearchMode.users;
    return Center(
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
              isUserSearch ? Icons.person_search_outlined : Icons.search_off,
              size: 64,
              color: Color(0xFFFA9500),
            ),
          ),
          SizedBox(height: 24),
          Text(
            isUserSearch ? 'Nenhum usuário encontrado' : 'Nenhuma receita encontrada',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 8),
          Text(
            isUserSearch ? 'Verifique o @username' : 'Tente buscar por outro termo',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
            },
            icon: Icon(Icons.refresh),
            label: Text('Limpar busca'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFA9500),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeResults(List<Map<String, dynamic>> recipes) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _buildRecipeCard(recipe);
      },
    );
  }

  Widget _buildUserResults(List<Map<String, dynamic>> users) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return GestureDetector(
      onTap: () {
        print('👤 User tapped: ${user['name']}');
        context.push('/profile/${user['id']}');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
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
        child: Row(
          children: [
            ProfileImageWidget(userData: user, radius: 28),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'],
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '@${user['username']}',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              children: [
                Text(
                  user['recipesCount'].toString(),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFFFA9500),
                  ),
                ),
                Text(
                  'Receitas',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return GestureDetector(
      onTap: () {
        print('🍳 Recipe tapped: ${recipe['name']}');
        context.push('/recipe/${recipe['id']}');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
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
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.horizontal(left: Radius.circular(20)),
                image: DecorationImage(
                  image: AssetImage(recipe['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(recipe['difficulty']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        recipe['difficulty'],
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['name'],
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF3C4D18),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            color: Color(0xFF999999), size: 13),
                        SizedBox(width: 4),
                        Text(
                          recipe['author'],
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFA9500), size: 14),
                        SizedBox(width: 4),
                        Text(
                          recipe['rating'].toString(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xFF3C4D18),
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.access_time,
                            color: Color(0xFF999999), size: 13),
                        SizedBox(width: 4),
                        Text(
                          recipe['time'],
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.local_fire_department,
                            color: Color(0xFFFA9500), size: 13),
                        SizedBox(width: 4),
                        Text(
                          '${recipe['calories']} cal',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFA9500),
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
              child: GestureDetector(
                onTap: () {
                  print('🔖 Bookmark: ${recipe['name']}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Receita salva!'),
                      backgroundColor: Color(0xFF7CB342),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bookmark_border,
                    color: Color(0xFFFA9500),
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Fácil':
        return Color(0xFF7CB342);
      case 'Médio':
        return Color(0xFFFA9500);
      case 'Difícil':
        return Color(0xFFE91E63);
      default:
        return Color(0xFF999999);
    }
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAdvancedFiltersModal(),
    );
  }

  Widget _buildAdvancedFiltersModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
                  'Filtros Avançados',
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
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tempo de Preparo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['Até 30min', '30-60min', '1h+'].map((time) {
                      return ChoiceChip(
                        label: Text(time),
                        selected: false,
                        onSelected: (selected) {},
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Dificuldade',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: ['Fácil', 'Médio', 'Difícil'].map((diff) {
                      return ChoiceChip(
                        label: Text(diff),
                        selected: false,
                        onSelected: (selected) {},
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Restrições Alimentares',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C4D18),
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Sem Lactose',
                      'Sem Glúten',
                      'Vegano',
                      'Vegetariano',
                      'Low Carb'
                    ].map((restriction) {
                      return FilterChip(
                        label: Text(restriction),
                        selected: false,
                        onSelected: (selected) {},
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Color(0xFFFA9500)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Limpar',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFA9500),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFA9500),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Aplicar Filtros',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}