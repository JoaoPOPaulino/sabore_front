import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/recipe_provider.dart';
import '../../../providers/recipe_book_provider.dart';
import '../../../widgets/profile_image_widget.dart';


class UserInfoScreen extends ConsumerWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return 'Recentemente';
    final months = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(currentUserDataProvider);

    if (userData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFFFA9500))),
      );
    }

    final userId = userData['id'] as int;
    final recipeCountAsync = ref.watch(userRecipeCountProvider(userId));
    final followersCountAsync = ref.watch(followersCountProvider(userId));
    final followingCountAsync = ref.watch(followingCountProvider(userId));
    final savedRecipesAsync = ref.watch(savedRecipesProvider(userId));

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFFFAFAFA),
            elevation: 0,
            pinned: true,
            expandedHeight: 260.0,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF7CB342),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            title: Text(
              'Informações',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color(0xFF3C4D18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Column(
                    children: [
                      ProfileImageWidget(userData: userData, radius: 50),
                      SizedBox(height: 16),
                      Text(
                        userData['name'] ?? 'Usuário',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Color(0xFF3C4D18),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '@${userData['username'] ?? 'username'}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildInfoSection(
                  'Email',
                  userData['email'] ?? 'Não informado',
                  Icons.email_outlined,
                  userData['emailVerified'] == true,
                ),
                _buildInfoSection(
                  'Telefone',
                  userData['phone'] ?? 'Não informado',
                  Icons.phone_outlined,
                  userData['phoneVerified'] == true,
                ),
                _buildInfoSection(
                  'Username',
                  userData['username'] ?? 'Não definido',
                  Icons.alternate_email,
                  true,
                ),
                _buildInfoSection(
                  'Membro desde',
                  _formatDate(userData['createdAt']),
                  Icons.calendar_today_outlined,
                  true,
                ),
                SizedBox(height: 30),
                Text(
                  'Estatísticas',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF3C4D18),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: recipeCountAsync.when(
                        data: (count) => _buildStatCard(
                          count.toString(),
                          'Receitas\npublicadas',
                          Icons.restaurant_menu,
                        ),
                        loading: () => _buildStatCard('...', 'Receitas\npublicadas', Icons.restaurant_menu),
                        error: (_, __) => _buildStatCard('0', 'Receitas\npublicadas', Icons.restaurant_menu),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: followersCountAsync.when(
                        data: (count) => _buildStatCard(
                          count.toString(),
                          'Total de\nseguidores',
                          Icons.people,
                        ),
                        loading: () => _buildStatCard('...', 'Total de\nseguidores', Icons.people),
                        error: (_, __) => _buildStatCard('0', 'Total de\nseguidores', Icons.people),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: savedRecipesAsync.when(
                        data: (recipes) => _buildStatCard(
                          recipes.length.toString(),
                          'Receitas\nsalvas',
                          Icons.bookmark,
                        ),
                        loading: () => _buildStatCard('...', 'Receitas\nsalvas', Icons.bookmark),
                        error: (_, __) => _buildStatCard('0', 'Receitas\nsalvas', Icons.bookmark),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: followingCountAsync.when(
                        data: (count) => _buildStatCard(
                          count.toString(),
                          'Seguindo',
                          Icons.person_add,
                        ),
                        loading: () => _buildStatCard('...', 'Seguindo', Icons.person_add),
                        error: (_, __) => _buildStatCard('0', 'Seguindo', Icons.person_add),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon, bool isVerified) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(15),
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
              icon,
              color: Color(0xFFFA9500),
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                    if (isVerified && (label == 'Email' || label == 'Telefone')) ...[
                      SizedBox(width: 6),
                      Icon(
                        Icons.verified,
                        size: 14,
                        color: Color(0xFF7CB342),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF3C4D18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFA9500).withOpacity(0.1),
            Color(0xFF7CB342).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xFFFA9500).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Color(0xFFFA9500),
            size: 28,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Color(0xFFFA9500),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: Color(0xFF666666),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}