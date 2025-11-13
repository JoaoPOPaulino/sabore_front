// lib/screens/states_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sabore_app/providers/auth_provider.dart';
import 'package:sabore_app/providers/state_provider.dart';

import '../recipe/state_recipes_screen.dart';

class StatesScreen extends ConsumerStatefulWidget {
  const StatesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatesScreen> createState() => _StatesScreenState();
}

class _StatesScreenState extends ConsumerState<StatesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _selectedRegion = 'Todos';

  final List<String> _regions = [
    'Todos',
    'Norte',
    'Nordeste',
    'Centro-Oeste',
    'Sudeste',
    'Sul',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
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
    final statesAsync = _selectedRegion == 'Todos'
        ? ref.watch(brazilianStatesProvider)
        : ref.watch(statesByRegionProvider(_selectedRegion));

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

                // Filtro de Regiões
                _buildRegionFilter(),

                // Conteúdo principal
                Expanded(
                  child: statesAsync.when(
                    data: (states) => _buildStatesContent(states),
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
                            'Carregando estados...',
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
                            'Erro ao carregar estados',
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
            'Estados Brasileiros',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 32,
              color: Color(0xFF3C4D18),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Sabores de cada região 🇧🇷',
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

  Widget _buildRegionFilter() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        physics: BouncingScrollPhysics(),
        itemCount: _regions.length,
        itemBuilder: (context, index) {
          final region = _regions[index];
          final isSelected = region == _selectedRegion;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedRegion = region;
                _animationController.reset();
                _animationController.forward();
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [Color(0xFFFA9500), Color(0xFFFF6B35)],
                )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: isSelected ? null : Border.all(color: Color(0xFFE0E0E0)),
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
              child: Center(
                child: Text(
                  region,
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

  Widget _buildStatesContent(List<StateData> states) {
    if (states.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 80,
              color: Color(0xFFE0E0E0),
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum estado encontrado',
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
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 100,
      ),
      child: _buildDynamicMasonryGrid(states),
    );
  }

  Widget _buildDynamicMasonryGrid(List<StateData> states) {
    final maxCount = states.first.recipesCount.toDouble();
    final minCount = states.last.recipesCount.toDouble();

    return Column(
      children: _buildMasonryRows(states, maxCount, minCount),
    );
  }

  List<Widget> _buildMasonryRows(
      List<StateData> states,
      double maxCount,
      double minCount,
      ) {
    final List<Widget> rows = [];
    int index = 0;

    while (index < states.length) {
      final isEvenRow = (rows.length % 2 == 0);

      if (index < states.length) {
        final leftState = states[index];
        final rightState =
        index + 1 < states.length ? states[index + 1] : null;

        rows.add(
          _buildMasonryRow(
            leftState,
            rightState,
            maxCount,
            minCount,
            isEvenRow,
          ),
        );

        index += rightState != null ? 2 : 1;
      }
    }

    return rows;
  }

  Widget _buildMasonryRow(
      StateData leftState,
      StateData? rightState,
      double maxCount,
      double minCount,
      bool leftLarger,
      ) {
    final leftHeight = _calculateHeight(leftState.recipesCount, maxCount, minCount);
    final rightHeight = rightState != null
        ? _calculateHeight(rightState.recipesCount, maxCount, minCount)
        : 150.0;

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: leftLarger ? 3 : 2,
            child: _buildStateCard(
              leftState,
              leftHeight,
              0,
            ),
          ),
          if (rightState != null) ...[
            SizedBox(width: 12),
            Expanded(
              flex: leftLarger ? 2 : 3,
              child: _buildStateCard(
                rightState,
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
    const minHeight = 150.0;
    const maxHeight = 300.0;

    if (maxCount == minCount) return minHeight;

    final normalized = (count - minCount) / (maxCount - minCount);
    return minHeight + (normalized * (maxHeight - minHeight));
  }

  Widget _buildStateCard(
      StateData state,
      double height,
      int index,
      ) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.05,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // Ajustar tamanhos baseado na altura disponível
    final isSmallCard = height < 180;
    final emojiSize = isSmallCard ? 32.0 : (height > 200 ? 48.0 : 36.0);
    final titleSize = isSmallCard ? 16.0 : (height > 200 ? 22.0 : 18.0);
    final subtitleSize = isSmallCard ? 10.0 : 12.0;
    final contentPadding = isSmallCard ? 12.0 : 20.0;

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.3),
          end: Offset.zero,
        ).animate(animation),
        child: GestureDetector(
          onTap: () {
            print('🗺️ Estado tapped: ${state.name}');

            // Navegar para tela de receitas do estado
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StateRecipesScreen(
                  stateName: state.name,
                  stateEmoji: state.emoji,
                  stateColor: state.color,
                ),
              ),
            );
          },
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(state.color).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Imagem de fundo
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/chef.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Overlay com gradiente
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(state.color).withOpacity(0.4),
                            Color(state.color).withOpacity(0.9),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Badge de região
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallCard ? 8 : 10,
                        vertical: isSmallCard ? 4 : 6,
                      ),
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
                      child: Text(
                        state.region,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: isSmallCard ? 8 : 10,
                          fontWeight: FontWeight.w700,
                          color: Color(state.color),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  // Badge de quantidade
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallCard ? 8 : 10,
                        vertical: isSmallCard ? 4 : 6,
                      ),
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
                            size: isSmallCard ? 12 : 14,
                            color: Color(state.color),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${state.recipesCount}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: isSmallCard ? 10 : 12,
                              fontWeight: FontWeight.w700,
                              color: Color(state.color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Conteúdo - Ajustado para evitar overflow
                  Positioned(
                    left: contentPadding,
                    right: contentPadding,
                    bottom: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.emoji,
                          style: TextStyle(fontSize: emojiSize),
                        ),
                        SizedBox(height: isSmallCard ? 4 : 8),
                        Text(
                          state.name,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            fontSize: titleSize,
                            color: Colors.white,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isSmallCard ? 2 : 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: isSmallCard ? 12 : 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${state.recipesCount} receitas típicas',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: subtitleSize,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  void _showStateBottomSheet(StateData state) {
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
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(state.color),
                          Color(state.color).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Color(state.color).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      state.emoji,
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.name,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: Color(0xFF3C4D18),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(state.color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            state.region,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(state.color),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${state.recipesCount} receitas disponíveis',
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
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFFFA9500)),
                        SizedBox(width: 8),
                        Text(
                          'Receitas típicas em breve',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.construction,
                            size: 64,
                            color: Color(0xFFE0E0E0),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Em desenvolvimento',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
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
            _buildNavItem(Icons.search, false, () => context.push('/search')),
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