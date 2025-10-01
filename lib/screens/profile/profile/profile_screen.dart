import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String selectedTab = 'Receitas';

  @override
  Widget build(BuildContext context) {
    final currentUserData = ref.watch(currentUserDataProvider);
    final bool isOwnProfile = widget.userId == currentUserData?['id'];

    // Se não é o próprio perfil, mostrar dados mockados (outros usuários)
    if (!isOwnProfile) {
      return _buildOtherUserProfile();
    }

    // Se é o próprio perfil mas não tem dados
    if (currentUserData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(currentUserData),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(currentUserData),
                _buildStatsSection(),
                _buildTabButtons(),
                _buildTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> userData) {
    final hasProfileImage = userData['profileImage'] != null;

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
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFA9500),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.bookmark_border, color: Colors.white, size: 20),
            onPressed: () => context.push('/recipe-books'),
          ),
        ),
        Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFA9500),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.settings, color: Colors.white, size: 20),
            onPressed: () => context.push('/settings'),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            image: hasProfileImage
                ? DecorationImage(
              image: FileImage(File(userData['profileImage'])),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            )
                : null,
            color: hasProfileImage ? null : Color(0xFFFA9500).withOpacity(0.3),
          ),
          child: !hasProfileImage
              ? Center(
            child: Icon(
              Icons.person,
              size: 100,
              color: Color(0xFFFA9500),
            ),
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> userData) {
    final hasProfileImage = userData['profileImage'] != null;

    return Container(
      transform: Matrix4.translationValues(0, -80, 0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 58,
              backgroundImage: hasProfileImage
                  ? FileImage(File(userData['profileImage']))
                  : null,
              backgroundColor: Color(0xFFF5F5F5),
              child: !hasProfileImage
                  ? Icon(Icons.person, size: 50, color: Color(0xFFFA9500))
                  : null,
            ),
          ),
          SizedBox(height: 12),
          Text(
            userData['username'] ?? 'Sem username',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 28,
              color: Color(0xFFFA9500),
            ),
          ),
          Text(
            userData['name'] ?? 'Usuário',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn('0', 'Receitas'),
          _buildStatColumn('0', 'Seguidores'),
          _buildStatColumn('0', 'Seguindo'),
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

  Widget _buildTabButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildTabButton('Receitas')),
          SizedBox(width: 8),
          Expanded(child: _buildTabButton('Galeria')),
          SizedBox(width: 8),
          Expanded(child: _buildTabButton('Avaliações')),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title) {
    bool isSelected = selectedTab == title;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = title),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFA9500) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Color(0xFFFA9500) : Color(0xFFE0E0E0),
          ),
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

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 'Receitas':
        return _buildEmptyState(
          icon: Icons.restaurant_menu,
          title: 'Nenhuma receita ainda',
          subtitle: 'Compartilhe suas receitas favoritas!',
          buttonText: 'Adicionar Receita',
          onPressed: () => context.push('/add-recipe'),
        );
      case 'Galeria':
        return _buildEmptyState(
          icon: Icons.photo_library,
          title: 'Galeria vazia',
          subtitle: 'Suas fotos aparecerão aqui',
        );
      case 'Avaliações':
        return _buildEmptyState(
          icon: Icons.star_border,
          title: 'Sem avaliações',
          subtitle: 'Suas avaliações aparecerão aqui',
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Color(0xFFE0E0E0),
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
    );
  }

  // Perfil de outros usuários (mockado)
  Widget _buildOtherUserProfile() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100, color: Color(0xFFE0E0E0)),
            SizedBox(height: 20),
            Text(
              'Perfil de outro usuário',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}